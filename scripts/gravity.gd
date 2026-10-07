extends Node

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

@export var GRAVITY: float = 1000.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.y += GRAVITY * delta
	
	character_body_2d.move_and_slide()
