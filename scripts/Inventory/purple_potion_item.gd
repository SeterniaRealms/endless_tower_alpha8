class_name Purple_Pot 
extends Inventory_Item

@export var shield_turns: int = 5  # Duração do escudo em turnos

func use(player: Player) -> void:
	if player.has_shield:
		return  # Se o jogador já tiver um escudo ativo, não faz nada
	
	# Aplica o escudo ao jogador
	player.activate_shield(shield_turns)
	
	
