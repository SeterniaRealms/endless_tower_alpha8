extends Control

@onready var Name = %Name
@onready var info = %Info
@onready var rarity = %Rarity
@onready var attribute_type = %AttributeType
@onready var attribute_value = %AttributeValue
@onready var restore_hp = %Restore_HP
@onready var hp_value = %HPValue
@onready var itemPopup =  %ItemPopup
@onready var v_box_container = $CanvasLayer/Control/ItemPopup/VBoxContainer
@onready var h_box_container = $CanvasLayer/Control/ItemPopup/VBoxContainer/HBoxContainer
@onready var h_box_container_2 = $CanvasLayer/Control/ItemPopup/VBoxContainer/HBoxContainer2


#func ItemPopup(slot: Rect2i, item: Inventory_Item):
	#if item != null:
		#set_value(item)
		
		# Define o tamanho do itemPopup baseado no tamanho mínimo do VBoxContainer
		#var min_size = v_box_container.get_combined_minimum_size()
		#itemPopup.rect_size = min_size
		
		#var mouse_pos = get_viewport().get_mouse_position()
		#var correction
		#var padding = 4
		
		#if mouse_pos.x <= get_viewport_rect().size.x / 2:
			#correction = Vector2(slot.size.x + padding, 0)
		#else:
			#correction = -Vector2(min_size.x + padding, 0)
		
		# Exibe o itemPopup na posição desejada
		#itemPopup.rect_position = slot.position + correction
		#itemPopup.show()

	
#func HideItemPopup():
	#itemPopup.hide()

#func set_value(item: Inventory_Item):
	#%Name.text = item.name
	#%Info.text = str(item.info)
	#%Rarity.text = item.rarity
	
		# Verifique se o item é do tipo Health_Item e se possui a propriedade restore_hp
	#if item is Health_Item:
		#%Restore_HP.text = item.restore_hp
		#%HPValue.text = str(item.restore_hp)
	#else:
		#%Restore_HP.text = ""
		#%HPValue.text = ""
		
	#if item is Equip_Item:
		#%AttributeType.text =  item.attribute_type
		#%AttributeValue.text = str(item.attribute_value)
	#else:
		#%AttributeType.text = ""
		#%AttributeValue.text = ""
		
