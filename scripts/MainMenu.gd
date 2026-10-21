# =====================================================================
# MainMenu.gd — Главный Менеджер Навигации и Вкладок Приложения
# =====================================================================
extends Control

# Предварительно подгружаем все сцены модулей для быстрой смены окон
const BASE_HUB_SCENE = preload("res://scenes/BaseHub.tscn")
const INVENTORY_SCENE = preload("res://scenes/InventoryMenu.tscn")
const RAID_ZONE_SCENE = preload("res://scenes/RaidZone.tscn")

# Ссылка на верхнюю контейнерную зону, куда программно вставляются экраны
@onready var content_area: Control = $MainLayout/ContentArea

func _ready() -> void:
	# Безопасность для мобильных: ждем один кадр, пока соберутся все ноды UI
	await get_tree().process_frame
	
	# При первом запуске игры автоматически открываем хаб Убежища
	_on_tab_base_pressed()

# Универсальная функция очистки экрана от старого модуля перед показом нового
func clear_content() -> void:
	for child in content_area.get_children():
		# queue_free() безопасно удаляет ноду из памяти телефона, предотвращая лаги
		child.queue_free()

# =====================================================================
# ОБРАБОТЧИКИ НАЖАТИЙ НА НИЖНИЕ ВКЛАДКИ (ТАБЫ)
# =====================================================================

# Нажатие на кнопку "Убежище"
func _on_tab_base_pressed() -> void:
	clear_content()
	
	# Создаем копию сцены базы и крепим её на экран
	var base_instance = BASE_HUB_SCENE.instantiate()
	content_area.add_child(base_instance)
	
	print("[Система] Игрок перешел в Убежище базы. Загружен экономический хаб.")

# Нажатие на кнопку "Инвентарь"
func _on_tab_inventory_pressed() -> void:
	clear_content()
	
	# Создаем копию сцены рюкзака с куклой персонажа
	var inv_instance = INVENTORY_SCENE.instantiate()
	content_area.add_child(inv_instance)
	
	print("[Система] Игрок открыл КПК: Вкладка Инвентаря и Снаряжения.")

# Нажатие на третью кнопку
func _on_tab_raid_pressed() -> void:
	clear_content()
	
	# Загружаем интерактивную карту вместо мгновенного боя
	var map_scene = load("res://scenes/WorldMap.tscn")
	var map_instance = map_scene.instantiate()
	content_area.add_child(map_instance)
	
	print("[Система] Открыта глобальная карта Локаций и закрытых комнат Зоны.")
