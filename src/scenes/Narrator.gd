extends Control

var texts = [
	[ # 0
		[ "Welcome to Doggy Daycare!", preload("res://assets/sounds/welcome_to_doggy_daycare_1709112390_tts-1_fable.ogg") ],
		[ "You are the owner of the daycare, having a dozen of dogs around you.", preload("res://assets/sounds/you_are_the_owner_of_the_daycare_having_a_dozen_of_dogs_around_you_1709112731_tts-1_fable.ogg") ],
		[ "They just finished a big play session and about to fall asleep.", preload("res://assets/sounds/they_just_finished_a_big_play_session_and_about_to_fall_asleep_1709112766_tts-1_fable.ogg") ],
		[ "When you're ready, either put your finger or mouse cursor to the middle of the screen and keep it there or...", preload("res://assets/sounds/when_you_re_ready_either_put_your_finger_or_mouse_cursor_to_the_middle_of_the_screen_and_keep_it_there_or_1709115696_tts-1_fable.ogg") ],
		[ "Tap a directional key on your keyboard or controller.", preload("res://assets/sounds/tap_a_directional_key_on_your_keyboard_or_controller_1709115698_tts-1_fable.ogg") ],
	],
	[ # 1
		[ "Great job, you made it to the hallway and all the dogs are asleep!", preload("res://assets/sounds/great_job_you_made_it_to_the_hallway_and_all_the_dogs_are_asleep_1709112145_tts-1_fable.ogg") ]
	],
	[ # 2
		[ "Oh, you woke up a dog. Better luck next time!", preload("res://assets/sounds/oh_you_woke_up_a_dog_better_luck_next_time_1709112185_tts-1_fable.ogg") ]
	],
	[ # 3
		[ "Sssh. They are finally asleep.", preload("res://assets/sounds/sssh_they_are_finally_asleep_1709113008_tts-1_fable.ogg") ],
		[ "This is nice and quiet, but you just remembered something...", preload("res://assets/sounds/this_is_nice_and_quiet_but_you_just_remembered_something_1709113100_tts-1_fable.ogg") ],
		[ "You need to go to the hallway for something.", preload("res://assets/sounds/you_need_to_go_to_the_hallway_for_something_1709113235_tts-1_fable.ogg") ],
		[ "You are in the middle of the room, try to reach the door without waking up anyone.", preload("res://assets/sounds/you_are_in_the_middle_of_the_room_try_to_reach_the_door_without_waking_up_anyone_1709113269_tts-1_fable.ogg") ],
		[ "Good luck!", preload("res://assets/sounds/good_luck_1709113278_tts-1_fable.ogg") ]
	],
	[ # 4
		[ "Thanks!", preload("res://assets/sounds/thanks_1709115699_tts-1_fable.ogg") ],
	]
]

var text_index = -1
var text_sentence_index = -1

func speak_next_sentence():
	if text_index == -1:
		return
	
	text_sentence_index += 1
	
	if text_sentence_index >= texts[text_index].size():
		text_index = -1
		text_sentence_index = -1
		$SubtitleContainer/SubtitleLabel.text = ""
		return
	
	var a = texts[text_index][text_sentence_index]
	
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.stream = a[1]
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
