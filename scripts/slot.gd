extends Button

@onready var backgroundSprite: Sprite2D = $background
@onready var center_container = $CenterContainer

@onready var inventory = preload("res://scripts/Inventory/player_inventory.tres")

@onready var popups = get_node("/root/Popups")


#SETTER VARIABLE TO STORE ITEM
@export var inventory_item : Inventory_Item = null:
	set(value):
		inventory_item = value
		if value != null:
			print("Inventory item assigned: ", value.name)
			if backgroundSprite != null:
				backgroundSprite.texture = value.texture
			else:
				print("Error: backgroundSprite is null!")
		else:
			print("Inventory item is null")

var itemsStack: ItemsStack
var index: int

func insert(isg: ItemsStack):
	itemsStack = isg
	backgroundSprite.frame = 1
	center_container.add_child(itemsStack)
	
	if !itemsStack.inventorySlot || inventory.slots[index] == itemsStack.inventorySlot:
		return
	
	inventory.insertSlot(index, itemsStack.inventorySlot)

func takeItem():
	var item = itemsStack
	
	inventory.removeSlot(itemsStack.inventorySlot)
	
	return item
	
func isEmpty():
	return !itemsStack
	

func clear() -> void:
	if itemsStack:
		center_container.remove_child(itemsStack)
		itemsStack = null
		
	backgroundSprite.frame = 0


#func _on_mouse_entered():
	#print("Mouse entered slot")
	#if inventory_item == null:
		#print("No Inventory item")
		#return
	
	#var popups = get_node("/root/Popups")
	#print("Popup called")
	#Popups.ItemPopup(Rect2i(Vector2i(global_position) , Vector2i(size) ), inventory_item)


#func _on_mouse_exited():
	#Popups.HideItemPopup()
