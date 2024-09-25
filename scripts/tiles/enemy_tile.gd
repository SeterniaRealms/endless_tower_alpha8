extends CharacterBody2D

@export var player: PackedScene
@export var life_tile: PackedScene
@export var meat_tile: PackedScene
@export var random_pot: PackedScene
@export var purple_potion: PackedScene
@export var bandage: PackedScene
@export var enemy_damage: int = 5

var direction : Vector2
var grid_size : int = GameController.grid_size
var animator  : AnimatedSprite2D
var strong    : int = 5  #ENEMY POWER
#var is_critical: int = 8 #ENEMY CRIT POWER
var health    : int = 20  #ENEMY HEALTH
var time_effect: float = 0.25


@onready var raycast: RayCast2D = $raycast
@onready var target : CharacterBody2D = GameController.player
@onready var damage_numbers_origin = $damage_numbers_origin #DAMAGE NUMBERS

@onready var inventory = get_node("/root/game_manager/canvas_layer/inventory")


#RANDOM SPAWN FOR ENEMIES
func _ready() -> void:
	inventory = get_node("/root/game_manager/canvas_layer/inventory")
	animator = $skeleton1
	animator.visible = true #LEMBRAR DE DEIXAR O SPRITE DOS ENEMIES NAO VISIVEIS
	target.movement.connect(_move)
	add_to_group("enemies")  # Adiciona o inimigo ao grupo "enemies"
	
#ENEMY MOVE FOLLOWING THE PLAYER
func _move() -> void:
	# Verifique se o inimigo ainda está vivo antes de tentar se mover
	if health <= 0:
		return  # O inimigo não deve se mover se estiver morto
	
	animator.flip_h = target.global_position.x < global_position.x
	
	await get_tree().create_timer(0.2).timeout
	
	var dir: Vector2
	if abs (target.global_position.x - global_position.x) == 0:
		dir = Vector2.DOWN if target.global_position.y > global_position.y else Vector2.UP
	else:
		dir  = Vector2.RIGHT if target.global_position.x > global_position.x else Vector2.LEFT
		
	direction = dir * grid_size
	var next_position = position + direction  # Verifique se o próximo tile está livre
	
	raycast.target_position = direction
	raycast.force_raycast_update()
	
		# Verifica se o raycast está colidindo com algo
	var collision = raycast.get_collider()
	
	# Se o raycast não colidir com nada ou se colidir com um player, o inimigo se move
	if not collision:
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", next_position, 0.2)
	elif collision.name == "player":
		_attack()
	elif collision is CharacterBody2D and collision.has_method("is_enemy_tile") and collision.is_enemy_tile():
		# O inimigo não se move se colidir com outro inimigo
		return
			
			
#ENEMY ATTACK
func _attack() -> void:
		# Verifique se o inimigo ainda está vivo antes de tentar se mover
	if health <= 0:
		return  # O inimigo não deve se mover se estiver morto
	
	animator.play("attack")
	target.apply_damage(strong, true)
	await animator.animation_finished
	animator.play ("idle")
	
	#APPLY DAMAGE ON ENEMY
func apply_damage(player_damage: int) -> void:
	health -= player_damage
	DamageNumbers.display_number(player_damage, damage_numbers_origin.global_position)
	animator.play ("hurt")
	await animator.animation_finished
	animator.play ("idle")
	
	#_create_effect()
	#await get_tree().create_timer(time_effect).timeout
	
	if health <= 0:
		animator.play ("die")
		await animator.animation_finished
		_spawn_object()
		queue_free()
			
	
		#EFEITO ENCOLHER/CRESCER
func _create_effect() -> void:
		var effect: Tween = create_tween()
		effect.tween_property(self, "scale", Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		effect.tween_property(self, "scale", Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _spawn_object() -> void:
	if randf() > 0.7:
		return  # 30% de chance de não dropar nada
	
	var random_index = randi() % inventory.enemy_items_tiles.size()
	var tile = inventory.enemy_items_tiles[random_index]
	
	var tile_choice = tile.instantiate() as Node2D
	tile_choice.global_position = self.global_position
	get_tree().root.add_child(tile_choice)

func is_enemy_tile() -> bool:
	return true
