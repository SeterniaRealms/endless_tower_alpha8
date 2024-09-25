extends StaticBody2D

var outer_wall : Array = ["01"]

func _ready() -> void:
	randomize()
	var outer_wall_temp = randi() % outer_wall.size()
	$animated_sprite.play(outer_wall[outer_wall_temp])
