extends Node2D

var top_left = Vector2.ZERO
var bottom_right = Vector2.ZERO
var border_size = Vector2(15, 15)

func update_boundaries():
	var rect = $Sprite.get_rect()
	top_left = self.global_position + rect.position + border_size
	bottom_right = top_left + rect.size - border_size * 2

func randomize_color():
	randomize()
	$Sprite.modulate = Color().from_hsv(randf(), 1.0, 0.25 + randf() * 0.25)

func _ready():
	randomize_color()
	update_boundaries()

func _process(_delta):
	var mouse_position = get_global_mouse_position()
	
	$AudioSourceObject.global_position.x = min(max(mouse_position.x, top_left.x), bottom_right.x)
	$AudioSourceObject.global_position.y = min(max(mouse_position.y, top_left.y), bottom_right.y)
