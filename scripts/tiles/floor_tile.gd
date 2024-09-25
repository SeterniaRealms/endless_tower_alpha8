extends AnimatedSprite2D

var floor_tile := ["01", "02", "03","04","05", "06"]

func _ready() -> void:
	randomize()
	play(floor_tile[randi() % floor_tile.size()])
