# =====================================================================
# SkillTree.gd — Интерфейс Управления Древом Пассивных Умений
# =====================================================================
extends Control

@onready var points_label: Label = $TreeLayout/PointsLabel
@onready var nodes_container: VBoxContainer = $TreeLayout/TreeScroll/NodesContainer
@onready var btn_back: Button = $TreeLayout/BtnBack

func _ready() -> void:
	# Безопасность: ждем один кадр, пока соберутся элементы интерфейса
	await get_tree().process_frame
	
	# Подключаем кнопку возврата назад
	btn_back.pressed.connect(_on_back_pressed)
	
	# Отрисовываем созвездие на экране смартфона
	render_skill_tree()

# Функция обновления экрана древа
func render_skill_tree() -> void:
	# Обновляем счетчик доступных Очков Навыков игрока
	points_label.text = "ДОСТУПНО ОЧКОВ НАВЫКОВ: " + str(GlobalData.skill_points) + " | Уровень: " + str(GlobalData.player_level)
	
	# Полностью очищаем контейнер от старых кнопок перед перезагрузкой
	for child in nodes_container.get_children():
		child.queue_free()
		
	# Перебираем все 50+ звезд из глобальной базы данных
	for node_id in GlobalData.SKILL_TREE_DATABASE.keys():
		var node_data = GlobalData.SKILL_TREE_DATABASE[node_id]
		
		# Создаем новую кнопку под каждую звезду
		var btn = Button.new()
		
		# Настраиваем красивый текст для кнопки в зависимости от типа звезды
		var type_prefix = ""
		if node_data["type"] == "minor": type_prefix = "[Малая] "
		elif node_data["type"] == "medium": type_prefix = "🔶 [Значимая] "
		elif node_data["type"] == "major": type_prefix = "🌟 [ВЕЛИКАЯ КЛАССОВАЯ] "
		
		btn.text = type_prefix + node_data["name"]
		
		# Если игрок уже выучил эту звезду, подсвечиваем её зеленым цветом и блокируем
		if GlobalData.unlocked_skills.has(node_id):
			btn.text += " (ИЗУЧЕНО)"
			btn.modulate = Color(0.3, 1.0, 0.3) # Зеленый
		else:
			# Если звезда великая и не подходит под класс игрока — красим в красный
			if node_data["type"] == "major" and node_data["class_req"] != GlobalData.player_class:
				btn.text += " (Заблокировано для фракции " + node_data["class_req"].to_upper() + ")"
				btn.modulate = Color(1.0, 0.3, 0.3) # Красный
				
		# Настраиваем размер под палец на телефоне
		btn.custom_minimum_size.y = 50
		nodes_container.add_child(btn)
		
		# Вешаем на кнопку функцию клика и передаем туда ID конкретной звезды
		btn.pressed.connect(func(): _on_node_clicked(node_id))

# ОБРАБОТКА НАЖАТИЯ НА ЗВЕЗДУ СОЗВЕЗДИЯ
func _on_node_clicked(node_id: String) -> void:
	# Если мы уже учили это — игнорируем клик
	if GlobalData.unlocked_skills.has(node_id): return
	
	# Пытаемся выучить узел через глобальное ядро (оно само проверит связи и очки)
	if GlobalData.unlock_skill_node(node_id):
		print("[Созвездие] Успешно открыт узел: ", node_id)
		# Если изучение прошло успешно, мгновенно перерисовываем дерево умений
		render_skill_tree()
	else:
		print("[Созвездие] Ошибка изучения узла. Не хватает очков или нет связи!")

func _on_back_pressed() -> void:
	# Возвращаемся в главное меню навигации
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
