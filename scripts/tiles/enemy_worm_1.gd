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
var health    : int = 20  #ENEMY HEALTH
var time_effect: float = 0.25
var last_player_position: Vector2  # Armazena a última posição do player antes do ataque

@onready var area_detection: Area2D = $Area2D
@onready var raycast: RayCast2D = $raycast
@onready var target : CharacterBody2D = GameController.player
@onready var damage_numbers_origin = $damage_numbers_origin #DAMAGE NUMBERS

@onready var inventory = get_node("/root/game_manager/canvas_layer/inventory")


#RANDOM SPAWN FOR ENEMIES
func _ready() -> void:
	inventory = get_node("/root/game_manager/canvas_layer/inventory")
	animator = $worm_1
	animator.visible = true #LEMBRAR DE DEIXAR O SPRITE DOS ENEMIES NAO VISIVEIS
	target.movement.connect(_move)
	add_to_group("enemies")  # Adiciona o inimigo ao grupo "enemies"
	#area_detection.connect("body_entered", self, "_on_area_2d_body_entered")  # Conecta o sinal para detecção do player
	
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
	
		# Verifica se a próxima posição está em um tile do tipo ground2
	if not _is_ground2_position(next_position):
		return  # Se não estiver no ground2, não se move
	
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
	
	_push_player_back()  # Empurra o player para a posição anterior
	
	await animator.animation_finished
	animator.play ("retreat")
	

#ENEMY ATTACK 2
func _attack_2() -> void:
		# Verifique se o inimigo ainda está vivo antes de tentar se mover
	if health <= 0:
		return  # O inimigo não deve se mover se estiver morto
	
	animator.play("attack")
	target.apply_damage(strong, true)
	
	_push_player_back()  # Empurra o player para a posição anterior
	
	await animator.animation_finished
	animator.play ("idle")
	
	# Desativa a detecção do Area2D após o ataque
	area_detection.monitoring = false


# Função que empurra o player de volta para a posição anterior
func _push_player_back() -> void:
	# Define a direção do empurrão como a direção oposta entre o player e o inimigo
	var push_direction: Vector2 = (target.position - global_position).normalized() * -1
	
	# Calcula a nova posição do player com base na distância de 2 tiles
	var push_distance: Vector2 = push_direction * grid_size * 2  # Multiplica pelo tamanho do tile e por 2
	
	# Define a nova posição do player somando a distância ao push
	var push_position: Vector2 = target.position + push_distance
	
	# Alinhar a nova posição ao grid de 32x32 (grid_size)
	push_position.x = round(push_position.x / grid_size) * grid_size
	push_position.y = round(push_position.y / grid_size) * grid_size
	
	# Usar um tween para suavizar a movimentação
	var tween: Tween = create_tween()
	tween.tween_property(target, "position", push_position, 0.2)


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


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		last_player_position = target.position  # Armazena a posição do player antes do ataque
		
		# Gera um número aleatório entre 0 e 1 para decidir qual ataque será executado
		var random_attack = randi() % 2
		
		if random_attack == 0:
			_attack()  # Executa o ataque 1
		else:
			_attack_2()  # Executa o ataque 2

func _is_ground2_position(position: Vector2) -> bool:
	var dungeon_map4 = get_parent()  # Acessa o nó pai, onde está o DungeonMap4
	if dungeon_map4 and dungeon_map4.has_method("_is_ground2_position"):
		return dungeon_map4._is_ground2_position(position)
	return false
