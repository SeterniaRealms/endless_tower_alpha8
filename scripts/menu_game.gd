extends Node

@onready var audio_stream_player: AudioStreamPlayer2D = $Control/audio_stream_player

@onready var play: Label = $Control/Panel/HBoxContainer/VBoxContainer/play_button/play
@onready var leaderboard: Label = $Control/Panel/HBoxContainer/VBoxContainer2/leaderboard_button/leaderboard
@onready var tutorial: Label = $Control/Panel/HBoxContainer/VBoxContainer3/tutorial_button/tutorial

# COLORS
@export var hover_color: Color = Color8(255, 230, 99) # Amarelo (FFE663)
@export var normal_color: Color = Color.WHITE # Cor padrão (branca)

func _ready() -> void:
	pass

func _on_play_button_pressed() -> void:
	LoadManager.change_floor("res://scenes/game.tscn")


func _on_leaderboard_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")


func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_play_button_mouse_entered() -> void:
	play.modulate = hover_color
func _on_play_button_mouse_exited() -> void:
	play.modulate = normal_color


func _on_leaderboard_button_mouse_entered() -> void:
	leaderboard.modulate = hover_color
func _on_leaderboard_button_mouse_exited() -> void:
	leaderboard.modulate = normal_color


func _on_tutorial_button_mouse_entered() -> void:
	tutorial.modulate = hover_color
func _on_tutorial_button_mouse_exited() -> void:
	tutorial.modulate = normal_color
