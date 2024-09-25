extends CanvasLayer

@onready var audio_stream_player: AudioStreamPlayer2D = $audio_stream_player
@onready var create_account: Button = $Control/Panel1/AccountPanel/create_account
@onready var _username: LineEdit = $Control/Panel1/AccountPanel/SetUsername/_username

var username:String

func _on_create_account_pressed() -> void:
	username = _username.text
	
	Global.username = _username.text
	
	
	get_tree().change_scene_to_file("res://scenes/menu_game.tscn")
