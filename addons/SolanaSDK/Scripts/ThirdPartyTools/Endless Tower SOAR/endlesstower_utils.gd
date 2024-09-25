extends Node
class_name EndlessUtils

class GameAttributes:
	var name:String
	#var description:String
	var floor = AnchorProgram.u64(0)
	#var game_type = AnchorProgram.u8(0)
	#var nft_meta:Pubkey
	
	func get_value() -> Dictionary:
		var dict:Dictionary={
			"name":name,
			#"description":description,
			"floor":floor,
			#"game_type":game_type,
			#"nft_meta":nft_meta
		}
		return dict
		
	func set_floor(value:int) -> void:
		floor = AnchorProgram.u64(value)

	func set_name(value:String) -> void:
		name = value
		
class LeaderboardData:
	var description:String
	var nft_meta:Pubkey
	var decimals = AnchorProgram.option(AnchorProgram.u8(0))
	var min_score = AnchorProgram.option(null)
	var max_score = AnchorProgram.option(null)
	var scores_to_retain = AnchorProgram.u8(10)
	var is_ascending:bool
	var allow_multiple_scores:bool
	
	func set_scores_to_retain(value:int) -> void:
		scores_to_retain = AnchorProgram.u8(value)
		
	func set_decimals(value:int) -> void:
		decimals = AnchorProgram.option(AnchorProgram.u8(value))
		
	func set_min_max(min_value:int, max_value:int) -> void:
		min_score = AnchorProgram.option(AnchorProgram.u64(min_value))
		max_score = AnchorProgram.option(AnchorProgram.u64(max_value))
		
	func get_value() -> Dictionary:
		var dict:Dictionary={
			"description":description,
			"nft_meta":nft_meta,
			"decimals":decimals,
			"min_score":min_score,
			"max_score":max_score,
			"scores_to_retain":scores_to_retain,
			"is_ascending":is_ascending,
			"allow_multiple_scores":allow_multiple_scores
		}
		return dict
	
