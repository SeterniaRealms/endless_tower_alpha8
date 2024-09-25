extends Inventory_Item
class_name Health_Item

@export var restore_hp: int = 4

func use(player: Player) -> void:
	player.restore_hp(restore_hp)
	
	
