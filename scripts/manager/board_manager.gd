extends Node2D

@export var box_tile: PackedScene
@export var spike_tile: PackedScene
@export var life_tile: PackedScene
@export var meat_tile: PackedScene
@export var exit_tile: PackedScene
@export var enemy_tile: PackedScene
@export var chest_tile: PackedScene
@export var audio_background: AudioStream
@export var player: PackedScene

#@export var portal_boss_tile : PackedScene #SPAWN BOSS PORTAL

@onready var player_spawn: Marker2D = $"../player_spawn"

#MAP GENERATION
@export var map_scenes: Array[PackedScene] = []
var current_map : Node2D = null


func _ready() -> void:
	_spawn_player()
	AudioBackground.play_music_level() #DUNGEON BACKGROUND MUSIC
	print(SolanaService.wallet.get_pubkey().to_string())
	randomize()
	

func _select_random_map() -> void:
	if map_scenes.size() > 0:
		var selected_map_scene = map_scenes[randi() % map_scenes.size()]
		current_map = selected_map_scene.instantiate() as Node2D
		add_child(current_map)


#SETUP SCENE - BY GAME MANAGER SCRIPT
func setup_scene(level: int) -> void:
	_select_random_map()

func _spawn_player() -> void:
	if player != null:
		var player_instance = player.instantiate() as Node2D
		player_instance.position = player_spawn.position
		#add_child(player_instance)
		print("Player spawned at: ", player_spawn.position)
	else:
		print("Player scene not set!")
