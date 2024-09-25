extends Area2D



func _on_body_entered(body):
	if body.name.match("player"):
		$collision.queue_free()
		GameController.level += 1
		
		
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://scenes/game.tscn")
