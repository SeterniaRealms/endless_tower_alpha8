extends Control

@onready var player: CharacterBody2D = GameController.player

#CRYSTAL
@onready var crystal: Label = $crystal_count/crystal

#NFT HOLDER
@export var holder_collection: NFTCollection
@onready var verified_ui : Panel = $verified_ui

#INVENTORY
@onready var inventory = $"../inventory"

#STATUS
@onready var bleeding_status = $bleeding_status

#HEALTH BAR 
func _ready() -> void:
	$txt_health.text = str("", GameController.health)
	player.update_health.connect(_on_update_health)
	
	#CURRENT FLOOR 
	$floor/txt_floor.text = str("Floor: ", GameController.level)
	
	#CURRENT GOLD
	$gold/txt_gold.text = str("", GameController.gold)
	
	# Atualiza a quantidade de cristais na UI
	update_crystal_count()
	
	#NFT HOLDER
	verified_ui.visible= false
	
	# Verifica se o jogo foi reiniciado e atualiza o inventário
	if GameController.game_restart:
		update_inventory()
		GameController.game_restart = false  # Reseta a variável após a reinicialização


func _on_update_health(health: int) -> void:
	$txt_health.text = str("", health)
	
	
func _on_update_floor(level: int) -> void:
	$floor/txt_floor.text = str("Floor ", GameController.level)
	
	
func _on_update_gold(gold: int) -> void:
	$gold/txt_gold.text = str("", GameController.gold)
	
	
#NFT HOLDER
func _check_nft_holder() -> void:
	var seternia_pass: Array[Nft] = SolanaService.asset_manager.get_nfts_from_collection(holder_collection)
	
	verified_ui.visible= true
	$verified_ui.show()


func update_inventory() -> void:
	if inventory and inventory.has_method("clear_inventory"):
		inventory.clear_inventory()
	else:
		print("Inventory reference is null or method does not exist.")

# Função para atualizar o número de cristais na UI
func update_crystal_count() -> void:
	$crystal_count/crystal.text = str(" ", Global.crystal_count)
	print(Global.crystal_count)
