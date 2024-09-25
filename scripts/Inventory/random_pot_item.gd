class_name Random_Pot 
extends Inventory_Item

@export var restore_hp: int = 4
@export var loose_hp: int = -4

func use(player: Player) -> void:
	var result = randi() % 2  # Gera um número aleatório entre 0 e 1
	if result == 0:
		player.restore_hp(restore_hp)
	else:
		player.loose_hp(loose_hp)
