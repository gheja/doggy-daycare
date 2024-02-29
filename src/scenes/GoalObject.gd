extends Node2D

func _on_Area2D_area_entered(area):
	Signals.emit_signal("player_won")

func _ready():
	$AudioSourceObject/AudioStreamPlayer.stream = preload("res://assets/sounds/background_noises/28204__sagetyrtle__restaurant2.ogg")
	$AudioSourceObject.distance_correction = 0.25
