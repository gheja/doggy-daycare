extends Node2D

const FINGER_LOCK_DISTANCE = 20
const FINGER_UNLOCK_DISTANCE = 100

var locked = false

var first_direction_tap = true
var keyboard_detected = false
var target_position = Vector2.ZERO

func reset_to_start():
	self.global_position = Vector2.ZERO

func handle_keyboard_and_gamepad():
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	
	if direction == Vector2.ZERO:
		return
	
	if not keyboard_detected:
		keyboard_detected = true
		target_position = self.global_position
		GameState.state = GameState.GAME_STATE_PLAYING
		Signals.emit_signal("finger_locked")
	
	
	target_position += direction * 25
	
	# snap to grid
	target_position.x = int(target_position.x / 25) * 25
	target_position.y = int(target_position.y / 25) * 25

func handle_mouse_and_touch():
	var mouse_position = get_global_mouse_position()
	
	if not locked:
		if Lib.dist_2d(mouse_position, self.global_position) < FINGER_LOCK_DISTANCE:
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
	
	target_position = mouse_position

func move_to_target():
	self.global_position += (target_position - self.global_position) * 0.25

func _process(_delta):
	if GameState.state != GameState.GAME_STATE_PLAYING and GameState.state != GameState.GAME_STATE_UNLOCKED:
		return
	
	handle_keyboard_and_gamepad()
	handle_mouse_and_touch()
	move_to_target()

