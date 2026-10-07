extends CharacterBody2D

var enemy_death_effect = preload("res://scenes/enemy_death_effect.tscn")

@export var patrol_points : Node
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

@export var GRAVITY: float = 1000.0
@export var SPEED : float = 1500.0
@export var wait_time : int = 3

enum State {Idle, Walk}
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_postions : Array[Vector2]
var current_point : Vector2
var current_point_postion : int
var can_walk : bool

@export var health: int = 3

func _ready():
	#patrolling function
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_postions.append(point.global_position)
		current_point = point_postions[current_point_postion]
	else:
		print("No points")
	
	timer.wait_time = wait_time
	
	current_state = State.Idle
	
func _physics_process(delta: float) -> void:
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()
	
	enemy_animations()
	
func enemy_gravity(delta: float):
	velocity.y += GRAVITY * delta

func enemy_idle(delta: float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		current_state = State.Idle

func enemy_walk(delta: float):
	if !can_walk:
		return
	if abs(position.x -current_point.x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = State.Walk
	else:
		current_point_postion += 1
	
		if current_point_postion >= number_of_points:
			current_point_postion = 0
		
		current_point = point_postions[current_point_postion]
	
		if current_point.x > position.x:
			direction = Vector2.RIGHT
			animated_sprite_2d.flip_h = true
		else:
			direction = Vector2.LEFT
			animated_sprite_2d.flip_h = false
	
		can_walk = false
		timer.start()

func enemy_animations():
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("walk")
		

func _on_timer_timeout() -> void:
	can_walk = true
	

func _on_hitbox_area_entered(area: Area2D):
	print("Hitbox  entered")
	if area.get_parent().has_method("get_damage"):
		var node = area.get_parent() as Node
		health -= node.damage
		print("Crab Health: ", health)
		
		if health <= 0:
			var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instance.global_position = global_position
			get_parent().add_child(enemy_death_effect_instance)
			queue_free()
