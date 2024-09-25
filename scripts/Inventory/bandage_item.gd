extends Inventory_Item
class_name Bandage_Item

func use(player: Player) -> void:
	player.remove_bleeding()  # Chama a função no player para remover o bleeding
	print("removed bleeding")
