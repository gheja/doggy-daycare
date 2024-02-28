extends Node

func _ready():
	Engine.set_target_fps(60)
	
	Signals.connect("player_won", self, "on_player_won")
	Signals.connect("player_lost", self, "on_player_lost")
	Signals.connect("first_game_started", self, "on_first_game_started")

func clear_sounds():
	# TODO: gradually lowering the volume of "sum_directional" might be much better
	
	for obj in get_tree().get_nodes_in_group("audio_source_objects"):
		obj.stop_sound()

func on_player_won():
	clear_sounds()
	Lib.get_narrator_object().speak_text(1)
	GameState.state = GameState.GAME_STATE_WON

func on_player_lost():
	clear_sounds()
	Lib.get_narrator_object().speak_text(2)
	GameState.state = GameState.GAME_STATE_LOST

func on_first_game_started():
	Lib.get_narrator_object().speak_text(3)
