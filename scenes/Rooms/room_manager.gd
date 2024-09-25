extends Node2D

@onready var wall_1 = $wall_1
@export var exit_tile: PackedScene
@onready var player_spawn = $"../player_spawn"
@onready var exit_spawn = $"../exit_spawn"


var column := 8
var rows := 8
var space := 32
var grid_position := []


func _ready() -> void:
	AudioBackground.play_music_level() #DUNGEON BACKGROUND MUSIC
	print(SolanaService.wallet.get_pubkey().to_string())
	randomize()
	

func _initialize_list() -> void:
	grid_position.clear()
	for x in column - 1:
		for y in rows - 1:
			grid_position.append(Vector2(x * space, y *space))


#FUNC TO SPAWN THE EXIT TILE
func _spawn_exit() -> void:
	var temp_exit = exit_tile.instantiate() as Node2D
	#temp_exit.global_position = Vector2(column * space - space, rows - space / 4)
	temp_exit.global_position = exit_spawn
	add_child(temp_exit)



#SETUP SCENE - BY GAME MANAGER SCRIPT
func setup_scene(level: int) -> void:
	_initialize_list()
	#_board_setup()
	
	#CHOOSE TILES TO SPAWN
	var enemy_count = log(GameController.level) 
	_spawn_exit()

class Count:
	var minimum : int
	var maximum : int
	
	func _init(_minimum: int, _maximum: int) -> void:
		minimum = _minimum
		maximum = _maximum
		
		
