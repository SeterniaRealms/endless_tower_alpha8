extends CharacterBody2D

# Variáveis de movimento
@export var move_speed: float = 200.0

# Referência ao AnimatedSprite2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Variáveis de controle de estado
var is_attacking: bool = false

# Função para processar a movimentação
func _process(delta: float) -> void:
	if not is_attacking:
		handle_movement()

	handle_attack()

# Função para controlar a movimentação
func handle_movement() -> void:
	var input_vector = Vector2.ZERO
	
	# Movimentação com W, A, S, D
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1

	# Normalizando a velocidade para manter o movimento uniforme
	velocity = input_vector.normalized() * move_speed

	# Aplicar movimento ao CharacterBody2D
	move_and_slide()

	# Atualizar animação de acordo com a movimentação
	if velocity != Vector2.ZERO:
		sprite.play("walk")
	else:
		sprite.play("idle")

	# Atualizar flip da sprite para refletir direção do movimento
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

# Função para controlar o ataque com clique direito do mouse
func handle_attack() -> void:
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		sprite.play("attack")

# Função chamada quando a animação de ataque termina
func _on_AnimatedSprite2D_animation_finished() -> void:
	if sprite.animation == "attack":
		is_attacking = false
		sprite.play("idle")
