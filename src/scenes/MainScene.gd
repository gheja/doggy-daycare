extends Node2D

func _ready():
	Engine.set_target_fps(60)
	
	Signals.connect("player_won", self, "on_player_won")
	Signals.connect("player_lost", self, "on_player_lost")

func clear_sounds():
	# TODO: gradually lowering the volume of "sum_directional" might be much better
	
	for obj in get_tree().get_nodes_in_group("audio_source_objects"):
		obj.stop_sound()

func on_player_won():
	clear_sounds()
	GameState.state = GameState.GAME_STATE_WON

func on_player_lost():
	clear_sounds()
	GameState.state = GameState.GAME_STATE_LOST
