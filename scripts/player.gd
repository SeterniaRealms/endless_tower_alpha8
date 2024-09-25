extends CharacterBody2D

# Define the Player class
class_name Player

#CUSTOMIZABLE SIGNAL
signal movement 

#ENEMY
@export var enemy_tile: PackedScene

#HEALTH
signal update_health(health)
@onready var healthbar = $healthbar
@onready var hurt_box = $hurtbox
@onready var health_bar_ui = $"../canvas_layer/hud_manager/health_bar_ui/health_bar"

#STATUS
@onready var bleeding_status = get_node("../canvas_layer/hud_manager/bleeding_status")

#GOLD
#signal update_gold(gold)
#@onready var gold = $"../canvas_layer/hud_manager/gold"

#PLAYER SFX
@export var sfx_footstep : Array[AudioStream] #FOOTSTEP SFX
@export var sfx_attack   : Array[AudioStream] #ATTACK SFX
@export var sfx_damage   : Array[AudioStream] #PLAYER DAMAGE
@export var sfx_die      : Array[AudioStream]
@export var sfx_hp_pot : Array[AudioStream]

@export var sfx_collect : Array[AudioStream] = [] #COLLECT ITEMS
@export var inventory : Inventory  #PLAYER INVENTORY

@onready var raycast: RayCast2D = $raycast
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite
@onready var audio_stream_sfx = $audio_stream_sfx #FOOTSTEP SFX
@onready var audio_hp_pot = $audio_hp_pot
@onready var damage_numbers_origin = $damage_numbers_origin
@onready var heal_numbers_origin = $heal_numbers_origin

#SHIELD
@export var has_shield: bool = false
@export var shield_duration: int = 5

@export var player_damage: int = 10

#PLAYER MOVE
var input := { "move_up": Vector2.UP, "move_down": Vector2.DOWN, "move_right": Vector2.RIGHT, "move_left": Vector2.LEFT }
#var grid_size := 32
var grid_size : int = GameController.grid_size
var direction := Vector2.RIGHT * grid_size
var in_move := false
var death := false

var enemy_movement : int = 0
var current_dir = "none"
var can_move: bool = true  # Variável para controlar o movimento
var life_temp : int

var time_effect: float = 0.25

#BLEEDING STATUS
var is_bleeding: bool = false
var bleeding_damage: int = 1  # Quantidade de HP que será perdido a cada movimento
var bleeding_duration: int = 10  # Quantidade de movimentos antes de parar o bleeding


func _ready() -> void:
	 # Restaurar o estado do shield ao carregar a cena
	has_shield = Global.has_shield
	shield_duration = Global.shield_duration
	
	show_status()
	inventory.use_item.connect(use_item)
	randomize() #RANDOMIZE SOUNDS
	GameController.player = self
	#HEALTH BAR
	healthbar.value = GameController.health
	health_bar_ui.value = GameController.health #barra da interface
	health_bar_ui.max_value = GameController.maxHealth #barra da interface
	
	#GOLD AMOUNT
	#gold.amount = GameController.gold

func _on_CharacterBody2D_body_entered(body: Node):
	if body.is_in_group("box_tiles"):
		if body.has_method("activate_collision"):
			body.activate_collision()

func _input(event: InputEvent) -> void:
	if not can_move: return  # Verifica se o jogador pode se mover
	
	for dir in input.keys():
		if event.is_action_pressed(dir):
			_move(dir)
	
	if event.is_action_pressed("move_right"):
		current_dir = "right"
		animated_sprite.play("walk")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
		
	if event.is_action_pressed("move_left"):
		current_dir = "left"
		animated_sprite.play("walk")
		await animated_sprite.animation_finished
		animated_sprite.play("idle")
	
	#FUNC TO ACTIVATE THE ATTACK - KEYBOARD: SPACE OR ENTER
	if event.is_action_pressed("ui_accept"):
		_sword()
	
	if event.is_action_pressed("move_up"):
		current_dir = "up"
		animated_sprite.play("walk_up")
		await animated_sprite.animation_finished
		animated_sprite.play("idle_up")
	
	if event.is_action_pressed("move_down"):
		current_dir = "down"
		animated_sprite.play("walk_down")
		await animated_sprite.animation_finished
		animated_sprite.play("idle_down")
	
func _move(dir: String) -> void:
	if death or in_move or not can_move: return  # Verifica se o jogador pode se mover
	
	in_move= true
	$timer.start()
	
	# Verifica se o jogador está "bleeding" e aplica dano
	if is_bleeding:
		print("bleeding!")
		apply_damage(bleeding_damage)
		EnemyDamageNumber.display_number(bleeding_damage, damage_numbers_origin.global_position) # Exibe o dano
		bleeding_duration -= 1
		if bleeding_duration <= 0:
			is_bleeding = false
			remove_bleeding()
			
			
	 # Verifica se o jogador está com escudo ativo e diminui a duração do escudo
	if has_shield:
		shield_duration -= 1
		if shield_duration <= 0:
			deactivate_shield()
	
	#CALCULATE DIRECTION
	direction = input[dir] * grid_size
	raycast.target_position = direction
	raycast.force_raycast_update()
	
		# Verifique se o próximo tile está livre
	var next_position = position + direction
	var is_tile_occupied = false
	
		# Verifica se algum inimigo já está na posição
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy != self and enemy.global_position == next_position:
			is_tile_occupied = true
			can_move = false
			
		#PULL PLAYERS SOUND 
	_play_sound(sfx_footstep)
	
	#IF NOT COLLIDE, CAN MOVE
	if not raycast.is_colliding() and not is_tile_occupied:
		var tween: Tween = create_tween()
		tween.tween_property(self, "position", position + direction, 0.2)
		
	match dir:
		"move_right": animated_sprite.flip_h = false
		"move_left": animated_sprite.flip_h = true
		
	#Regardless of whether the player moves or not, the enemy will move every two actions.
	_move_enemy()  

#RESTORE HP PLAYER
func restore_hp(hp: int) -> void:
	GameController.health += hp
	healthbar.value = GameController.health
	health_bar_ui.value = GameController.health  # Atualiza a barra da interface
	update_health.emit(GameController.health)
	
	_play_sound(sfx_hp_pot)
	
	# Exibe o número de HP restaurado
	heal_numbers_origin.display_heal_number(hp, heal_numbers_origin.position)
	
# LOOSE HP FUNCTION
func loose_hp(hp: int) -> void:
	GameController.health += hp  # Notice hp is negative
	healthbar.value = GameController.health
	health_bar_ui.value = GameController.health 
	update_health.emit(GameController.health)
	
	
func use_item(item: Inventory_Item) -> void:
	item.use(self)
	_move_enemy()
	
	
func apply_damage(strong: int, enemy_hit: bool = false) -> void:  #PLAYER DAMAGE FUNCTION
	if has_shield:
		return  # Não aplica dano se o escudo estiver ativo
	
	GameController.health -= strong
	healthbar.value = GameController.health
	health_bar_ui.value = GameController.health  # Atualiza a barra da interface
	update_health.emit(GameController.health)
	
	
	#ANIMATION WHEN PLAYER GET HIT BY AN ENEMY
	if enemy_hit and can_move:
		# Desativa o movimento ao ser atingido
		can_move = false
		
		_play_sound(sfx_damage) #HURT PLAYER SOUND
		EnemyDamageNumber.display_number(strong, damage_numbers_origin.global_position)
		_create_effect()
		await get_tree().create_timer(time_effect).timeout
		
		var dir = current_dir
		match dir:
			"right":
				animated_sprite.play("hurt")
			"left":
				animated_sprite.play("hurt")
			"up":
				animated_sprite.play("hurt_up")
			"down":
				animated_sprite.play("hurt_down")
			
		await animated_sprite.animation_finished
		
		if dir == "right":
			animated_sprite.play("idle")
		if dir == "left":
			animated_sprite.play("idle")
		if dir == "up":
			animated_sprite.play("idle_up")
		if dir == "down":
			animated_sprite.play("idle_down")
		
		# Espera alguns segundos antes de reativar o movimento
		await get_tree().create_timer(0.1).timeout # Você pode ajustar o tempo aqui
		# Reativa o movimento após o tempo de espera
		can_move = true
	
	if GameController.health <= 0:
		death = true
		GameController.health = 0
		update_health.emit(GameController.health)
		
		# Certifique-se de que o movimento seja desativado    
		can_move = false
		in_move = true
		
		var dir = current_dir
		match dir:
			"right":
				animated_sprite.play("death")
			"left":
				animated_sprite.play("death")
			"up":
				animated_sprite.play("death_up")
			"down":
				animated_sprite.play("death_down")
				
		await animated_sprite.animation_finished
		
		#DIE PLAYER SOUND
		_play_sound(sfx_die) 
		#await $audio_stream_sfx.finished  #WAIT THE DIE SOUND, TO END
		
		get_tree().change_scene_to_file("res://scenes/end.tscn")  #PULL END SCENE
		

#FUNC TO ACTIVATE THE ATTACK
func _sword() -> void:
	var dir = current_dir
	
	if death or in_move or not can_move: return  # Verifica se o jogador pode atacar
	
	 # Verifica se o jogador está com escudo ativo e diminui a duração do escudo
	if has_shield:
		shield_duration -= 1
		if shield_duration <= 0:
			deactivate_shield()
	
	$sword.global_position = global_position + direction
	$sword/collision.disabled = false
	
	if dir == "right":
		animated_sprite.play("attack") 
		
	if dir == "left":
		animated_sprite.play("attack") 
		
	if dir == "up":
		animated_sprite.play("attack_up") 
		
	if dir == "down":
		animated_sprite.play("attack_down") 
		
	_play_sound(sfx_attack) #ATTACK SOUND
	
	
	#STOP THE ATTACK ANIMATION
	await animated_sprite.animation_finished
	$sword/collision.disabled = true
	
	if dir == "right":
		animated_sprite.play("idle")
		
	if dir == "left":
		animated_sprite.play("idle")
		
	if dir == "up":
		animated_sprite.play("idle_up")
		
	if dir == "down":
		animated_sprite.play("idle_down")
	
	#IF THE PLAYER PERFORMS AN ATTACK, ENEMIES WILL MOVE
	_move_enemy()
	#IF THE PLAYER DO AN ATTACK, HE WILL LOSE HEALTH
	apply_damage(1)

#MOVE ENEMY - Every two movements of the player, the enemy moves
func _move_enemy() -> void:
	enemy_movement += 1
	if enemy_movement % 2 == 0:
		movement.emit()

#PLAYERS SOUNDS
func _play_sound(sfx: Array) -> void:
	var master_bus_index = AudioServer.get_bus_index("Master")
	if not AudioServer.is_bus_mute(master_bus_index):
		audio_stream_sfx.stream = sfx[randi() % sfx.size()]
		audio_stream_sfx.play()

func _on_timer_timeout():
	in_move = false
	

#Identify breakable boxes #Anything that is breakable, apply this method
func _on_sword_body_entered(body: Node2D) -> void:
	if body.has_method("apply_damage"):
		body.apply_damage(player_damage)
		
		
func _on_hurtbox_area_entered(area):
	if area.has_method("collect"):
		_play_sound(sfx_collect) #COLLECT SOUND
		area.collect(inventory)
	

		#EFEITO ENCOLHER/CRESCER
func _create_effect() -> void:
		var effect: Tween = create_tween()
		effect.tween_property(self, "scale", Vector2.ONE / 2, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN)
		effect.tween_property(self, "scale", Vector2.ONE, time_effect).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)


# Método para aplicar o efeito de bleeding
func apply_bleeding() -> void:
	if not is_bleeding:
		is_bleeding = true
		bleeding_duration = 10  # Pode ajustar conforme necessário
		show_status()

func remove_bleeding():
	is_bleeding = false  # Supondo que você tenha uma variável 'bleeding' para controlar o status de bleeding
	show_status()

func show_status() -> void:
	if bleeding_status:
		if is_bleeding:
			bleeding_status.show()
		else:
			bleeding_status.hide()
	else:
		print("bleeding_status node not found!")
		
		
# Activate the shield effect
func activate_shield(duration: int) -> void:
	has_shield = true
	print("Shield activated!")
	shield_duration = duration
	
	# Salvar o estado no GameState
	Global.has_shield = has_shield
	Global.shield_duration = shield_duration
	
# Desativar o escudo
func deactivate_shield() -> void:
	has_shield = false
	shield_duration = 0
	print("Shield deactivated!")  # Para fins de depuração
	# Adicionar qualquer efeito visual ou sonoro que indique que o escudo foi desativado
	Global.has_shield = has_shield
	Global.shield_duration = shield_duration
