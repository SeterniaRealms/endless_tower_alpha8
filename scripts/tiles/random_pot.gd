extends Area2D

@export var sfx_collect : Array[AudioStream] = []
@export var itemRes: Inventory_Item
@export var inventory : Inventory  #PLAYER INVENTORY

var hp        : int = 4
var loose_hp  : int = -4

@onready var audio_stream_player = $audio_stream_player


func _ready() -> void:
	pass


func collect (inventory_collect: Inventory):
	inventory_collect.insert(itemRes)
	
	if sfx_collect.size() > 0:
		_play_sound(sfx_collect) #COLLECT SOUND
	
	queue_free()
	
	
# Função para tocar o som de coleta
func _play_sound(sfx: Array) -> void:
	if sfx.size() > 0:  # Verifica se o array de sons não está vazio
		audio_stream_player.stream = sfx[randi() % sfx.size()]
		audio_stream_player.play()
