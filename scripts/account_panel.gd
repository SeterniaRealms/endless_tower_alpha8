extends VBoxContainer

@onready var account_address: Label = $"../Wallet/AccountAddress"

func _ready() -> void:
	var wallet_address = SolanaService.wallet.get_pubkey().to_string()
	account_address.text = wallet_address
	
	Global.wallet_address = SolanaService.wallet.get_pubkey().to_string()
