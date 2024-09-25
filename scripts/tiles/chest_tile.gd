extends StaticBody2D

@onready var damage_numbers_origin = $damage_numbers_origin #DAMAGE NUMBERS
@onready var animator = $animated_sprite  # Inicializa o nó AnimatedSprite2D
@onready var inventory = get_node("/root/game_manager/canvas_layer/inventory")

var resistance    : int = 1  #CHEST RESISTANCE
var player_damage : int = 10 #PLAYER POWER
var time_effect: float = 0.25


func _ready() -> void:
	inventory = get_node("/root/game_manager/canvas_layer/inventory")


#APPLY DAMAGE ON CHEST
func apply_damage(damage: int) -> void:
	resistance -= damage
	#if is_critical:
		#health -= 8
	DamageNumbers.display_number(player_damage, damage_numbers_origin.global_position)
	
	_create_effect()
	await get_tree().create_timer(time_effect).timeout
	
	if resistance <= 0:
		animator.play ("chest_open")
		await animator.animation_finished
		_spawn_object()
		queue_free()
			
			
#EFEITO ENCOLHER/CRESCER
func _create_effect() -> void:
		var effect: Tween = create_tween()
		effect.tween_property(self, "scale", Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		effect.tween_property(self, "scale", Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _spawn_object() -> void:
	var chance = randf()
	
	# 10% de chance de dropar um item da chave
	if chance <= 0.1:
		var random_key_index = randi() % inventory.key_items_tiles.size()
		var key_tile = inventory.key_items_tiles[random_key_index]
		var key_tile_choice = key_tile.instantiate() as Node2D
		key_tile_choice.global_position = self.global_position
		get_tree().root.add_child(key_tile_choice)
		return  # Retorna para evitar que mais itens sejam spawnados
	
	# 90% de chance de dropar um item normal
	if chance <= 1.0:
		var random_index = randi() % inventory.chest_items_tiles.size()
		var tile = inventory.chest_items_tiles[random_index]
		var tile_choice = tile.instantiate() as Node2D
		tile_choice.global_position = self.global_position
		get_tree().root.add_child(tile_choice)
