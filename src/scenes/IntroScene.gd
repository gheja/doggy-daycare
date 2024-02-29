extends Node2D

func _on_Timer_timeout():
	Lib.get_narrator_object().speak_text(0)
	Signals.connect("speech_finished_text", self, "on_speech_finished_text")

func _ready():
	Signals.emit_signal("background_sounds_to_menu")

func on_speech_finished_text(_text_index):
	Signals.emit_signal("intro_finished")
