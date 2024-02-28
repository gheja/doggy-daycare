extends Node2D

const FINGER_LOCK_DISTANCE = 30
const FINGER_UNLOCK_DISTANCE = 100

var locked = false

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	
	if not locked:
		if Lib.dist_2d(mouse_position, self.global_position) < FINGER_LOCK_DISTANCE:
			locked = true
		else:
			return
	
	if Lib.dist_2d(mouse_position, self.global_position) > FINGER_UNLOCK_DISTANCE:
		locked = false
		return

	# self.global_position = mouse_position
	
	self.global_position = self.global_position + (mouse_position - self.global_position) * 0.25

func _unhandled_input(event):
#	if not locked:
#		if event is InputEventMouse:
#			print(event.position, " ", self.position)
#			if Lib.dist_2d(event.position, self.position) < 30:
#				locked = true
#
#	if event is InputEventMouseButton:
#		if not event.pressed:
#			locked = false
	pass
