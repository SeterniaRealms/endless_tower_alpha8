extends Panel

class_name ItemsStack

@onready var itemSprite: Sprite2D = $item
@onready var amountLabel: Label = $label

var inventorySlot: IventorySlot

func update():
	if !inventorySlot || !inventorySlot.item: return
	
	itemSprite.visible = true
	itemSprite.texture =  inventorySlot.item.texture
		
	if inventorySlot.amount > 1:
		amountLabel.visible = true
		amountLabel.text = str(inventorySlot.amount)
	else:
		amountLabel.visible = false
