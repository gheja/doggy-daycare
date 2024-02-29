extends Node2D

export var level_intro_text_index = 5
export var level_first_lock_text_index = 11

var was_started = false

func _ready():
	GameState.state = GameState.GAME_STATE_PLAYING
	GameState.player_object = Lib.get_player_object()
	GameState.narrator_object = Lib.get_narrator_object()
	GameState.player_object.reset_to_start()
	
	Signals.emit_signal("game_starting")
	
	if GameState.first_play_on_this_level:
		# level intro message (long)
		Lib.get_narrator_object().speak_text(level_intro_text_index)
	else:
		# generic message (short)
		Lib.get_narrator_object().speak_text(6)
	
	$CameraContainer/Camera2D.current = true

func play_resume():
	Signals.emit_signal("background_sounds_to_level")
	
	if not was_started: 
		if GameState.first_play_on_this_level:
			Lib.get_narrator_object().speak_text(level_first_lock_text_index)
			GameState.first_play_on_this_level = false
		else:
			Lib.get_narrator_object().speak_text(11)
	else:
		# "thanks"
		Lib.get_narrator_object().speak_text(4)
	
	was_started = true

func play_pause():
	Lib.get_narrator_object().speak_text(7)
