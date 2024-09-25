extends Area2D

@export var sfx_collect : Array[AudioStream] = []

@export var itemRes: Inventory_Item
@export var inventory : Inventory  #PLAYER INVENTORY

@onready var endless_tower_program: EndlessTowerProgram = $EndlessTowerProgram
@export var game_authority_path:String

@onready var audio_stream_player = $audio_stream_player

@onready var hud_manager = get_tree().root.get_node("canvas_layer/hud_manager")

func _ready() -> void:
	SolanaService.wallet.autologin = true
	var username = Global.username

func collect_crystal(name:String ,floor:int) -> void:
	var game_attributes:EndlessUtils.GameAttributes = EndlessUtils.GameAttributes.new()
	game_attributes.name= Global.username
	game_attributes.floor= floor
	
	var auth_keypair = Keypair.new_from_file(game_authority_path)
	
	
	var tx_data:TransactionData = await endless_tower_program.init_game(game_attributes, auth_keypair, SolanaService.wallet.get_pubkey())
	#var tx_data: TransactionData = await SolanaService.transaction_manager.sign_transaction(instruction, TransactionManager.Commitment.CONFIRMED);
	
	print("Crystal collected")
	
	if !tx_data.is_successful():
		push_error("Failed to collect crystal")
		return
	


# Função para tocar o som de coleta
func _play_sound(sfx: Array) -> void:
	if sfx.size() > 0:  # Verifica se o array de sons não está vazio
		audio_stream_player.stream = sfx[randi() % sfx.size()]
		audio_stream_player.play()


func _on_body_entered(body: Node2D) -> void:
	if body.name.match("player"):
		collect_crystal(Global.username, 1)
		
			# Atualiza a quantidade de cristais coletados
		Global.crystal_count += 1
		
			# Atualiza a UI da quantidade de cristais
		if hud_manager:
			hud_manager.update_crystal_count()  # Chama diretamente a função de atualização da UI
		
		print("Username: %s"%Global.username)
		
		queue_free()
