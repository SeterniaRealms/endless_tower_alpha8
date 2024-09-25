extends ProgressBar

@export var player: Player

@onready var health_bar = $".."


func _ready():
	max_value = GameController.maxHealth
	value = GameController.health
	
	# Conecta ao sinal de atualização de saúde do player
	player.update_health.connect(_on_update_health)

# Função chamada sempre que o sinal 'update_health' é emitido
func _on_update_health(current_health):
	value = current_health
