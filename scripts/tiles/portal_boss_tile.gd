extends Area2D



func _on_body_entered(body):
	if body.name.match("player"):
		$collision.queue_free()
		#GameController.level == 10
		get_tree().change_scene_to_file("res://scenes/boss_room.tscn")


func _on_body_exited(body):
	if body.name.match("player"):
		$collision.queue_free()
