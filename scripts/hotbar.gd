extends Control

@onready var hotbar = $"."
@onready var inventory: Inventory = preload("res://scripts/Inventory/player_inventory.tres")
@onready var boxcontainer = $Container/boxcontainer
@onready var slots: Array = $Container/boxcontainer.get_children()
@onready var selector = $Selector

var currently_selected: int = 0

func _ready():
	update()
	inventory.updated.connect(update)
	#self.grab_focus()
	

func update() -> void:
	for i in range(slots.size()):
		var inventory_slot: IventorySlot =  inventory.slots[i]
		if slots[i].has_method("update_to_slot"):
			slots[i].update_to_slot(inventory_slot)
			
	 # Conecta o sinal de clique do mouse para cada slot
		if not slots[i].is_connected("gui_input", Callable(self, "_on_slot_gui_input").bind(i)):
			slots[i].connect("gui_input", Callable(self, "_on_slot_gui_input").bind(i))


func move_selector() -> void:
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position
	#set_focus() # Garante que o foco volte para a hotbar após mover o selector
	self.grab_focus()

func _unhandled_input(event) -> void:
	if event.is_action_pressed("use_item"):
		inventory.use_item_at_index(currently_selected)
		
	if event.is_action_pressed("move_selector"):
		move_selector()
		accept_event()  # Marca o evento como tratado para impedir que outros nós o processem

# Função para tratar o clique no slot
func _on_slot_gui_input(event: InputEvent, slot_index: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		move_selector_to(slot_index)
		

func move_selector_to(index: int) -> void:
	currently_selected = index
	selector.global_position = slots[currently_selected].global_position
	
