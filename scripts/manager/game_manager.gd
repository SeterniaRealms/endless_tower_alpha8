extends Node2D


func _ready() -> void:
	$board_manager.setup_scene(GameController.level)
