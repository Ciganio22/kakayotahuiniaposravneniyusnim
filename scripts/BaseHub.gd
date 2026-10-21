# =====================================================================
# BaseHub.gd — Управление Убежищем, Техником и ММО-Рынком
# =====================================================================
extends Control

@onready var wallet_label: Label = $BaseLayout/WalletLabel
@onready var btn_repair_weapon: Button = $BaseLayout/BtnRepairWeapon
@onready var btn_repair_armor: Button = $BaseLayout/BtnRepairArmor
@onready var btn_spin_roulette: Button = $BaseLayout/BtnSpinRoulette
@onready var roulette_result_label: Label = $BaseLayout/RouletteResultLabel

# Ссылка на новый контейнер для лотов аукциона
@onready var market_container: VBoxContainer = $BaseLayout/MarketScroll/MarketContainer

func _ready() -> void:
	# Безопасность: ждем один кадр, пока соберутся все ноды интерфейса
	await get_tree().process_frame
	
	# Подключаем базовые кнопки
	btn_repair_weapon.pressed.connect(_on_repair_weapon_pressed)
	btn_repair_armor.pressed.connect(_on_repair_armor_pressed)
	btn_spin_roulette.pressed.connect(_on_spin_roulette_pressed)
	
	# Обновляем весь экран Убежища и загружаем лоты Рынка
	update_base_ui()

# Функция полного обновления интерфейса базы
func update_base_ui() -> void:
	# Обновляем кошелек из GlobalData
	wallet_label.text = "КОШЕЛЕК: " + str(GlobalData.currency_marks) + " Зн. | " + str(GlobalData.currency_dp) + " DP"
	roulette_result_label.text = ""
	
	# Обновляем кнопку ремонта оружия
	var w_id = GlobalData.current_equipment["weapon"]
	if w_id != "":
		btn_repair_weapon.text = "Починить " + GlobalData.ITEM_DATABASE[w_id]["name"] + " (" + str(int(GlobalData.current_equipment["weapon_durability"])) + "%)"
	else:
		btn_repair_weapon.text = "Оружие не надето"
		
	# Обновляем кнопку ремонта брони
	var a_id = GlobalData.current_equipment["armor"]
	if a_id != "":
		btn_repair_armor.text = "Починить " + GlobalData.ITEM_DATABASE[a_id]["name"] + " (" + str(int(GlobalData.current_equipment["armor_durability"])) + "%)"
	else:
		btn_repair_armor.text = "Броня не надета"
		
	# Отрисовываем доску объявлений Аукциона
	_render_market_lots()

# ФУНКЦИЯ ОТРИСОВКИ ЛОТОВ АУКЦИОНА НА ЭКРАНЕ ТЕЛЕФОНА
func _render_market_lots() -> void:
	# Очищаем контейнер от старых кнопок перед обновлением
	for child in market_container.get_children():
		child.queue_free()
		
	# Бежим по всему списку лотов из GlobalData
	for i in range(GlobalData.market_lots.size()):
		var lot = GlobalData.market_lots[i]
		var item_data = GlobalData.ITEM_DATABASE[lot["item_id"]]
		
		# Создаем большую горизонтальную кнопку для лота
		var lot_button = Button.new()
		
		# Формируем текст объявления: Имя пушки (Прочность) - Цена - Продавец
		var text_info = item_data["name"]
		if lot["item_id"] in ["val", "ak74", "pm", "svd", "stalker_suit", "exo_suit"]:
			text_info += " (" + str(int(lot["durability"])) + "%)"
			
		lot_button.text = text_info + " | Цена: " + str(lot["price_dp"]) + " DP | Продавец: " + lot["seller"]
		
		# Задаем размер кнопки, удобный под нажатие пальцем
		lot_button.custom_minimum_size.y = 45
		market_container.add_child(lot_button)
		
		# Привязываем к кнопке функцию покупки и передаем туда индекс лота
		lot_button.pressed.connect(func(): _on_lot_clicked(i))

# ОБРАБОТКА КЛИКА ПО ЛОТУ (ПОКУПКА)
func _on_lot_clicked(lot_index: int) -> void:
	# Вызываем функцию покупки из нашего глобального ядра
	if GlobalData.buy_item_from_market(lot_index):
		print("[Рынок] Предмет успешно куплен и добавлен в рюкзак!")
		# Мгновенно обновляем интерфейс, чтобы списать деньги и убрать купленный лот
		update_base_ui()
	else:
		print("[Рынок] Не удалось совершить покупку. Проверьте баланс DP или свободное место.")

# Функции ремонта у Техника
func _on_repair_weapon_pressed() -> void:
	if GlobalData.repair_equipped_weapon():
		update_base_ui()

func _on_repair_armor_pressed() -> void:
	if GlobalData.repair_equipped_armor():
		update_base_ui()

# Функция Колеса Удачи
func _on_spin_roulette_pressed() -> void:
	var roll = randi_range(1, 100)
	
	if roll <= 50:
		var marks_win = randi_range(50, 100)
		GlobalData.currency_marks += marks_win
		roulette_result_label.text = "ВЫИГРЫШ: Пакет ржавого лома (+ " + str(marks_win) + " Знаков)"
	elif roll <= 75:
		GlobalData.current_inventory.append({"id": "ammo_545", "count": 60})
		roulette_result_label.text = "ВЫИГРЫШ: Пачка патронов 5.45х39 (60 шт.) упала в рюкзак!"
	elif roll <= 90:
		GlobalData.current_inventory.append({"id": "medkit", "count": 1})
		roulette_result_label.text = "ВЫИГРЫШ: Армейская аптечка доставлена на склад!"
	else:
		GlobalData.currency_dp += 10
		roulette_result_label.text = "🔥 ДЖЕКПОТ! На ваш счет зачислено +10 DP! 🔥"
		
	btn_spin_roulette.disabled = true
	btn_spin_roulette.text = "Вы уже крутили рулетку сегодня"
	
	# Обновляем кошелек и рынок после выигрыша
	update_base_ui()
