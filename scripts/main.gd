extends Control
class_name Main

@export_category("Objects")
@warning_ignore("unused_private_class_variable")
@export var _name: LineEdit = null
@warning_ignore("unused_private_class_variable")
@export var _floor: LineEdit = null

#FUNC TO SHOW THE FLOOR THAT THE PLAYER HAS REACHED
func _ready() -> void:
	var message = "You survived %s floors." % GameController.level
	$label_message.text = message


func _on_submit_button_pressed() -> void:
	SilentWolf.Scores.save_score(_name.text, $label_message.text)
	pass # Replace with function body.

