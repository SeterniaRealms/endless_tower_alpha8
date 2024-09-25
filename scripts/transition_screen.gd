extends CanvasLayer

signal on_transition_finished

@onready var floor_label = $floor
@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	#floor.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	
	#CURRENT FLOOR 
	$floor.text = str("Floor: ", GameController.level + 1)
	
func _on_animation_finished(anim_name):
		if anim_name == "fade_to_black":
			on_transition_finished.emit()
			animation_player.play("fade_to_normal")
		elif anim_name == "fade_to_normal":
			color_rect.visible = false
			#floor.visible = false
	
	
func transition():
	color_rect.visible = true
	#floor.visible = true
	animation_player.play("fade_to_black")

# Função para atualizar o texto do andar e exibi-lo temporariamente
func _update_floor(level: int) -> void:
	$floor.text = str("Floor: ", level)
	_show_floor_text()

# Função que toca a animação de exibição do texto
func _show_floor_text() -> void:
	$floor.visible = true
	animation_player.play("show_floor_text")
