extends Resource

class_name Inventory_Item

@export_category("Information")
@export var name: String
@export var info: String
@export var rarity: String
@export var texture: Texture2D
@export var maxAmountPrStack: int 

func use(_player: Player) -> void:
	pass
