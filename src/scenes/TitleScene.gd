extends Node2D


func _on_Timer_timeout():
	Lib.get_narrator_object().speak_text(0)
