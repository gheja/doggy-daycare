extends Node2D

const FINGER_LOCK_DISTANCE = 20
const FINGER_UNLOCK_DISTANCE = 100
const STEP_SOUND_INTERVAL = 12.5

var locked = false

var first_direction_tap = true
var keyboard_detected = false
var target_position = Vector2.ZERO
var total_distance_moved = 0.0
var last_step_sound_distance = 0.0
var step_count = 0

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
		
		# skip the first interaction to remain in center
		return
	
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

func play_footstep_sound():
	var players = $StepSounds.get_children()
	var n = step_count % players.size()
	var player: AudioStreamPlayer = players[n]
	
	player.stop()
	player.play()

func move_to_target():
	var new_global_position = self.global_position + (target_position - self.global_position) * 0.2
	
	total_distance_moved += Lib.dist_2d(self.global_position, new_global_position)
	
	self.global_position = new_global_position
	
	while total_distance_moved - last_step_sound_distance > STEP_SOUND_INTERVAL:
		last_step_sound_distance += STEP_SOUND_INTERVAL
		step_count += 1
		play_footstep_sound()

func _process(_delta):
	if GameState.state != GameState.GAME_STATE_PLAYING and GameState.state != GameState.GAME_STATE_UNLOCKED:
		return
	
	handle_keyboard_and_gamepad()
	if not keyboard_detected:
		handle_mouse_and_touch()
	move_to_target()
