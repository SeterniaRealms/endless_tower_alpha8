extends Control

@onready var v_box_container = $PanelContainer/VBoxContainer


func _ready():
	v_box_container.hide()
	$AnimationPlayer.play("RESET")

func resume():
	v_box_container.hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur_pause_menu")

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur_pause_menu")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		v_box_container.show()
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		v_box_container.hide()
		resume()


func _on_resume_pressed():
	resume()


func _on_restart_pressed():
	GameController.restart_game()
	resume()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	


func _on_quit_pressed():
	GameController.restart_game()
	resume()
	get_tree().change_scene_to_file("res://scenes/menu_game.tscn")

func _process(_delta):
	testEsc()
