extends Area2D

@export var sfx_collect : Array[AudioStream] = []

@export var itemRes: Inventory_Item
@export var inventory : Inventory  #PLAYER INVENTORY

var hp        : int = 4
var life_temp : int
var life      : Array = ["meat"]

@onready var audio_stream_player = $audio_stream_player


func _ready() -> void:
	randomize()
	life_temp = randi() % life.size()
	$animated_sprite.play(life[life_temp])


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



#func _on_body_entered(body: Node2D) -> void:
	#if body.name.match("player"):
		#body.restore_hp(hp)
		#$collision.queue_free()
		#_play_sound() #PULL THE LIFE AND MEAT SOUND
		
		#var tween = create_tween()
		#tween.tween_property(self, "scale", Vector2.ONE * 1.2, .5)
		#tween.tween_property($animated_sprite, "modulate:a", 0, .5).set_delay(.2)
		
		#await tween.finished
		#queue_free()
		
	
