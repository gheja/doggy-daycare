extends Node2D

func _ready():
	$Sprite.scale.x = 5000
	$Sprite.scale.y = 5000

func _process(_delta):
	$Sprite2.global_position = GameState.player_object.global_position
