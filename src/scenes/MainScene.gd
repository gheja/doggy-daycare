extends Node

var levels = [
	"res://scenes/Level1.tscn",
	"res://scenes/Level2.tscn"
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
	
	load_scene_deferred("res://scenes/IntroScene.tscn")

func _process(_delta):
	pass

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

func on_player_lost():
	clear_sounds()
	Lib.get_narrator_object().speak_text(2)
	GameState.state = GameState.GAME_STATE_LOST

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
		load_next_level()
	
	if text_index == 2: # lost
		reload_level()

func _on_SceneLoaderTimer_timeout():
	if not next_scene_to_load:
		return
	
	load_scene(next_scene_to_load)
	next_scene_to_load = null
