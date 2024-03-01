extends Node2D

func _on_Area2D_area_entered(area: Area2D):
	if not area.is_in_group("player_hitboxes"):
		return
	
	$AudioStreamPlayer2D.play()
	Signals.emit_signal("player_lost")

func _on_Area2DWarn_area_entered(area: Area2D):
	if not area.is_in_group("player_hitboxes"):
		return
	
	$AudioStreamPlayer2D2.play()
