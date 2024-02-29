extends Node

export var volume_min = -80.0
export var volume_max = -25.0
export var random_chance_min = 0.0
export var random_chance_max = 1.0

var volume = -100.0
var volume_target = -100.0

var random_sound_chance = 0.0
var random_sound_chance_target = 0.0

func fade_in():
	volume_target = volume_max
	random_sound_chance_target = random_chance_max

func fade_out():
	volume_target = volume_min
	random_sound_chance = random_chance_min

#func ramp_up():
#	random_sound_chance_target = 1.0
#
#func ramp_down():
#	random_sound_chance_target = 0.0

func _ready():
	for player in $LoopSounds.get_children():
		player.volume_db = -100.0
		player.play()

func _process(_delta):
	random_sound_chance = random_sound_chance + (random_sound_chance_target - random_sound_chance) * 0.005
	volume = volume + (volume_target - volume) * 0.03
	
	for player in $LoopSounds.get_children():
		player.volume_db = volume
	
	for group in $RandomSounds.get_children():
		for player in group.get_children():
			player.volume_db = volume

func play_random_sound():
	var groups = $RandomSounds.get_children()
	
	if groups.size() == 0:
		return
	
	groups.shuffle()
	
	for group in groups:
		var group_active = false
		var players = group.get_children()
		
		if players.size() == 0:
			return
		
		for player in players:
			if player.playing:
				group_active = true
				break
		
		if group_active:
			continue
		
		players.shuffle()
		players[0].play()
		break

func _on_RandomSoundsTimer_timeout():
	if randf() <= random_sound_chance:
		play_random_sound()
