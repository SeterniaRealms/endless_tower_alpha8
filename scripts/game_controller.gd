extends Node

#@onready var inventory = get_node_or_null("/root/game_manager/canvas_layer/inventory")
#@onready var inventory = preload("res://prefabs/inventory.tscn")

var level : int = 1
var health : int = 100  #SET THE PLAYER HP
var maxHealth : int = 100  #MAX HEALTH
var grid_size: int = 32
var player : CharacterBody2D

var game_restart: bool = false  # Nova variável para rastrear reinício

var inventory : Control  # Adicionar referência ao inventário

var gold : int = 0  #GOLD


#RESET LEVEL AND HEALTH, AFTER RESTART THE GAME
func restart_game() -> void:
	level = 1
	health = 100
	gold = 0

	# Limpar inventário ao reiniciar o jogo
	inventory = get_node("/root/game_manager/canvas_layer/inventory")
	if inventory:
		print("Inventory node found.")
		if inventory.has_method("clear_inventory"):
			print("Clearing inventory.")
			inventory.clear_inventory()
		else:
			print("Method clear_inventory not found.")
	else:
		print("Inventory node not found.")
		
	game_restart = true  # Define que o jogo foi reiniciado



func add_gold(amount: int) -> void:
	gold += amount
	update_hud()
	print("GOLD: ", gold)
	
	
func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		update_hud()
		print("GOLD: ", gold)
		return true
	else:
		print("Not enough GOLD")
		return false
		
func update_hud():
	# Atualiza o HUD com o novo valor de GOLD
	pass
	
func end_turn() -> void:
	# Outros códigos para finalizar o turno...
	player.process_turn()
	# Continue com o resto da lógica de turno...
