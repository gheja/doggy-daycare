extends Node2D

func _ready():
	$AudioStreamPlayer2D.pitch_scale = 1.0 + randf() * 0.2 - 0.1
