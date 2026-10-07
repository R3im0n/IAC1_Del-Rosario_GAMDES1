extends CharacterBody2D

var bullet = preload("res://scenes/bullet.tscn")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle

@onready var jump_sound: AudioStreamPlayer2D = $JumpSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

#@export makes it so you can change the values in the inspector tab
@export var SPEED : float = 1000.0
@export var SLOW_DOWN_SPEED : float = 2000.0 #sliding recoil
@export var MAX_HORIZONTAL_SPEED: float = 300.0 #delta time implementation
@export var JUMP_VELOCITY : float = -750.0

@export var GRAVITY : float = 1000

var alive = true
enum State {Idle, Running, Jumping, Shoot}
var current_state : State

var muzzle_position

func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position
	

	
func _physics_process(delta: float) -> void:
	
	#death
	if !alive:
		return
	# Add animation
	if is_on_floor():
		if velocity.x > 1 or velocity.x < -1:
			if animated_sprite_2d.animation != "run_shoot":
				animated_sprite_2d.play("run")
				current_state = State.Running
		elif velocity.y == 0:
			animated_sprite_2d.play("idle")
			current_state = State.Idle
	# Add the gravity.
	else:
		velocity += get_gravity() * delta
		animated_sprite_2d.play("jump")
		current_state = State.Jumping

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_sound.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x += direction * SPEED * delta
		velocity.x = clamp(velocity.x, -MAX_HORIZONTAL_SPEED, MAX_HORIZONTAL_SPEED) #delta time implementation
	else:
		velocity.x = move_toward(velocity.x, 0, SLOW_DOWN_SPEED * delta) #SLOW_DOWN_SPEED added for delta time
	
	#running while shooting
	if direction != 0 and Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.direction = direction
		bullet_instance.global_position = muzzle.global_position
		get_parent().add_child(bullet_instance)
		animated_sprite_2d.play("run_shoot")
		current_state = State.Shoot
	#muzzle direction
	elif direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = -muzzle_position.x
	#get rid of this if not needed. This is just for checking current player state
	#print("State: ", State.keys()[current_state])
	
	
	
	move_and_slide()
	
	if direction == 1.0:
		animated_sprite_2d.flip_h = false
	elif direction == -1.0:
		animated_sprite_2d.flip_h = true
	

func die() -> void:
	death_sound.play()
	animated_sprite_2d.animation = "death"
	alive = false

#Code blocks that I was trying 
#func update_animation(): 
	#if velocity.y != 0: 
		#if velocity.x != 0: 
			#animated_sprite_2d.play("run") 
		#else: 
			#animated_sprite_2d.play("idle") 
	#elif velocity.y < 0: 
		#animated_sprite_2d.play("jump") 

#func player_animations():
	#if current_state == State.Idle:
		#animated_sprite_2d.play("idle")
	#elif current_state == State.Running:
		#animated_sprite_2d.play("run")
	#elif current_state == State.Jumping:
		#animated_sprite_2d.play("jump")

#experimenting
#func input_movement(event):
	#if event.is_action_pressed("up"):
		#animated_sprite_2d.play("lookUp")
	#elif event.is_action_pressed("down"):
		#animated_sprite_2d.play("duck")
	
