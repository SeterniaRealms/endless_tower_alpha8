extends TextureButton

@export var stream : AudioStream
@onready var toggle_sound = $"."


func _on_pressed():
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(master_bus_index, !AudioServer.is_bus_mute(master_bus_index))
	
	#CHANGE SOUND ICON
	#if AudioServer.is_bus_mute(master_bus_index):
		#toggle_sound = 
