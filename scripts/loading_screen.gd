extends Control

@onready var progressbar: ProgressBar = $CanvasLayer/Panel/progressbar
@onready var percentage_label: Label = $CanvasLayer/Panel/percentage_label
@onready var texture_rect: TextureRect = $CanvasLayer/Panel/TextureRect 

# Array contendo as texturas das três imagens
@onready var loading_images: Array = [
	preload("res://UI/Loading Screen/LOADING SCREEN 1.png"),
	preload("res://UI/Loading Screen/LOADING SCREEN 2.png"),
	preload("res://UI/Loading Screen/LOADING SCREEN 3.png"),
	preload("res://UI/Loading Screen/LOADING SCREEN 4.png")
]

var scene_path: String
var progress: Array

var update: float = 0.0

func _ready() -> void:
	# Seleciona uma imagem aleatoriamente e define a textura no TextureRect
	var selected_image = loading_images[randi() % loading_images.size()]
	texture_rect.texture = selected_image
	
	scene_path = LoadManager.scene_path
	ResourceLoader.load_threaded_request(scene_path)
	

func _process(delta):
	ResourceLoader.load_threaded_get_status(scene_path, progress)
	
	if progress[0] > update:
		update = progress[0]
	
	# Smooth progress using lerp, but with a smaller step to make it slower and smoother
	progressbar.value = lerp(progressbar.value, update, delta * 0.4)  # Adjust delta multiplier to control speed
	
	# Atualizar o percentage_label de acordo com o valor interpolado da progressbar
	percentage_label.text = str(int(progressbar.value * 100.0)) + " %"
	
	if progressbar.value >= 0.99:
		if update >= 1.0:
			get_tree().change_scene_to_packed(
			ResourceLoader.load_threaded_get(scene_path)
			)
		
