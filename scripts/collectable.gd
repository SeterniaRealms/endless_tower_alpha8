extends Area2D

@export var sfx_gren_pot : Array

@onready var audio_stream_player = $audio_stream_player

var hp : int = 4


func collect():
	queue_free()


func _on_body_entered(body):
	if body.name.match("player"):
		body.restore_hp(hp)
		$collision.queue_free()
	#_play_sound() #PULL THE LIFE AND MEAT SOUND
