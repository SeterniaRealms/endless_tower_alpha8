extends CanvasLayer

@onready var controls_text_panel: Panel = $Control/controls_text_panel
@onready var gameplay_text_panel: Panel = $Control/gameplay_text_panel

func _ready() -> void:
	controls_text_panel.hide()
	gameplay_text_panel.hide()

func _on_button_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_game.tscn")

func _on_controls_button_pressed() -> void:
	gameplay_text_panel.hide()
	controls_text_panel.show()


func _on_gameplay_button_pressed() -> void:
	controls_text_panel.hide()
	gameplay_text_panel.show()
