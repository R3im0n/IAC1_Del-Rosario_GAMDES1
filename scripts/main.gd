extends Node2D
#main node handles all logic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.44,0.12,0.53,1.00))
	#diable comment when player_died signal is created properly
	#_setup_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#diable comment when player_died signal is created properly
#func _setup_level() -> void:
	##connect enemies
	#var enemies = $LevelRoot.get_node_or_null("Enemies")
	#if enemies:
		#for enemy in enemies.get_children():
			#enemy.player_died.connect(_on_player_died)


#SIGNAL HANDLERS
func _on_player_died(body):
	body.die()
	print("Player killed")
