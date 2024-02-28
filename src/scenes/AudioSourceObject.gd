extends Node2D

const MAX_DISTANCE = 60

var valid_bus_indexes = []

var in_range = false
var panner: AudioEffectPanner = null
var panner_effect_index: int = -1
var bus_index: int = -1
var target_pan: float = 0.0

func init_valid_bus_indexes():
	var s: String
	
	valid_bus_indexes.clear()
	
	for i in range(AudioServer.bus_count):
		s = AudioServer.get_bus_name(i)
		
		if s.substr(0, 12) == "directional_":
			valid_bus_indexes.append(i)

func allocate_bus():
	for i in valid_bus_indexes:
		if AudioServer.is_bus_mute(i):
			bus_index = i
			panner_effect_index = AudioServer.get_bus_effect_count(bus_index)
			AudioServer.add_bus_effect(bus_index, panner)
			# AudioServer.set_bus_volume_db(bus_index, -100)
			AudioServer.set_bus_mute(i, false)
			# print("Allocated ", i)
			return true
	
	return false

func release_bus():
	if bus_index == -1:
		return
	
	AudioServer.set_bus_mute(bus_index, true)
	if AudioServer.get_bus_effect_count(bus_index) > 0:
		AudioServer.remove_bus_effect(bus_index, panner_effect_index)
	# print("Released ", bus_index)

func _ready():
	###
	### NOTE: all bus names should start with "directional_" and be muted at start!
	###
	
	init_valid_bus_indexes()
	$AudioStreamPlayer.pitch_scale = 1.0 + randf() * 0.2 - 0.1
	panner = AudioEffectPanner.new()

func get_distance():
	return Lib.dist_2d(self.global_position, GameState.player_object.global_position)

func get_volume_from_distance(distance: float):
	# brought to you by guessing till sounds about right
	# return min(- log(distance / 15) * 100, 0.0)
	
	# target points
	# 40: -100
	# 28: -20
	# 20: 0
	#
	# curve via https://mycurvefit.com/ using "power curve", thanks!
	return min(-0.000002619074 * pow(distance, 4.732926), 0.0)

func get_pan():
	# x (sound source is ...)
	# -pi (right) .. -pi/2 (below) .. 0.0 (left) .. pi/2 (above) .. pi (right)
	var a = GameState.player_object.global_position.angle_to_point(self.global_position)
	
	# panner: -1.0 (left) .. 0.0 (center) .. 1.0 (right)
	var b = (abs(a) / PI) * 2 - 1.0
	
	# print(a, " ", b)
	
	return b

func smooth(a: float, b: float):
	return a + (b - a) * 0.025

func _process(_delta):
	var distance = get_distance()
	
	if distance > MAX_DISTANCE:
		in_range = false
	else:
		in_range = true
	
	if not in_range:
		if $AudioStreamPlayer.playing:
			release_bus()
			$AudioStreamPlayer.stop()
			$Sprite.modulate = Color(0.0, 0.8, 1.0, 0.25)
		return
	
	target_pan = get_pan()
	
	if not $AudioStreamPlayer.playing:
		$AudioStreamPlayer.volume_db = -100
		
		if not allocate_bus():
			$Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
			return
		
		$Sprite.modulate = Color(0.0, 0.8, 1.0, 1.0)
		$AudioStreamPlayer.bus = AudioServer.get_bus_name(bus_index)
		$AudioStreamPlayer.play()
		
		# start the sound from the correct position
		panner.pan = target_pan
	
	# this is smooth enough, and also would just cut when too far (maybe max distance should be adjusted)
	$AudioStreamPlayer.volume_db = get_volume_from_distance(distance)
	
	# it works but very choppy, even with smooth(), even when updated in
	# _physics_process(), even when updated by a low interval Timer
	panner.pan = target_pan
	# panner.pan = smooth(panner.pan, target_pan)

func stop_sound():
	self.release_bus()
