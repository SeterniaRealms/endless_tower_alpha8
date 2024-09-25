extends Node

@export var tilemap_layer: TileMapLayer  # Referência ao TileMapLayer do mapa
@export var walkable_tile_ids: Array[int] = []  # IDs dos tiles que são walkables
@export var non_walkable_tile_ids: Array[int] = []  # IDs dos tiles que não são walkables


# Função para verificar se um tile em uma posição é walkable
func is_walkable(position: Vector2) -> bool:
	if tilemap_layer == null:
		return false  # Retorna falso se o TileMapLayer não estiver configurado

	var cell_coords = tilemap_layer.local_to_map(position)
	var cell_id = tilemap_layer.get_cell_source_id(cell_coords)

	return walkable_tile_ids.has(cell_id)  # Verifica se o ID do tile está na lista de walkables

# Função para verificar se um tile em uma posição é non-walkable
func is_non_walkable(position: Vector2) -> bool:
	if tilemap_layer == null:
		return true  # Retorna verdadeiro por padrão se o TileMapLayer não estiver configurado

	var cell_coords = tilemap_layer.local_to_map(position)
	var cell_id = tilemap_layer.get_cell_source_id(cell_coords)

	return non_walkable_tile_ids.has(cell_id)  # Verifica se o ID do tile está na lista de non-walkables

# Função para ativar colisões com base nos tiles non-walkables
func activate_collisions() -> void:
	if tilemap_layer == null:
		return

	var used_cells = tilemap_layer.get_used_cells()

	for cell_coords in used_cells:
		var cell_id = tilemap_layer.get_cell_source_id(cell_coords)
		if non_walkable_tile_ids.has(cell_id):
			var collision_shape = CollisionShape2D.new()
			var shape = RectangleShape2D.new()
			shape.extents = Vector2(tilemap_layer.cell_size.x / 2, tilemap_layer.cell_size.y / 2)
			collision_shape.shape = shape
			collision_shape.position = tilemap_layer.map_to_local(cell_coords) + shape.extents
			add_child(collision_shape)

func _ready() -> void:
	activate_collisions()
