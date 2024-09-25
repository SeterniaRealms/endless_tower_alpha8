extends Area2D

@export var sfx_exit : Array[AudioStream] = []

@onready var audio_stream_player = $audio_stream_player


func _on_body_entered(body: Node2D) -> void:
	if body.name.match("player"):
		# Desativa o movimento do jogador
		body.can_move = false
		
		_play_sound(sfx_exit) #EXIT SOUND
		
		$collision.queue_free()
		GameController.level += 1
		
		await get_tree().create_timer(1).timeout
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		get_tree().reload_current_scene()
	
# Função para tocar o som de coleta
func _play_sound(sfx: Array) -> void:
	if sfx.size() > 0:  # Verifica se o array de sons não está vazio
		audio_stream_player.stream = sfx[randi() % sfx.size()]
		audio_stream_player.play()
