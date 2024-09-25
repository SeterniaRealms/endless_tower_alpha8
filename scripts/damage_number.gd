extends Node


func display_number(value: int, position: Vector2):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 5  #TO SHOW THE DAMAGE NUMBER IN FRONT OF OTHER OBJECTS
	number.label_settings = LabelSettings.new()
	
	#DAMAGE COLORS 
	# Cores do dano
	var color = "#FF0000"  # Branco padrão

	#DAMAGE SIZES
	number.label_settings.font_color = color
	number.label_settings.font_size = 18
	number.label_settings.outline_color = "#000"
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	#DAMAGE ANIMATION
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 24, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	#TO CLEAR THE DAMAGE NUMBER AFTER THE ANIMATION
	await  tween.finished 
	number.queue_free()
