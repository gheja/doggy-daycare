extends Node2D

const MAX_DISTANCE = 60

var in_range = false
var dam_index: int = -1

var distance_correction = 1.0

func allocate_dam():
	var i = DirectionalAudioManager.allocate_dam()
	
	if i == -1:
		return false
	
	dam_index = i
	
	print("allocated ", dam_index)
	
	return true

func release_dam():
	if dam_index == -1:
		return
	
	print("releasing ", dam_index)
	
	DirectionalAudioManager.release_dam(dam_index)

func _ready():
	###
	### NOTE: all bus names should start with "directional_" and be muted at start!
	###
	
	$AudioStreamPlayer.pitch_scale = 1.0 + randf() * 0.2 - 0.1
	$AudioStreamPlayer.stream = AudioManager.get_dog_sleeping_sound()

func get_distance():
	return Lib.dist_2d(self.global_position, GameState.player_object.global_position) * distance_correction

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
	if GameState.state != GameState.GAME_STATE_PLAYING:
		return
	
	var distance = get_distance()
	
	if distance > MAX_DISTANCE:
		in_range = false
	else:
		in_range = true
	
	if not in_range:
		if $AudioStreamPlayer.playing:
			release_dam()
			$AudioStreamPlayer.stop()
			$Sprite.modulate = Color(0.0, 0.8, 1.0, 0.25)
		return
	
	if not $AudioStreamPlayer.playing:
		if not allocate_dam():
			$Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
			return
		
		$Sprite.modulate = Color(0.0, 0.8, 1.0, 1.0)
		$AudioStreamPlayer.bus = DirectionalAudioManager.get_bus_name(dam_index)
		$AudioStreamPlayer.play()
	
	DirectionalAudioManager.set_pan(dam_index, get_pan())
	DirectionalAudioManager.set_volume(dam_index, get_volume_from_distance(distance))

func stop_sound():
	self.release_dam()
