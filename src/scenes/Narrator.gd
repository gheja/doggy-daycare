extends Control

var texts = [
	[ # 0 - intro
		[ "Welcome to Doggy Daycare!", preload("res://assets/sounds/narrator/welcome_to_doggy_daycare_1709260221_tts-1-hd_fable.ogg") ],
		[ "You are the owner of the place and have a dozen dogs around you.", preload("res://assets/sounds/narrator/you_are_the_owner_of_the_place_and_have_a_dozen_dogs_around_you_1709260224_tts-1-hd_fable.ogg") ],
		[ "They just finished playing and are about to fall asleep.", preload("res://assets/sounds/narrator/they_just_finished_playing_and_are_about_to_fall_asleep_1709260225_tts-1-hd_fable.ogg") ],
	],
	[ # 1 - won
		[ "Great job! You made it to the hallway and all the dogs are asleep!", preload("res://assets/sounds/narrator/great_job_you_made_it_to_the_hallway_and_all_the_dogs_are_asleep_1709261379_tts-1-hd_fable.ogg") ],
	],
	[ # 2 - lost
		[ "Oh... You woke up the dogs. Better luck next time!", preload("res://assets/sounds/narrator/oh_you_woke_up_the_dogs_better_luck_next_time_1709260413_tts-1-hd_fable.ogg") ],
	],
	[ # 3 - finger locked (on first level)
		[ "Thanks!", preload("res://assets/sounds/narrator/thanks_1709260333_tts-1-hd_fable.ogg") ],
		[ "Sssh. They are finally asleep.", preload("res://assets/sounds/narrator/sssh_they_are_finally_asleep_1709260345_tts-1-hd_fable.ogg") ],
		[ "You just realized you played all afternoon and it's dark now and you're starving.", preload("res://assets/sounds/narrator/you_just_realized_you_played_all_afternoon_and_it_s_dark_now_and_you_re_starving_1709260357_tts-1-hd_fable.ogg") ],
		[ "The food is in the kitchen, across the hallway.", preload("res://assets/sounds/narrator/the_food_is_in_the_kitchen_across_the_hallway_1709260369_tts-1-hd_fable.ogg") ],
		[ "You are in the middle of the room, try to reach the door without waking anyone up.", preload("res://assets/sounds/narrator/you_are_in_the_middle_of_the_room_try_to_reach_the_door_without_waking_anyone_up_1709261333_tts-1-hd_fable.ogg") ],
		[ "Good luck!", preload("res://assets/sounds/narrator/good_luck_1709260391_tts-1-hd_fable.ogg") ],
	],
	[ # 4 - finger locked (during level)
		[ "Thanks!", preload("res://assets/sounds/narrator/thanks_1709260333_tts-1-hd_fable.ogg") ],
	],
	[ # 5 - level 1 start
		[ "When you're ready, either put your finger or mouse cursor to the center of the screen and keep it there or...", preload("res://assets/sounds/narrator/when_you_re_ready_either_put_your_finger_or_mouse_cursor_to_the_center_of_the_screen_and_keep_it_there_or_1709260309_tts-1-hd_fable.ogg") ],
		[ "Tap a direction key on your keyboard or controller.", preload("res://assets/sounds/narrator/tap_a_direction_key_on_your_keyboard_or_controller_1709260321_tts-1-hd_fable.ogg") ],
	],
	[ # 6 - level start, generic, short
		[ "Move your finger or cursor to the center or press a direction key.", preload("res://assets/sounds/narrator/move_your_finger_or_cursor_to_the_center_or_press_a_direction_key_1709260435_tts-1-hd_fable.ogg") ],
	],
	[ # 7 - finger unlocked (during level)
		[ "Please move back where you were.", preload("res://assets/sounds/narrator/please_move_back_where_you_were_1709261401_tts-1-hd_fable.ogg") ],
	],
	[ # 8 - level 2 start
		[ "On the second day you have even more dogs.", preload("res://assets/sounds/narrator/on_the_second_day_you_have_even_more_dogs_1709260457_tts-1-hd_fable.ogg") ],
		[ "To start, move your finger or cursor to the center or press a direction key.", preload("res://assets/sounds/narrator/to_start_move_your_finger_or_cursor_to_the_center_or_press_a_direction_key_1709261423_tts-1-hd_fable.ogg") ],
	],
	[ # 9 - level 3 start
		[ "On the third day there are a few squeaky toys left around.", preload("res://assets/sounds/narrator/on_the_third_day_there_are_a_few_squeaky_toys_left_around_1709260469_tts-1-hd_fable.ogg") ],
		[ "To start, move your finger or cursor to the center or press a direction key.", preload("res://assets/sounds/narrator/to_start_move_your_finger_or_cursor_to_the_center_or_press_a_direction_key_1709261423_tts-1-hd_fable.ogg") ],
	],
	[ # 10 - thanks for playing
		[ "You just finished all levels, you are awesome!", preload("res://assets/sounds/narrator/you_just_finished_all_levels_you_are_awesome_1709261445_tts-1-hd_fable.ogg") ],
		[ "Thank you so much for playing!", preload("res://assets/sounds/narrator/thank_you_so_much_for_playing_1709260491_tts-1-hd_fable.ogg") ],
	],
	[ # 11 - finger locked (all levels, except first)
		[ "Thanks!", preload("res://assets/sounds/narrator/thanks_1709260333_tts-1-hd_fable.ogg") ],
		[ "You are in the middle of the room, try to reach the door without waking anyone up.", preload("res://assets/sounds/narrator/you_are_in_the_middle_of_the_room_try_to_reach_the_door_without_waking_anyone_up_1709261333_tts-1-hd_fable.ogg") ],
	]
]

var text_index = -1
var text_sentence_index = -1

func speak_next_sentence():
	if text_index == -1:
		return
	
	if text_sentence_index > -1:
		Signals.emit_signal("speech_finished_sentence")
	
	text_sentence_index += 1
	
	if text_sentence_index >= texts[text_index].size():
		var tmp = text_index
		text_index = -1
		text_sentence_index = -1
		$SubtitleContainer/SubtitleLabel.text = ""
		Signals.emit_signal("speech_finished_text", tmp)
		return
	
	var a = texts[text_index][text_sentence_index]
	
	print("Narrator ", text_index, " ", text_sentence_index)
	
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = a[1]
	# $AudioStreamPlayer.pitch_scale = 4
	$AudioStreamPlayer.play()
	
	$SubtitleContainer/SubtitleLabel.text = a[0]

func on_play_finished():
	$SpeakTimer.start()

func speak_text(n: int):
	text_index = n
	text_sentence_index = -1
	speak_next_sentence()

func _ready():
	$SubtitleContainer/SubtitleLabel.text = ""
	$AudioStreamPlayer.connect("finished", self, "on_play_finished")

func _on_SpeakTimer_timeout():
	speak_next_sentence()
