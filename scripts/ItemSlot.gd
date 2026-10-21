extends TextureButton

@onready var item_icon: TextureRect = $ItemIcon
@onready var count_label: Label = $CountLabel

var item_id: String = ""
var item_count: int = 1
var is_equipment_slot: bool = false # Теперь ячейка знает, где она находится

# Функция принимает ТРИ аргумента (третий по умолчанию равен false)
func setup_slot(id: String, count: int, is_equip: bool = false) -> void:
	item_id = id
	item_count = count
	is_equipment_slot = is_equip
	
	# Если ячейка пустая — очищаем всё
	if item_id == "":
		item_icon.texture = null
		count_label.text = ""
		return
		
	# Путь к картинке на будущее
	var image_path = "res://assets/items/" + item_id + ".png"
	
	if ResourceLoader.exists(image_path):
		item_icon.texture = load(image_path)
	else:
		item_icon.texture = null
		
	# Отображение количества
	if item_count > 1:
		count_label.text = "x" + str(item_count)
	else:
		count_label.text = ""

# Клик по ячейке
func _pressed() -> void:
	# Находим главный скрипт меню инвентаря и передаем ему сигнал о клике
	var main_menu = get_tree().current_scene
	if main_menu and main_menu.has_method("handle_slot_click"):
		main_menu.handle_slot_click(self)
