extends Node2D

func _ready():
	GameState.state = GameState.GAME_STATE_PLAYING
	GameState.player_object = Lib.get_player_object()
	# GameState.player_object.global_position = Vector2(0.0, 0.0)
