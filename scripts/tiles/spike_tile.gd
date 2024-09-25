extends StaticBody2D

@onready var damage_numbers_origin = $damage_numbers_origin #DAMAGE NUMBERS

var resistance : int = 2
var index_anim : int
var spike       : Array = [ "01"]
var time_effect: float = 0.25
var strong    : int = 2  #SPIKE POWER

var bleeding_chance: float = 0.3  # 30% de chance de aplicar bleeding

#SHIELD
@export var has_shield: bool = false
@export var shield_duration: int = 10

func _ready() -> void:
	randomize()
	index_anim = randi () % spike.size()
	$sprite_idle.play(spike[index_anim]) #IDLE SPIKE SPRITE
	$sprite_damage.play(spike[index_anim]) #DAMAGE SPIKE SPRITE
	
	#FUNC TO DESTROY SPIKE
func apply_damage() -> void:
	resistance -= 1
	DamageNumbers.display_number(resistance, damage_numbers_origin.global_position)
	
	_create_effect()
	await get_tree().create_timer(time_effect).timeout
	
	
	#SHOW THE SPRITE DAMAGE WHEN HIT THE SPIKE
	if resistance <= 0:
		queue_free()
	elif resistance <= 2:
		$sprite_idle.hide()
		$sprite_damage.show()
		
		
		
		#EFEITO ENCOLHER/CRESCER
func _create_effect() -> void:
		var effect: Tween = create_tween()
		effect.tween_property(self, "scale", Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		effect.tween_property(self, "scale", Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
#SPIKE HIT
func _on_area_2d_body_entered(body):
	if (body.name == "player"):
		if not body.has_shield:
			GameController.health -= strong
			EnemyDamageNumber.display_number(strong, damage_numbers_origin.global_position)
			body.animated_sprite.play("hurt") # Toca a animação de hurt no player
		
# Verifica se o inimigo aplica o efeito de bleeding
			if randi() % 100 < bleeding_chance * 100:
				body.apply_bleeding()  # Aplica o efeito de bleeding ao player
