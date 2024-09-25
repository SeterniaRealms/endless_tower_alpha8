extends Node
#class_name Main

#INVENTORY
#@onready var inventory = $inventory
@export var inventory = PackedScene

@export_category("Objects")
@export var _name: LineEdit = null
@export var _label_message: Label = null
@export var _label_title: Label = null
@export var _floor_container: VBoxContainer = null

@export var _save_progress    : Label = null
@export var _load_progress    : Label = null
@export var _ranking_container: VBoxContainer = null

#var ldboard_name = "alpha_test"
var ldboard_name = "alpha_test2"

#FUNC TO SHOW THE FLOOR THAT THE PLAYER HAS REACHED
func _ready() -> void:
	var message = "You survived %s floors." % GameController.level
	$label_message.text = message
	
	#var floor = "3 floors" % GameController.level
	#$label_message.text = floor
	

#RESTART BUTTON
func _on_button_restart_pressed():
	GameController.restart_game()
	await(get_tree) # Espera um frame para garantir que o inventário seja limpo
	get_tree().change_scene_to_file("res://scenes/game.tscn")

#MENU BUTTON
func _on_button_menu_pressed():
	GameController.restart_game()
	get_tree().change_scene_to_file("res://scenes/menu_game.tscn")
	
#SUBMIT BUTTON
func _on_submit_button_pressed() -> void:
	SilentWolf.Scores.save_score(_name.text, int($label_message.text), ldboard_name)
	_floor_container.hide() #HIDE CONTAINER TO SHOW THE PROGRESS MESSAGE
	_save_progress.show()
	_name.clear()
	
	await SilentWolf.Scores.sw_save_score_complete
	
	_floor_container.show() #SHOW CONTAINER TO SHOW THE PROGRESS MESSAGE
	_save_progress.hide()

#ACCES LEADERBOARD BUTTON
func _on_button_leaderboard_pressed() -> void:
	_label_message.hide()
	_label_title.hide()
	_floor_container.hide()
	_load_progress.show()
	
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
		
