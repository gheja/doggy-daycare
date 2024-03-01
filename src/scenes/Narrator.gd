extends Control

var texts = [
	[ # 0 - intro
		[ "Welcome to Doggy Daycare!", preload("res://assets/sounds/welcome_to_doggy_daycare_1709112390_tts-1_fable.ogg") ],
		[ "You are the owner of the daycare, having a dozen of dogs around you.", preload("res://assets/sounds/you_are_the_owner_of_the_daycare_having_a_dozen_of_dogs_around_you_1709112731_tts-1_fable.ogg") ],
		[ "They just finished a big play session and about to fall asleep.", preload("res://assets/sounds/they_just_finished_a_big_play_session_and_about_to_fall_asleep_1709112766_tts-1_fable.ogg") ],
	],
	[ # 1 - won
		[ "Great job, you made it to the hallway and all the dogs are asleep!", preload("res://assets/sounds/great_job_you_made_it_to_the_hallway_and_all_the_dogs_are_asleep_1709112145_tts-1_fable.ogg") ]
	],
	[ # 2 - lost
		[ "Oh, you woke up a dog. Better luck next time!", preload("res://assets/sounds/oh_you_woke_up_a_dog_better_luck_next_time_1709112185_tts-1_fable.ogg") ]
	],
	[ # 3 - finger locked (on first level)
		[ "Thanks!", preload("res://assets/sounds/thanks_1709115699_tts-1_fable.ogg") ],
		[ "Sssh. They are finally asleep.", preload("res://assets/sounds/sssh_they_are_finally_asleep_1709113008_tts-1_fable.ogg") ],
		[ "This is nice and quiet.", preload("res://assets/sounds/this_is_nice_and_quiet_1709163090_tts-1_fable.ogg") ],
		[ "You just noticed you played all afternoon and it's dark now and you're starving.", preload("res://assets/sounds/you_just_noticed_you_played_all_afternoon_and_it_s_dark_now_and_you_re_starving_1709170900_tts-1_fable.ogg") ],
		[ "The food is in the kitchen, across the hallway.", preload("res://assets/sounds/the_food_is_in_the_kitchen_across_the_hallway_1709170902_tts-1_fable.ogg") ],
		[ "You are in the middle of the room, try to reach the door without waking anyone up.", preload("res://assets/sounds/you_are_in_the_middle_of_the_room_try_to_reach_the_door_without_waking_anyone_up_1709163094_tts-1_fable.ogg") ],
		[ "Good luck!", preload("res://assets/sounds/good_luck_1709113278_tts-1_fable.ogg") ]
	],
	[ # 4 - finger locked (during level)
		[ "Thanks!", preload("res://assets/sounds/thanks_1709115699_tts-1_fable.ogg") ],
	],
	[ # 5 - level 1 start
		[ "When you're ready, either put your finger or mouse cursor to the middle of the screen and keep it there or...", preload("res://assets/sounds/when_you_re_ready_either_put_your_finger_or_mouse_cursor_to_the_middle_of_the_screen_and_keep_it_there_or_1709115696_tts-1_fable.ogg") ],
		[ "Tap a direction key on your keyboard or controller.", preload("res://assets/sounds/tap_a_direction_key_on_your_keyboard_or_controller_1709163088_tts-1_fable.ogg") ],
	],
	[ # 6 - level start, generic, short
		[ "Move your finger or cursor to the middle or press a direction key.", preload("res://assets/sounds/move_your_finger_or_cursor_to_the_middle_or_press_a_direction_key_1709163095_tts-1_fable.ogg") ],
	],
	[ # 7 - finger unlocked (during level)
		[ "Please move back where you were.", preload("res://assets/sounds/please_move_back_where_you_were_1709163335_tts-1_fable.ogg") ],
	],
	[ # 8 - level 2 start
		[ "On the second day you have even more dogs.", preload("res://assets/sounds/on_the_second_day_you_have_even_more_dogs_1709164954_tts-1_fable.ogg") ],
		[ "To start, move your finger or cursor to the middle or press a direction key.", preload("res://assets/sounds/to_start_move_your_finger_or_cursor_to_the_middle_or_press_a_direction_key_1709164952_tts-1_fable.ogg") ],
	],
	[ # 9 - level 3 start
		[ "On the second day you have even more dogs.", preload("res://assets/sounds/on_the_second_day_you_have_even_more_dogs_1709164954_tts-1_fable.ogg") ],
		[ "To start, move your finger or cursor to the middle or press a direction key.", preload("res://assets/sounds/to_start_move_your_finger_or_cursor_to_the_middle_or_press_a_direction_key_1709164952_tts-1_fable.ogg") ],
	],
	[ # 10 - thanks for playing
		[ "You just finished all levels, you are awesome!", preload("res://assets/sounds/you_just_finished_all_levels_you_are_awesome_1709170904_tts-1_fable.ogg") ],
		[ "Thank you so much for playing!", preload("res://assets/sounds/thank_you_so_much_for_playing_1709165483_tts-1_fable.ogg") ],
	],
	[ # 11 - finger locked (all levels, except first)
		[ "Thanks!", preload("res://assets/sounds/thanks_1709115699_tts-1_fable.ogg") ],
		[ "You are in the middle of the room, try to reach the door without waking anyone up.", preload("res://assets/sounds/you_are_in_the_middle_of_the_room_try_to_reach_the_door_without_waking_anyone_up_1709163094_tts-1_fable.ogg") ],
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
