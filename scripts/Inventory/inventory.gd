extends Resource

class_name Inventory

signal updated
signal use_item 

@export var slots: Array[IventorySlot]

func insert(item: Inventory_Item):
	# Primeira tentativa: adicionar o item em um slot que já contém o mesmo item e ainda tem espaço
	for slot in slots:
		if slot.item == item and slot.amount < item.maxAmountPrStack:
			slot.amount += 1
			updated.emit()
			return
	
	# Segunda tentativa: adicionar o item em um slot vazio
	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.amount = 1
			updated.emit()
			return
	
	# Se não houver slots disponíveis, emitir o sinal (pode ser usado para tratar casos de inventário cheio)
	updated.emit()

func removeSlot(inventorySlot: IventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0: return
	
	remove_at_index(index)
	
func remove_at_index(index: int) -> void:
	slots[index] = IventorySlot.new()
	updated.emit()
	
	
func insertSlot(index: int,inventorySlot: IventorySlot):
	slots[index] = inventorySlot  
	updated.emit()
	
	
func use_item_at_index(index: int) -> void:
	if index < 0 || index >= slots.size() || !slots[index].item: return
	
	var slot = slots[index]
	use_item.emit(slot.item)
	
	if slot.amount > 1:
		slot.amount -= 1
		updated.emit()
		return
	
	remove_at_index(index)
