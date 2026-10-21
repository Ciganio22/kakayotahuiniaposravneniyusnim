extends Control

const ITEM_SLOT_SCENE = preload("res://scenes/ItemSlot.tscn")

@onready var item_grid: GridContainer = $MainSplitter/InventoryScroll/ItemGrid
@onready var weapon_slot: TextureButton = $MainSplitter/CharacterPanel/EquipmentGrid/WeaponSlot
@onready var armor_slot: TextureButton = $MainSplitter/CharacterPanel/EquipmentGrid/ArmorSlot
@onready var helmet_slot: TextureButton = $MainSplitter/CharacterPanel/EquipmentGrid/HelmetSlot

var max_slots = 24

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	render_equipment()
	render_inventory()

func render_equipment() -> void:
	# Читаем данные напрямую из Глобального менеджера
	weapon_slot.setup_slot(GlobalData.current_equipment["weapon"], 1, true)
	armor_slot.setup_slot(GlobalData.current_equipment["armor"], 1, true)
	helmet_slot.setup_slot(GlobalData.current_equipment["helmet"], 1, true)

func render_inventory() -> void:
	for child in item_grid.get_children():
		child.queue_free()
		
	# Работаем со списком рюкзака из Глобального менеджера
	for i in range(GlobalData.current_inventory.size()):
		var item_data = GlobalData.current_inventory[i]
		var slot_instance = ITEM_SLOT_SCENE.instantiate()
		item_grid.add_child(slot_instance)
		slot_instance.setup_slot(item_data["id"], item_data["count"], false)
		
	var empty_slots_needed = max_slots - GlobalData.current_inventory.size()
	for i in range(empty_slots_needed):
		var slot_instance = ITEM_SLOT_SCENE.instantiate()
		item_grid.add_child(slot_instance)
		slot_instance.setup_slot("", 1, false)

func handle_slot_click(slot_node) -> void:
	if slot_node.item_id == "": return
	
	# Снятие вещи с куклы в рюкзак
	if slot_node.is_equipment_slot:
		var item_to_remove = slot_node.item_id
		if GlobalData.current_inventory.size() < max_slots:
			if slot_node == weapon_slot: GlobalData.current_equipment["weapon"] = ""
			elif slot_node == armor_slot: GlobalData.current_equipment["armor"] = ""
			elif slot_node == helmet_slot: GlobalData.current_equipment["helmet"] = ""
			
			GlobalData.current_inventory.append({"id": item_to_remove, "count": 1})
			update_ui()
		return

	# Одевание вещи из рюкзака на куклу
	var clicked_id = slot_node.item_id
	
	if clicked_id == "ak74" or clicked_id == "val":
		var old_weapon = GlobalData.current_equipment["weapon"]
		GlobalData.current_equipment["weapon"] = clicked_id
		_remove_from_global_inventory(slot_node)
		if old_weapon != "": GlobalData.current_inventory.append({"id": old_weapon, "count": 1})
		update_ui()
		
	elif clicked_id == "stalker_suit" or clicked_id == "exo_suit":
		var old_armor = GlobalData.current_equipment["armor"]
		GlobalData.current_equipment["armor"] = clicked_id
		_remove_from_global_inventory(slot_node)
		if old_armor != "": GlobalData.current_inventory.append({"id": old_armor, "count": 1})
		update_ui()

func _remove_from_global_inventory(slot_node) -> void:
	for i in range(GlobalData.current_inventory.size()):
		if GlobalData.current_inventory[i]["id"] == slot_node.item_id:
			GlobalData.current_inventory.remove_at(i)
			break
