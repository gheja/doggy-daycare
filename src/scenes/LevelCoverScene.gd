extends Node2D

func _ready():
	$Sprite.scale.x = 5000
	$Sprite.scale.y = 5000
	
	Signals.connect("player_lost", self, "on_game_ended")
	Signals.connect("player_won", self, "on_game_ended")
	Signals.connect("game_starting", self, "on_game_starting")

func _process(_delta):
	if GameState.state != GameState.GAME_STATE_PLAYING:
		return
	
	$Sprite2.global_position = GameState.player_object.global_position

func on_game_starting():
	$AnimationPlayer.play("fade_in")

func on_game_ended():
	$AnimationPlayer.play("fade_out")
