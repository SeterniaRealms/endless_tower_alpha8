extends Node
class_name EndlessPDA

static func get_leaderboard_pda(game_account:Pubkey,leaderboard_id:int, pid:Pubkey) -> Pubkey:
	var name_bytes = "leaderboard".to_utf8_buffer()
	var game_bytes = game_account.to_bytes()
	var id_bytes := PackedByteArray()
	id_bytes.resize(8)
	id_bytes.encode_u64(0, leaderboard_id)
	return Pubkey.new_pda_bytes([name_bytes,game_bytes,id_bytes],pid)
	
	
static func treasury_pda( pid:Pubkey) -> Pubkey:
	var treasury = "TRESURE_SEED".to_utf8_buffer()
	return Pubkey.new_pda_bytes([treasury],pid)

static func position_pda(wallet_account:Pubkey, pid:Pubkey) -> Pubkey:
	var endless = "endless".to_utf8_buffer()
	var wallet = wallet_account.to_bytes()
	return Pubkey.new_pda_bytes([endless,wallet],pid)

	
static func get_player_pda(user_key:Pubkey, pid:Pubkey) -> Pubkey:
	var name_bytes = "player".to_utf8_buffer()
	var user_bytes = user_key.to_bytes()
	return Pubkey.new_pda_bytes([name_bytes,user_bytes],pid)
	
static func get_player_scores_pda(user_key:Pubkey,leaderboard_account:Pubkey, pid:Pubkey) -> Pubkey:
	var name_bytes = "player-scores-list".to_utf8_buffer()
	var user_bytes = user_key.to_bytes()
	var leaderboard_bytes = leaderboard_account.to_bytes()
	return Pubkey.new_pda_bytes([name_bytes,user_bytes,leaderboard_bytes],pid)
