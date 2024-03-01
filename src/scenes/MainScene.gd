extends Node

var levels = [
	"res://scenes/Level1.tscn",
	"res://scenes/Level2.tscn",
	"res://scenes/Level3.tscn",
]

var level_index = -1
var level_base_object = null
var next_scene_to_load = null

func _ready():
	Engine.set_target_fps(60)
	
	DirectionalAudioManager.init()
	DirectionalAudioManager.start()
	
	Signals.connect("player_won", self, "on_player_won")
	Signals.connect("player_lost", self, "on_player_lost")
	Signals.connect("first_game_started", self, "on_first_game_started")
	Signals.connect("intro_finished", self, "on_intro_finished")
	Signals.connect("finger_locked", self, "on_finger_locked")
	Signals.connect("finger_unlocked", self, "on_finger_unlocked")
	Signals.connect("speech_finished_text", self, "on_speech_finished_text")
	Signals.connect("background_sounds_to_menu", self, "on_background_sounds_to_menu")
	Signals.connect("background_sounds_to_level", self, "on_background_sounds_to_level")
	Signals.connect("background_sounds_to_excited", self, "on_background_sounds_to_excited")
	
	load_scene_deferred("res://scenes/IntroScene.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("action_debug"):
		$LevelCoverScene.modulate = Color(1.0, 1.0, 1.0, 0.75)

func load_scene(path):
	var tmp = load(path).instance()
	$SceneContainer.add_child(tmp)
	level_base_object = Lib.get_first_group_member("level_base_objects")

func load_scene_deferred(path):
	for obj in $SceneContainer.get_children():
		obj.queue_free()
	
	next_scene_to_load = path
	
	$SceneLoaderTimer.start()

func clear_sounds():
	# TODO: gradually lowering the volume of "sum_directional" might be much better
	
	for obj in get_tree().get_nodes_in_group("audio_source_objects"):
		obj.stop_sound()

func load_level(n: int):
	if level_index != n:
		GameState.first_play_on_this_level = true
	
	level_index = n
	load_scene_deferred(levels[level_index])
	

func reload_level():
	load_level(level_index)

func load_next_level():
	print("Load next level")
	if level_index >= levels.size() - 1:
		Lib.get_narrator_object().speak_text(10)
		return
	
	load_level(level_index + 1)

func on_player_won():
	clear_sounds()
	Lib.get_narrator_object().speak_text(1)
	GameState.state = GameState.GAME_STATE_WON
	Signals.emit_signal("background_sounds_to_menu")

func on_player_lost():
	clear_sounds()
	# to give a bit of time for the excited dogs sound :)
	$PlayerLostNarrationTimer.start()
	$PlayerLostSounds.play()
	GameState.state = GameState.GAME_STATE_LOST
	Signals.emit_signal("background_sounds_to_excited")

func on_first_game_started():
	Lib.get_narrator_object().speak_text(3)

func on_intro_finished():
	load_level(0)

func on_finger_locked():
	if not level_base_object:
		return
	
	level_base_object.play_resume()

func on_finger_unlocked():
	if not level_base_object:
		return
	
	level_base_object.play_pause()

func on_speech_finished_text(text_index):
	print("MainScene.on_speech_finished_text(): text_index: ", text_index)
	
	if text_index == 1: # won
		$LevelLoadTimer.start()
		# load_next_level()
	
	if text_index == 2: # lost
		$LevelLoadTimer.start()
		# reload_level()

func _on_SceneLoaderTimer_timeout():
	if not next_scene_to_load:
		return
	
	load_scene(next_scene_to_load)
	next_scene_to_load = null

func on_background_sounds_to_menu():
	print("on_background_sounds_to_menu")
	$BackgroundEffectsMenu.fade_in()
	$BackgroundEffectsLevel.fade_out()
	$BackgroundEffectsExcited.fade_out()
	
	$BackgroundEffectsChangeTimer.stop()

func on_background_sounds_to_level():
	print("on_background_sounds_to_level")
	$BackgroundEffectsMenu.fade_out()
	$BackgroundEffectsLevel.fade_in()
	$BackgroundEffectsExcited.fade_out()
	
	$BackgroundEffectsChangeTimer.stop()

func on_background_sounds_to_excited():
	print("on_background_sounds_to_excited")
	$BackgroundEffectsMenu.fade_out()
	$BackgroundEffectsLevel.fade_out()
	$BackgroundEffectsExcited.fade_in()
	
	$BackgroundEffectsChangeTimer.start()

func _on_BackgroundEffectsChangeTimer_timeout():
	on_background_sounds_to_menu()

func _on_LevelLoadTimer_timeout():
	if GameState.state == GameState.GAME_STATE_WON:
		load_next_level()
	elif  GameState.state == GameState.GAME_STATE_LOST:
		reload_level()

func _on_PlayerLostNarrationTimer_timeout():
	Lib.get_narrator_object().speak_text(2)
