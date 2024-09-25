extends StaticBody2D

@onready var damage_numbers_origin = $damage_numbers_origin #DAMAGE NUMBERS

@onready var inventory = get_node("/root/game_manager/canvas_layer/inventory")

var resistance : int = 1
var index_anim : int
var box       : Array = [ "01", "02" ]
var time_effect: float = 0.25

var player_damage    : int = 10 #PLAYER POWER

var walkable: bool = false  # Define que o tile não é walkable por padrão

func _ready() -> void:
	inventory = get_node("/root/game_manager/canvas_layer/inventory")
	randomize()
	index_anim = randi () % box.size()
	#$sprite_idle.play(box[index_anim]) #IDLE BOX SPRITE
	#$sprite_damage.play(box[index_anim]) #DAMAGE BOX SPRITE
	
	
	#FUNC TO DESTROY BOX
func apply_damage(damage: int) -> void:
	resistance -= damage
	$sprite_damage.show()
	#DamageNumbers.display_number(resistance, damage_numbers_origin.global_position)
	_create_effect()
	await get_tree().create_timer(time_effect).timeout
	
	
	#SHOW THE SPRITE DAMAGE WHEN HIT THE BOX
	if resistance <= 0:
		_spawn_object()
		queue_free()
			
	#elif resistance <= 2:
		#$sprite_idle.hide()
		#$sprite_damage.show()
		
		
		#EFEITO ENCOLHER/CRESCER
func _create_effect() -> void:
		var effect: Tween = create_tween()
		effect.tween_property(self, "scale", Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		effect.tween_property(self, "scale", Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
 
func _spawn_object() -> void:
	if randf() > 0.3:
		return  # 70% de chance de não dropar nada
	
	var random_index = randi() % inventory.box_items_tiles.size()
	var tile = inventory.box_items_tiles[random_index]
	
	var tile_choice = tile.instantiate() as Node2D
	tile_choice.global_position = self.global_position
	get_tree().root.add_child(tile_choice)
