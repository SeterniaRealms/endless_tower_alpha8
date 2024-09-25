extends CanvasLayer
class_name Leaderboard

@export_category("Objects")
@export var _ranking_container: VBoxContainer = null
@onready var update_leaderboard = $Control/update_leaderboard
@onready var _load_progress = $Control/load_progress

var ldboard_name = "alpha_test2"


#MENU BUTTON
func _on_button_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_game.tscn")
	

func _on_update_leaderboard_pressed():
	_load_progress.show()
	update_leaderboard.hide()
	
	var _sw_result: Dictionary = await SilentWolf.Scores.get_scores(0, "alpha_test2").sw_get_scores_complete
	
	_load_progress.hide()
	_ranking_container.show()
	
	var _index: int = 0
	for _slot in _ranking_container.get_children():
		if _slot is Label:
			continue
			
		if _sw_result.scores.size() > _index:
			_slot.get_node("position").text = str(_index +1) + ". "
			_slot.get_node("floor").text = " - " + str(_sw_result.scores[_index]["score"])
			_slot.get_node("name").text = _sw_result.scores[_index]["player_name"]
			print()
			
		_index += 1
