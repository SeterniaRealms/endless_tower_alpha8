extends Node2D

@export var box_tile: PackedScene
@export var box_tile2: PackedScene
@export var spike_tile: PackedScene
@export var life_tile: PackedScene
@export var meat_tile: PackedScene
@export var exit_tile: PackedScene
@export var enemy_tile: PackedScene
@export var enemy_skeleton_1: PackedScene
@export var enemy_skeleton_2: PackedScene
@export var enemy_worm_1: PackedScene
@export var chest_tile: PackedScene
@export var portal_boss_tile : PackedScene #SPAWN BOSS PORTAL
@export var audio_background: PackedScene
@export var player: PackedScene  
@export var crystal: PackedScene

@export var restricted_area_marker: Marker2D 

@export var tilemap_layer: TileMapLayer
@export var ground_2: TileMapLayer

var grid_positions: Array = []


func _ready() -> void:
	_initialize_grid_positions()
	_spawn_tiles()


func _initialize_grid_positions() -> void:
	grid_positions.clear()

	if tilemap_layer == null:
		print("TileMapLayer is not set!")
		return

	# Obtém todas as células usadas
	var used_cells = tilemap_layer.get_used_cells()
	print("Used cells: ", used_cells)

	for cell_coords in used_cells:
		var cell_pos = tilemap_layer.map_to_local(cell_coords)
		if not _is_restricted_area(cell_pos):  # Verifica se a posição não é restrita
			grid_positions.append(cell_pos)

	print("Grid positions initialized: ", grid_positions.size())

func _is_restricted_area(position: Vector2) -> bool:
	if restricted_area_marker == null:
		return false  # Retorna false se não houver um Marker2D configurado

	# Verifica se a posição está dentro da área restrita (com uma margem de erro)
	return position.distance_to(restricted_area_marker.position) < grid_positions.size() # Use grid_size como margem


func _random_position() -> Vector2:
	if grid_positions.size() == 0:
		return Vector2.ZERO  # Retorna uma posição padrão ou gera um erro/log

	var random_index = randi_range(0, grid_positions.size() - 1)
	var random_pos = grid_positions[random_index]
	grid_positions.remove_at(random_index)  # Remove a posição para evitar duplicatas
	print("Random position selected: ", random_pos)
	return random_pos

func _is_ground_position(position: Vector2) -> bool:
	if tilemap_layer == null:
		return false  # Retorna false se tilemap_layer não estiver configurado

	var cell_coords = tilemap_layer.local_to_map(position)
	# Verifica se há um tile na célula
	var cell_id = tilemap_layer.get_cell_source_id(cell_coords)
	var is_ground = cell_id != -1  # Verifica se há um tile na posição
	print("Checking ground position: ", position, " Is ground: ", is_ground)
	return is_ground

# Função para verificar se a posição está no "ground2"
func _is_ground2_position(position: Vector2) -> bool:
	if ground_2 == null:
		return false

	var cell_coords = ground_2.local_to_map(position)
	var cell_id = ground_2.get_cell_source_id(cell_coords)
	var is_ground2 = cell_id != -1
	print("Checking ground2 position: ", position, " Is ground2: ", is_ground2)
	return is_ground2


func _spawn_tiles() -> void:
	var enemy_count = log(GameController.level)*2
	#_spawn_object_random(enemy_tile, enemy_count, enemy_count)
	
	# Spawna o enemy_worm_1 apenas no ground2
	_spawn_object_on_ground2(enemy_worm_1, 1, 3)
	
	#_spawn_object_random(enemy_skeleton_1, enemy_count, enemy_count)
	_spawn_object_random(box_tile, 2, 4)
	_spawn_object_random(box_tile2, 2,4)
	_spawn_object_random(spike_tile, 1, 3)
	_spawn_object_random(life_tile, 1, 3)
	_spawn_object_random(meat_tile, 1, 3)

	# Adicionando a lógica para spawnar tiles apenas a partir do nível 3
	if GameController.level >= 3:
		_spawn_object_random(enemy_skeleton_2, 0, 1)
		_spawn_object_random(chest_tile, 1, 1)
		#_spawn_object_random(crystal, 1, 1)
		
	_spawn_exit()


func _spawn_object_random(tile: PackedScene, min_count: int, max_count: int) -> void:
	var object_count = randi_range(min_count, max_count)
	object_count = min(object_count, grid_positions.size())  # Garante que não tente spawnar mais objetos do que posições disponíveis

	for i in range(object_count):
		if grid_positions.size() == 0:
			break  # Sai do loop se não houver mais posições disponíveis
		var random_pos = _random_position()
		if _is_ground_position(random_pos):
			var tile_instance = tile.instantiate() as Node2D
			tile_instance.position = random_pos  # Atualizado para position
			add_child(tile_instance)
			print("Spawned tile at: ", random_pos)

func _spawn_object_on_ground2(tile: PackedScene, min_count: int, max_count: int) -> void:
	var object_count = randi_range(min_count, max_count)
	object_count = min(object_count, grid_positions.size())

	for i in range(object_count):
		if grid_positions.size() == 0:
			break
		var random_pos = _random_position()
		if _is_ground2_position(random_pos):
			var tile_instance = tile.instantiate() as Node2D
			tile_instance.position = random_pos
			add_child(tile_instance)
			print("Spawned enemy_worm_1 at: ", random_pos)


func _spawn_exit() -> void:
	var random_pos = _random_position()
	if _is_ground_position(random_pos):
		var exit_instance = exit_tile.instantiate() as Node2D
		exit_instance.position = random_pos  # Atualizado para position
		add_child(exit_instance)
		print("Spawned exit at: ", random_pos)
		
		
