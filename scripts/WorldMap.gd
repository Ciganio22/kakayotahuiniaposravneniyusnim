# =====================================================================
# WorldMap.gd — Интерфейс Выбора Локаций и Проверки Ключей Доступа
# =====================================================================
extends Control

@onready var regions_container: VBoxContainer = $MapLayout/MapScroll/RegionsContainer

func _ready() -> void:
	await get_tree().process_frame
	render_map()

func render_map() -> void:
	for child in regions_container.get_children(): child.queue_free()
	
	# Генерируем кнопки для всех 4-х Тиров Зоны
	for tier in GlobalData.REGIONS_DATABASE.keys():
		var region = GlobalData.REGIONS_DATABASE[tier]
		var req_key = region["key_required"]
		
		# Создаем заголовок Тира
		var tier_label = Label.new()
		tier_label.text = "\n[ ТИР " + str(tier) + " — " + region["name"].to_upper() + " ]"
		if req_key != "" and not GlobalData.has_key_in_inventory(req_key):
			tier_label.text += " 🔒 ЗАКРЫТО"
		regions_container.add_child(tier_label)
		
		# Выводим локации этого Тира
		for loc_name in region["locations"]:
			var btn = Button.new()
			btn.text = "Вылазка: " + loc_name
			btn.custom_minimum_size.y = 50
			
			# Если у игрока нет ключа для этого Тира, блокируем кнопку
			if req_key != "" and not GlobalData.has_key_in_inventory(req_key):
				btn.disabled = true
				btn.text = "🔒 Нужен: " + req_key.to_upper()
				
			regions_container.add_child(btn)
			
			# При нажатии запускаем рейд на этой локации
			btn.pressed.connect(func(): _start_raid_on_location(tier, loc_name, req_key))

func _start_raid_on_location(tier: int, loc_name: String, key_to_use: String) -> void:
	# Тратим ключ для входа в закрытую комнату/зону
	GlobalData.consume_key(key_to_use)
	
	# Записываем параметры выбранной локации в активную карту, чтобы боевой экран их прочитал
	GlobalData.active_raid_map["map_name"] = loc_name
	GlobalData.active_raid_map["zone_tier"] = tier
	
	print("[Карта] Игрок открыл комнату ключом и входит на локацию: ", loc_name)
	
	# Меняем экран внутри контента через вызов главного меню
	var main_menu = get_tree().current_scene
	if main_menu and main_menu.has_method("clear_content"):
		main_menu.clear_content()
		var raid_scene = load("res://scenes/RaidZone.tscn").instantiate()
		main_menu.content_area.add_child(raid_scene)
