extends Node

@onready var audio_stream_player = $audio_stream_player

var sfx_play : Array[AudioStream] = []

func _on_button_play_pressed():
	_play_sound(sfx_play)
	#get_tree().change_scene_to_file("res://scenes/game.tscn")
	LoadManager.change_floor("res://scenes/game.tscn")


func _on_button_quit_pressed():
	get_tree().quit()

	
func _on_button_leaderboard_pressed():
	get_tree().change_scene_to_file("res://scenes/leaderboard.tscn")


func _on_button_tutorial_pressed():
		get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_button_test_pressed():
	get_tree().change_scene_to_file("res://addons/SolanaSDK/Demos/HighscoreDemo/HighscoreDemo.tscn")


# Função para tocar o som dos buttons
func _play_sound(sfx: Array) -> void:
	if sfx.size() > 0:  # Verifica se o array de sons não está vazio
		audio_stream_player.stream = sfx[randi() % sfx.size()]
		audio_stream_player.play()
