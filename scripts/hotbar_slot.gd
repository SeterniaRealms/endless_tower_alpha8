extends Button

@onready var background_sprite: Sprite2D = $background
@onready var item_stack: ItemsStack = $CenterContainer/Panel


func update_to_slot(slot: IventorySlot) -> void:
	if !slot.item:
		item_stack.visible = false
		background_sprite.frame = 0
		return
	
	item_stack.inventorySlot = slot
	item_stack.update()
	item_stack.visible = true
	
	background_sprite.frame = 1
