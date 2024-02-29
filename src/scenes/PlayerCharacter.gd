extends Node2D

const FINGER_LOCK_DISTANCE = 20
const FINGER_UNLOCK_DISTANCE = 100

var locked = false

func reset_to_start():
	self.global_position = Vector2.ZERO

func _process(_delta):
	if GameState.state != GameState.GAME_STATE_PLAYING and GameState.state != GameState.GAME_STATE_UNLOCKED:
		return
	
	var mouse_position = get_global_mouse_position()
	
	if not locked:
		if Lib.dist_2d(mouse_position, self.global_position) < FINGER_LOCK_DISTANCE:
#			if GameState.first_game:
#				Signals.emit_signal("first_game_started")
#				GameState.first_game = false
			
			GameState.state = GameState.GAME_STATE_PLAYING
			Signals.emit_signal("finger_locked")
			locked = true
		else:
			return
	
	if Lib.dist_2d(mouse_position, self.global_position) > FINGER_UNLOCK_DISTANCE:
		GameState.state = GameState.GAME_STATE_UNLOCKED
		locked = false
		Signals.emit_signal("finger_unlocked")
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
