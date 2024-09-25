extends Control

@onready var menu = $Panel/menu

# Carregar a cena de "pause_menu"
@export var pause_menu_scene: PackedScene

func _on_menu_pressed():
	# Instanciar a cena de "pause_menu"
	var pause_menu = pause_menu_scene.instantiate()
	
	# Adicionar a cena de "pause_menu" como filha da root
	get_tree().root.add_child(pause_menu)
	
	# Pausar o jogo e mostrar o menu
	pause_menu.pause()
