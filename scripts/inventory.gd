extends Control

@onready var inventory: Inventory = preload("res://scripts/Inventory/player_inventory.tres")

@onready var itemsStackClass = preload("res://prefabs/itemsStack.tscn")

@onready var hotbar_slots: Array = $TextureRect/HBoxContainer.get_children()
@onready var slots: Array = hotbar_slots + $TextureRect/GridContainer.get_children()

@onready var player = $"../../player"

@export var box_items_tiles: Array[PackedScene] = []
@export var enemy_items_tiles: Array[PackedScene] = []
@export var chest_items_tiles: Array[PackedScene] = []
@export var key_items_tiles: Array[PackedScene] = []

var itemInHand: ItemsStack
var oldIndex: int = -1
var locked: bool = false
var is_inventory_visible: bool = false

func _ready():
	if not slots:
		print("Error: slots is null. Check the path to the GridContainer.")
	else:
		print("Slots initialized correctly.")
	
	# Restaurar o estado do inventário ao iniciar a cena
	is_inventory_visible = Global.inventory_visible
	visible = is_inventory_visible
	
	connectslots()
	inventory.updated.connect(update)
	update()
	
func connectslots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		print("Attempting to connect slot: ", slot)
		slot.connect("pressed", Callable(self, "_on_slot_pressed").bind(slot))
		print("Connected slot: ", slot)

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: IventorySlot = inventory.slots[i]
		
		if !inventorySlot.item:
			slots[i].clear()
			continue
			
		var itemsStack: ItemsStack = slots[i].itemsStack
		if !itemsStack:
			itemsStack = itemsStackClass.instantiate()
			slots[i].insert(itemsStack)
		
		itemsStack.inventorySlot = inventorySlot
		itemsStack.update()
		
# Método para limpar o inventário
func clear_inventory() -> void:
	if inventory == null:
		print("Error: Inventory is not initialized!")
		return
	
	for slot in inventory.slots:
		slot.item = null
		slot.amount = 0
		print("Inventory cleared.")
	# Atualiza a UI para refletir a limpeza do inventário
	update()

func _on_slot_pressed(slot):
	if locked: return
	
	if slot.isEmpty(): 
		if !itemInHand: return
		
		insertItemInSlot(slot)
		return
	
	if !itemInHand:
		takeItemFromSlot(slot)
		return
		
	if slot.itemsStack.inventorySlot.item.name == itemInHand.inventorySlot.item.name:
		stackItems(slot)
		return
		
	swapItems(slot)
	
	
func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	
	oldIndex = slot.index

func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)
	
	oldIndex = -1 
	
func swapItems(slot):
	var tempItem = slot.takeItem()
	
	insertItemInSlot(slot)
	
	itemInHand = tempItem
	add_child(itemInHand)
	updateItemInHand()


func stackItems(slot):
	var slotItem: ItemsStack = slot.itemsStack
	var maxAmount = slotItem.inventorySlot.item.maxAmountPrStack
	var totalAmount = slotItem.inventorySlot.amount + itemInHand.inventorySlot.amount

	if slotItem.inventorySlot.amount == maxAmount:
		swapItems(slot)
		return
		
	if totalAmount <= maxAmount:
		slotItem.inventorySlot.amount = totalAmount
		remove_child(itemInHand)
		itemInHand = null
		oldIndex = 1
		
	else:
		slotItem.inventorySlot.amount = maxAmount
		itemInHand.inventorySlot.amount = totalAmount - maxAmount
		
	slotItem.update()
	if itemInHand: itemInHand.update()

func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size / 2
	
func putItemBack():
	locked = true
	if oldIndex < 0:
		var emptySlots = slots.filter(func (s): return s.isEmpty())
		if emptySlots.is_empty(): return
		
		oldIndex = emptySlots[0].index
	
	var targetSlot = slots[oldIndex]
	
	var tween = create_tween()
	var targetPosition = targetSlot.global_position + targetSlot.size / 2
	tween.tween_property(itemInHand, "global_position", targetPosition, 0.2)
	
	await tween.finished
	insertItemInSlot(targetSlot)
	locked = false

func _input(event):
	if Input.is_action_just_pressed("toggle_inventory"):
		toggle_inventory()
	
	if itemInHand and not locked and event is InputEventMouseMotion:
		updateItemInHand()
	
	if itemInHand && !locked && Input.is_action_just_pressed("rightClick"):
		putItemBack()
	
		# Verifica se a tecla 'D' foi pressionada para deletar o item
	if Input.is_action_just_pressed("delete_item") and itemInHand:
		delete_item(itemInHand)
	
	# Deletar item diretamente do slot selecionado
	if Input.is_action_just_pressed("delete_item") and oldIndex != -1:
		delete_item(slots[oldIndex])
	
	
func toggle_inventory() -> void:
	is_inventory_visible = not is_inventory_visible
	visible = is_inventory_visible
	Global.inventory_visible = is_inventory_visible


func delete_item(slot):
	if locked or !slot: 
		return
	
	# Se o jogador estiver segurando um item, deletá-lo
	if itemInHand:
		remove_child(itemInHand)
		itemInHand.queue_free()
		itemInHand = null
		oldIndex = -1
	else:
		# Deleta o item do slot selecionado
		slot.clear()
		inventory.slots[slot.index].item = null
		inventory.slots[slot.index].amount = 0

	update()  # Atualizar o inventário após a remoção do item
