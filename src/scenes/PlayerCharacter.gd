extends Node2D

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	
	# self.global_position = mouse_position
	
	self.global_position = self.global_position + (mouse_position - self.global_position) * 0.25
