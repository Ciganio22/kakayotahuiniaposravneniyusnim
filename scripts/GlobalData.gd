# =====================================================================
# GlobalData.gd — Главное Глобальное Ядро Игры (Autoload / Singleton)
# =====================================================================
extends Node

# =====================================================================
# 1. ПОЛНАЯ БАЗА ДАННЫХ ПРЕДМЕТОВ ЗОНЫ (ITEM DATABASE)
# =====================================================================
const ITEM_DATABASE = {
	# ===== ТИР 1 (ОКРАИНЫ И ПРИГОРОД — СТАРТ) =====
	"pm": {
		"name": "ПМ", "type": "weapon", "class": "pistol", "tier": 1,
		"fire_rate": 1.0, "damage": 12.0, "max_magazine": 8, "ammo_type": "ammo_9x18",
		"durability_drain": 0.2, "slots": ["barrel", "magazine"]
	},
	"bm16": {
		"name": "Обрез БМ-16", "type": "weapon", "class": "shotgun", "tier": 1,
		"fire_rate": 1.5, "damage": 45.0, "max_magazine": 2, "ammo_type": "ammo_12cal",
		"durability_drain": 0.8, "slots": []
	},
	"ak74u": {
		"name": "АКС-74У", "type": "weapon", "class": "rifle", "tier": 1,
		"fire_rate": 1.8, "damage": 18.0, "max_magazine": 30, "ammo_type": "ammo_545",
		"durability_drain": 0.4, "slots": ["barrel", "magazine", "foregrip"]
	},
	"toz34_hunting": {
		"name": "ТОЗ-34 Охотничья", "type": "weapon", "class": "sniper", "tier": 1,
		"fire_rate": 3.0, "damage": 65.0, "max_magazine": 2, "ammo_type": "ammo_12cal",
		"durability_drain": 0.6, "slots": ["scope"]
	},

	# ===== ТИР 2 (ГОРОДСКИЕ РАЗВАЛИНЫ — СТАЛКЕРЫ) =====
	"fort12": {
		"name": "Форт-12", "type": "weapon", "class": "pistol", "tier": 2,
		"fire_rate": 0.8, "damage": 16.0, "max_magazine": 12, "ammo_type": "ammo_9x18",
		"durability_drain": 0.15, "slots": ["barrel", "magazine", "laser"]
	},
	"chaser13": {
		"name": "СПСА-14 (Чейзер)", "type": "weapon", "class": "shotgun", "tier": 2,
		"fire_rate": 2.2, "damage": 75.0, "max_magazine": 6, "ammo_type": "ammo_12cal",
		"durability_drain": 0.5, "slots": ["foregrip"]
	},
	"ak74": {
		"name": "АК-74М", "type": "weapon", "class": "rifle", "tier": 2,
		"fire_rate": 2.0, "damage": 25.0, "max_magazine": 30, "ammo_type": "ammo_545",
		"durability_drain": 0.3, "slots": ["scope", "barrel", "foregrip", "magazine"]
	},
	"vintorez_worn": {
		"name": "Поношенный ВСС", "type": "weapon", "class": "sniper", "tier": 2,
		"fire_rate": 2.5, "damage": 55.0, "max_magazine": 10, "ammo_type": "ammo_9x39",
		"durability_drain": 0.5, "slots": ["magazine"]
	},

	# ===== ТИР 3 (ИНДУСТРИАЛЬНАЯ ЗОНА — ВЕТЕРАНЫ) =====
	"beretta": {
		"name": "Beretta 92FS", "type": "weapon", "class": "pistol", "tier": 3,
		"fire_rate": 0.6, "damage": 22.0, "max_magazine": 15, "ammo_type": "ammo_9x19",
		"durability_drain": 0.1, "slots": ["barrel", "magazine", "laser"]
	},
	"wincheaster": {
		"name": "Винчестер 1300", "type": "weapon", "class": "shotgun", "tier": 3,
		"fire_rate": 2.0, "damage": 110.0, "max_magazine": 8, "ammo_type": "ammo_12cal",
		"durability_drain": 0.4, "slots": ["foregrip", "laser"]
	},
	"val": {
		"name": "АС 'Вал'", "type": "weapon", "class": "rifle", "tier": 3,
		"fire_rate": 1.4, "damage": 35.0, "max_magazine": 20, "ammo_type": "ammo_9x39",
		"durability_drain": 0.4, "slots": ["scope", "foregrip", "magazine"]
	},
	"svd": {
		"name": "СВД", "type": "weapon", "class": "sniper", "tier": 3,
		"fire_rate": 4.0, "damage": 110.0, "max_magazine": 10, "ammo_type": "ammo_762",
		"durability_drain": 0.6, "slots": ["scope", "magazine"]
	},

	# ===== ТИР 4 (СЕРДЦЕ АНОМАЛИИ — ЭНДГЕЙМ ЛЕГЕНДЫ) =====
	"desert_eagle": {
		"name": "Черный Ястреб (Deagle)", "type": "weapon", "class": "pistol", "tier": 4,
		"fire_rate": 1.2, "damage": 65.0, "max_magazine": 7, "ammo_type": "ammo_1143",
		"durability_drain": 0.5, "slots": ["scope", "laser"]
	},
	"protecta": {
		"name": "Отбойник (Protecta)", "type": "weapon", "class": "shotgun", "tier": 4,
		"fire_rate": 1.6, "damage": 140.0, "max_magazine": 12, "ammo_type": "ammo_12cal",
		"durability_drain": 0.3, "slots": ["foregrip", "laser"]
	},
	"fn2000": {
		"name": "ФН Ф2000", "type": "weapon", "class": "rifle", "tier": 4,
		"fire_rate": 1.2, "damage": 42.0, "max_magazine": 30, "ammo_type": "ammo_556",
		"durability_drain": 0.25, "slots": ["barrel", "magazine"]
	},
	"gauss_rifle": {
		"name": "Гаусс-пушка", "type": "weapon", "class": "sniper", "tier": 4,
		"fire_rate": 6.0, "damage": 350.0, "max_magazine": 5, "ammo_type": "ammo_gauss",
		"durability_drain": 1.2, "slots": []
	},

	# ===== ТАКТИЧЕСКИЕ ОБВЕСЫ (МОДИФИКАТОРЫ) =====
	"scope_pso": {"name": "Прицел ПСО-1", "type": "mod", "slot": "scope", "crit_bonus": 0.15, "fire_rate_penalty": 0.0},
	"silencer_pbs": {"name": "Глушитель ПБС", "type": "mod", "slot": "barrel", "agro_reduction": 0.30},
	"lcu_laser": {"name": "ЛЦУ 'Блик'", "type": "mod", "slot": "laser", "enemy_slow": 0.08},
	"mag_fast": {"name": "Быстрый магазин", "type": "mod", "slot": "magazine", "reload_buff": 0.30},

	# ===== БРОНЕКОСТЮМЫ =====
	"stalker_suit": {"name": "Комбинезон 'Сталкер'", "type": "armor", "max_armor": 100.0, "tier": 2},
	"exo_suit": {"name": "Тяжелый Экзоскелет", "type": "armor", "max_armor": 250.0, "tier": 4},

	# ===== РАСХОДНИКИ И ПРИПАСЫ =====
	"ammo_9x18": {"name": "Патроны 9х18 мм", "type": "ammo", "stack": 50},
	"ammo_12cal": {"name": "Дробь 12 кал.", "type": "ammo", "stack": 15},
	"ammo_545": {"name": "Патроны 5.45х39 мм", "type": "ammo", "stack": 60},
	"ammo_939": {"name": "Патроны 9х39 мм ББ", "type": "ammo", "stack": 20},
	"ammo_762": {"name": "Снайперский 7.62 мм", "type": "ammo", "stack": 20},
	"ammo_9x19": {"name": "Патроны 9х19 мм", "type": "ammo", "stack": 50},
	"ammo_1143": {"name": "Патроны .45 ACP", "type": "ammo", "stack": 40},
	"ammo_556": {"name": "Патроны 5.56х45 НАТО", "type": "ammo", "stack": 60},
	"ammo_gauss": {"name": "Батареи Гаусса", "type": "ammo", "stack": 10},
	"medkit": {"name": "Армейская аптечка", "type": "usable", "heal": 50.0},
	"antirad": {"name": "Антирадин", "type": "usable", "rad_cure": 100.0},
	"scrap_metal": {"name": "Ржавый лом", "type": "junk"},
	"key_tier_2": {"name": "Ключ от Развалин", "type": "junk"},
	"key_tier_3": {"name": "Ключ от Промзоны", "type": "junk"},
	"key_tier_4": {"name": "Ключ от Саркофага", "type": "junk"}
}

# =====================================================================
# 2. ТЕКУЩИЕ ДАННЫЕ ПЕРСОНАЖА (СОСТОЯНИЕ И ПРОГРЕССИЯ)
# =====================================================================
var player_class: String = "" # Доступные классы: medic, military, marauder
var player_level: int = 1
var player_xp: int = 0
var skill_points: int = 2 # 2 стартовых очка для Древа Созвездий PoE

# Двухвалютная система
var currency_marks: int = 1000 # Базовая игровая валюта (Знаки)
var currency_dp: int = 50      # Донат-валюта (DonatePoints)

# Жизненные показатели
var player_hp: float = 100.0
var player_max_hp: float = 100.0
var player_radiation: float = 0.0
var player_psy: float = 100.0

# Активная экипировка на кукле персонажа (+ износ в реальном времени)
var current_equipment = {
	"weapon": "pm",                 # Стартуем с ПМ
	"weapon_durability": 100.0,     # 100% прочность оружия
	"armor": "",                    # Без брони
	"armor_durability": 100.0,
	"helmet": "",
	"weapon_mods": {
		"scope": "", "barrel": "", "foregrip": "", "magazine": "", "laser": ""
	}
}

# Текущий рюкзак (Инвентарь игрока)
var current_inventory = [
	{"id": "ak74", "count": 1, "durability": 100.0},
	{"id": "stalker_suit", "count": 1, "durability": 100.0},
	{"id": "lcu_laser", "count": 1},
	{"id": "mag_fast", "count": 1},
	{"id": "ammo_545", "count": 120},
	{"id": "ammo_9x18", "count": 50},
	{"id": "medkit", "count": 5}
]

# Список ID открытых звезд в созвездии Path of Exile
var unlocked_skills = []

# =====================================================================
# 3. ФУНКЦИИ РАСЧЕТА ДИНАМИЧЕСКИХ СТАТОВ ОРУЖИЯ ДЛЯ ЭКРАНА БОЯ
# =====================================================================

# Выдает полные и измененные обвесами характеристики текущего оружия
func get_active_weapon_stats() -> Dictionary:
	var w_id = current_equipment["weapon"]
	
	# Безопасная проверка: если оружия нет, бьем кулаками
	if w_id == "" or not ITEM_DATABASE.has(w_id):
		return {
			"name": "Кулаки", "fire_rate": 1.0, "damage": 5.0, "max_magazine": 999,
			"durability_drain": 0.0, "crit_bonus": 0.0, "enemy_slow": 0.0, 
			"reload_buff": 0.0, "agro_reduction": 0.0, "current_durability": 100.0
		}
	
	# Дублируем базовые статы из базы данных, чтобы не перезаписать оригинал
	var final_stats = ITEM_DATABASE[w_id].duplicate()
	
	# Добавляем пустые ячейки под бонусы от обвесов
	final_stats["crit_bonus"] = 0.0
	final_stats["enemy_slow"] = 0.0
	final_stats["reload_buff"] = 0.0
	final_stats["agro_reduction"] = 0.0
	final_stats["current_durability"] = current_equipment["weapon_durability"]
	
	# Бежим по установленным обвесам оружия и суммируем их бонусы
	var active_mods = current_equipment["weapon_mods"]
	for slot in active_mods.keys():
		var mod_id = active_mods[slot]
		if mod_id != "" and ITEM_DATABASE.has(mod_id):
			var mod_data = ITEM_DATABASE[mod_id]
			if mod_data.has("crit_bonus"): final_stats["crit_bonus"] += mod_data["crit_bonus"]
			if mod_data.has("enemy_slow"): final_stats["enemy_slow"] += mod_data["enemy_slow"]
			if mod_data.has("reload_buff"): final_stats["reload_buff"] += mod_data["reload_buff"]
			if mod_data.has("agro_reduction"): final_stats["agro_reduction"] += mod_data["agro_reduction"]
			
	return final_stats

# Выдает характеристики надетой брони
func get_equipped_armor_stats() -> Dictionary:
	var armor_id = current_equipment["armor"]
	if armor_id != "" and ITEM_DATABASE.has(armor_id):
		var armor_data = ITEM_DATABASE[armor_id].duplicate()
		armor_data["current_durability"] = current_equipment["armor_durability"]
		return armor_data
	return {"name": "Нет брони", "max_armor": 0.0, "current_durability": 0.0, "tier": 1}

# =====================================================================
# 4. СИСТЕМА ЭКОНОМИКИ И РЕМОНТА У ТЕХНИКА НА БАЗЕ
# =====================================================================

# Таблица стоимости починки 1% износа в зависимости от Тира предмета
func get_repair_cost_per_percent(tier: int) -> int:
	match tier:
		1: return 5   # Эконом (100% ремонт ПМ = 500 Знаков)
		2: return 15  # Сталкерский уровень (100% ремонт АК-74 = 1500 Знаков)
		3: return 40  # Ветеранский уровень (100% ремонт ВАЛ = 4000 Знаков)
		4: return 120 # Эндгейм/Донат уровень (100% ремонт Гаусса = 12000 Знаков!)
	return 5

# Функция ремонта текущего надетого оружия у Техника за Знаки
func repair_equipped_weapon() -> bool:
	var w_id = current_equipment["weapon"]
	if w_id == "": return false
	
	var item_data = ITEM_DATABASE[w_id]
	var current_dur = current_equipment["weapon_durability"]
	
	# Если пушка новая — чинить нечего
	if current_dur >= 100.0:
		print("Техник: Оружие полностью исправно!")
		return false
		
	var missing_durability = 100.0 - current_dur
	var cost_per_percent = get_repair_cost_per_percent(item_data["tier"])
	var total_cost = int(missing_durability * cost_per_percent)
	
	# Проверка баланса кошелька игрока
	if currency_marks >= total_cost:
		currency_marks -= total_cost
		current_equipment["weapon_durability"] = 100.0
		print("Техник: Оружие отремонтировано. Списано Знаков: ", total_cost)
		return true
	else:
		print("Техник: Недостаточно Знаков для ремонта пушки! Требуется: ", total_cost)
		return false

# Функция ремонта текущего надетого бронекостюма за Знаки
func repair_equipped_armor() -> bool:
	var armor_id = current_equipment["armor"]
	if armor_id == "": return false
	
	var item_data = ITEM_DATABASE[armor_id]
	var current_dur = current_equipment["armor_durability"]
	
	if current_dur >= 100.0:
		print("Техник: Броня в идеальном состоянии!")
		return false
		
	var missing_durability = 100.0 - current_dur
	var cost_per_percent = get_repair_cost_per_percent(item_data["tier"])
	var total_cost = int(missing_durability * cost_per_percent)
	
	if currency_marks >= total_cost:
		currency_marks -= total_cost
		current_equipment["armor_durability"] = 100.0
		print("Техник: Броня полностью залатана. Списано Знаков: ", total_cost)
		return true
	else:
		print("Техник: Не хватает Знаков на ремонт брони! Требуется: ", total_cost)
		return false
# =====================================================================
# 5. МАТЕМАТИКА ОПЫТА, УРОВНЕЙ И ПОРОГОВ (HARDCORE PROGRESSION)
# =====================================================================
# Функция рассчитывает, сколько XP нужно для достижения СЛЕДУЮЩЕГО уровня
func get_required_xp_for_level(lvl: int) -> int:
	# Базовая хардкорная формула: 150 * (Текущий Уровень)^2.2
	return int(150.0 * pow(float(lvl), 2.2))

# Функция начисления опыта игроку (вызывается в конце боя или квеста)
# Передаем: количество базового опыта и тир локации, где он был добыт
func add_xp(amount: int, zone_tier: int) -> void:
	# Проверяем жесткие Пороги Уровней (Level Caps)
	if player_level == 15 and not is_base_module_unlocked("hq_2"):
		print("Опыт заморожен! Требуется улучшить Главный зал Базы до 2 уровня.")
		return
	if player_level == 30 and not is_base_module_unlocked("lab_1"):
		print("Опыт заморожен! Требуется принести ученым квестовый артефакт.")
		return
	if player_level == 45 and not is_base_module_unlocked("elite_contract"):
		print("Опыт заморожен! Вы достигли пред-эндгейм порога.")
		return
		
	# Расчет затухания опыта (Diminishing Returns) в зависимости от Тира зоны
	var final_xp = amount
	var level_diff = player_level - (zone_tier * 12) # Примерный уровень зоны
	
	if level_diff >= 15:
		final_xp = int(amount * 0.05) # Всего 5% опыта, если перекачан для зоны
		print("Зона слишком легкая! Опыт срезан на 95%.")
	elif level_diff >= 10:
		final_xp = int(amount * 0.40) # 40% опыта
		print("Опыт срезан на 60% из-за разницы уровней.")
	elif level_diff >= 5:
		final_xp = int(amount * 0.75) # 75% опыта
		
	player_xp += final_xp
	print("Получено опыта: ", final_xp, " (Текущий: ", player_xp, "/", get_required_xp_for_level(player_level), ")")
	
	# Проверка левел-апа
	_check_level_up()

# Внутренняя функция проверки повышения уровня
func _check_level_up() -> void:
	var required_xp = get_required_xp_for_level(player_level)
	
	while player_xp >= required_xp and player_level < 50:
		player_xp -= required_xp
		player_level += 1
		skill_points += 1 # Даем 1 очко навыка под Созвездие
		print("--- ЛЕВЕЛ АП! Вы достигли ", player_level, " уровня. Очков навыков: ", skill_points, " ---")
		required_xp = get_required_xp_for_level(player_level)

# Временная техническая функция для проверки разблокировки квестов/комнат
# (На 4 этапе мы свяжем её с реальными комнатами Убежиеща)
func is_base_module_unlocked(module_id: String) -> bool:
	# Пока возвращаем true, чтобы игра не блокировала прокачку на тестах
	return true
# =====================================================================
# 6. БАЗА ДАННЫХ СОЗВЕЗДИЯ POE (SKILL TREE DATABASE)
# =====================================================================
const SKILL_TREE_DATABASE = {
	# --- СТАРТОВАЯ ЗОНА ВОЕННОГО (ЮГО-ВОСТОК) ---
	"mil_start": {"name": "Армейская подготовка", "type": "minor", "connections": ["mil_dmg_1", "mil_hp_1"], "bonus": {"damage_pct": 0.02}},
	"mil_dmg_1": {"name": "Тяжелый свинец I", "type": "minor", "connections": ["mil_start", "mil_dmg_2"], "bonus": {"damage_pct": 0.03}},
	"mil_dmg_2": {"name": "Тяжелый свинец II", "type": "minor", "connections": ["mil_dmg_1", "mil_crit_1"], "bonus": {"damage_pct": 0.03}},
	"mil_crit_1": {"name": "Прицельный огонь", "type": "medium", "connections": ["mil_dmg_2", "mil_keynote"], "bonus": {"crit_chance": 0.05}},
	# БОЛЬШАЯ ЗВЕЗДА ВОЕННОГО
	"mil_keynote": {"name": "Абсолютное Подавление", "type": "major", "connections": ["mil_crit_1"], "class_req": "military", "bonus": {"triple_damage_chance": 0.10}},

	"mil_hp_1": {"name": "Армейский бронежилет I", "type": "minor", "connections": ["mil_start", "mil_hp_2"], "bonus": {"armor_pct": 0.05}},
	"mil_hp_2": {"name": "Армейский бронежилет II", "type": "minor", "connections": ["mil_hp_1", "bridge_mil_med"], "bonus": {"armor_pct": 0.05}},

	# --- МОСТИК МЕЖДУ ВОЕННЫМ И МЕДИКОМ ---
	"bridge_mil_med": {"name": "Полевая доврачебная помощь", "type": "minor", "connections": ["mil_hp_2", "med_start"], "bonus": {"heal_pct": 0.05}},

	# --- СТАРТОВАЯ ЗОНА МЕДИКА (СЕВЕР) ---
	"med_start": {"name": "Медицинский факультет", "type": "minor", "connections": ["bridge_mil_med", "med_rad_1", "med_heal_1"], "bonus": {"heal_pct": 0.05}},
	"med_rad_1": {"name": "Защита от излучения I", "type": "minor", "connections": ["med_start", "med_rad_2"], "bonus": {"rad_res": 0.10}},
	"med_rad_2": {"name": "Защита от излучения II", "type": "minor", "connections": ["med_rad_1", "med_art_1"], "bonus": {"rad_res": 0.15}},
	"med_art_1": {"name": "Изучение аномалий", "type": "medium", "connections": ["med_rad_2", "med_keynote"], "bonus": {"art_scan_speed": 0.15}},
	# БОЛЬШАЯ ЗВЕЗДА МЕДИКА
	"med_keynote": {"name": "Анатомическая Точность", "type": "major", "connections": ["med_art_1"], "class_req": "medic", "bonus": {"heal_crit_buff": 0.25}},

	"med_heal_1": {"name": "Улучшенные стимуляторы I", "type": "minor", "connections": ["med_start", "med_heal_2"], "bonus": {"heal_pct": 0.05}},
	"med_heal_2": {"name": "Улучшенные стимуляторы II", "type": "minor", "connections": ["med_heal_1", "bridge_med_mar"], "bonus": {"hp_max_bonus": 10.0}},

	# --- МОСТИК МЕЖДУ МЕДИКОМ И МАРОДЕРОМ ---
	"bridge_med_mar": {"name": "Контрабанда медикаментов", "type": "minor", "connections": ["med_heal_2", "mar_start"], "bonus": {"marks_bonus_pct": 0.05}},

	# --- СТАРТОВАЯ ЗОНА МАРОДЕРА (ЮГО-ЗАПАД) ---
	"mar_start": {"name": "Уличная академия", "type": "minor", "connections": ["bridge_med_mar", "mar_loot_1", "mar_dot_1"], "bonus": {"marks_bonus_pct": 0.05}},
	"mar_loot_1": {"name": "Зоркий глаз I", "type": "minor", "connections": ["mar_start", "mar_loot_2"], "bonus": {"loot_chance_pct": 0.05}},
	"mar_loot_2": {"name": "Зоркий глаз II", "type": "minor", "connections": ["mar_loot_1", "mar_steal_1"], "bonus": {"loot_chance_pct": 0.05}},
	"mar_steal_1": {"name": "Воровской кураж", "type": "medium", "connections": ["mar_loot_2", "mar_keynote"], "bonus": {"bag_slots_buff": 4.0}},
	# БОЛЬШАЯ ЗВЕЗДА МАРОДЕРА
	"mar_keynote": {"name": "Воровская жадность", "type": "major", "connections": ["mar_steal_1"], "class_req": "marauder", "bonus": {"low_space_dmg": 0.30}},

	"mar_dot_1": {"name": "Заточка ножей I", "type": "minor", "connections": ["mar_start", "mar_dot_2"], "bonus": {"dot_damage_pct": 0.10}},
	"mar_dot_2": {"name": "Заточка ножей II", "type": "minor", "connections": ["mar_dot_1", "bridge_mar_mil"], "bonus": {"dot_duration": 2.0}},

	# --- МОСТИК ЗАМЫКАЮЩИЙ КРУГ (ОТ МАРОДЕРА К ВОЕННОМУ) ---
	"bridge_mar_mil": {"name": "Трофейное оружие", "type": "minor", "connections": ["mar_dot_2", "mil_start"], "bonus": {"reload_speed_pct": 0.05}}
}

# Функция изучения узла в Созвездии
func unlock_skill_node(node_id: String) -> bool:
	if not SKILL_TREE_DATABASE.has(node_id): return false
	if skill_points <= 0: return false
	if unlocked_skills.has(node_id): return false
	
	var node_data = SKILL_TREE_DATABASE[node_id]
	
	# Проверка классового ограничения на Большие звезды
	if node_data["type"] == "major" and node_data["class_req"] != player_class:
		print("Нельзя взять! Эта Великая звезда доступна только классу: ", node_data["class_req"])
		return false
		
	# Проверка связей: узел должен быть соединен с уже изученным (кроме стартовых)
	if unlocked_skills.size() > 0:
		var has_connection = false
		for conn in node_data["connections"]:
			if unlocked_skills.has(conn):
				has_connection = true
				break
		if not has_connection:
			print("Сначала проложите путь к этой звезде через соседние узлы!")
			return false
			
	# Списываем очко и добавляем в список открытых
	skill_points -= 1
	unlocked_skills.append(node_id)
	print("Изучена звезда созвездия: ", node_data["name"])
	return true
# =====================================================================
# 7. МУЛЬТИПЛЕЕР: СИСТЕМА КЛАНОВ, ЛОББИ И МОДИФИКАТОРОВ КАРТ
# =====================================================================

# Данные вашего клана (если игрок в нем состоит)
var clan_data = {
	"in_clan": true,
	"clan_name": "ДОЛГ_ММО",
	"radio_level": 1, # Клановая постройка (+5% XP всем)
	"clan_vault_marks": 50000
}

# Текущее сетевое лобби рейда (Максимум 3 игрока)
var current_lobby = [
	{"name": "Вы (Военный)", "class": "military", "damage_mod": 1.0},
	{"name": "Сталкер_Медик", "class": "medic", "damage_mod": 0.8},
	{"name": "Призрак_Мародер", "class": "marauder", "damage_mod": 1.1}
]

# Активная Карта Зоны со случайными модификаторами (аналог PoE Maps)
var active_raid_map = {
	"map_name": "Саркофаг [Оскверненный]",
	"zone_tier": 4,
	"enemy_hp_multiplier": 1.2,     # +20% HP монстрам из-за карты
	"enemy_speed_multiplier": 1.15,  # +15% скорости атаки врагам
	"dp_loot_bonus_pct": 10          # +10% шанс найти DP на рынке
}

# Функция проверки кланового бонуса к опыту
func get_clan_xp_bonus() -> float:
	if clan_data["in_clan"]:
		return 1.0 + (clan_data["radio_level"] * 0.05) # +5% за каждый уровень вышки
	return 1.0
# =====================================================================
# 8. КЛАССОВЫЕ БОНУСЫ И ФРАКЦИОННАЯ ДИПЛОМАТИЯ
# =====================================================================

# Выдает текстовое имя класса для интерфейса
func get_class_name_ru() -> String:
	match player_class:
		"medic": return "Медик (Ученые)"
		"military": return "Военный (Армия)"
		"marauder": return "Мародер (Бандиты)"
	return "Без класса"

# Бонус к урону в зависимости от фракции
func get_class_damage_modifier() -> float:
	if player_class == "military": return 1.25 # Военные бьют на 25% сильнее
	return 1.0

# Бонус к защите брони
func get_class_armor_modifier() -> float:
	if player_class == "military": return 1.20 # У Военных броня прочнее на 20%
	return 1.0

# Бонус к лечению аптечками
func get_class_heal_modifier() -> float:
	if player_class == "medic": return 1.50 # Медик лечится на 50% эффективнее
	return 1.0

# Бонус к пассивному заработку Знаков
func get_class_marks_modifier() -> float:
	if player_class == "marauder": return 1.30 # Мародер находит на 30% больше Знаков
	return 1.0
# =====================================================================
# 9. СИСТЕМА ММО-АУКЦИОНА И РЫНКА (MARKETPLACE НА DP)
# =====================================================================

# Глобальный список всех выставленных на продажу лотов в игре
# В реальной MMO эти данные шли бы с сервера, у нас — умная симуляция
var market_lots = [
	{"lot_id": 101, "seller": "Сталкер_Зоба", "item_id": "val", "price_dp": 80, "durability": 100.0},
	{"lot_id": 102, "seller": "Медик_Борис", "item_id": "scope_pso", "price_dp": 25, "durability": 100.0}
]

# Счетчик для генерации уникальных ID новых лотов
var next_lot_id: int = 103

# Функция: Выставить предмет из рюкзака на Рынок за DP
# Передаем индекс предмета в массиве current_inventory и желаемую цену
func list_item_on_market(inventory_index: int, price_in_dp: int) -> bool:
	if inventory_index < 0 or inventory_index >= current_inventory.size(): return false
	if price_in_dp <= 0: return false
	
	var item_to_sell = current_inventory[inventory_index]
	
	# Разрешаем продавать только оружие, брони и обвесы (патроны и хлам не продаем)
	var item_type = ITEM_DATABASE[item_to_sell["id"]]["type"]
	if item_type != "weapon" and item_type != "armor" and item_type != "mod":
		print("[Рынок] Ошибка: Можно продавать только снаряжение и обвесы!")
		return false
		
	# Сохраняем прочность, если это оружие или броня
	var item_durability = 100.0
	if item_to_sell.has("durability"):
		item_durability = item_to_sell["durability"]
		
	# Создаем лот на рынке
	var new_lot = {
		"lot_id": next_lot_id,
		"seller": "Вы",
		"item_id": item_to_sell["id"],
		"price_dp": price_in_dp,
		"durability": item_durability
	}
	
	market_lots.append(new_lot)
	next_lot_id += 1
	
	# Удаляем предмет из рюкзака продавца
	current_inventory.remove_at(inventory_index)
	print("[Рынок] Вы успешно выставили ", ITEM_DATABASE[new_lot["item_id"]]["name"], " на продажу за ", price_in_dp, " DP.")
	return true

# Функция: Купить предмет на Рынке за DP
func buy_item_from_market(lot_index: int) -> bool:
	if lot_index < 0 or lot_index >= market_lots.size(): return false
	
	var lot = market_lots[lot_index]
	
	# Проверка: нельзя купить свой собственный лот
	if lot["seller"] == "Вы":
		print("[Рынок] Вы не можете купить свой собственный предмет!")
		return false
		
	# Проверяем рюкзак на наличие свободного места (макс 24 слота)
	if current_inventory.size() >= 24:
		print("[Рынок] Ошибка: Рюкзак полон! Освободите место перед покупкой.")
		return false
		
	# Проверяем, хватает ли донат-монет DP у покупателя
	if currency_dp < lot["price_dp"]:
		print("[Рынок] Недостаточно DP для покупки этого лота! Требуется: ", lot["price_dp"])
		return false
		
	# Списываем DP у покупателя
	currency_dp -= lot["price_dp"]
	
	# Расчет 5% налога системы (вывод валюты из игры)
	var tax = int(lot["price_dp"] * 0.05)
	var seller_profit = lot["price_dp"] - tax
	
	# Если продавец — реальный NPC/игрок, ему зачисляются DP (в симуляции просто пишем в лог)
	print("[Рынок] Сделка совершена! Удержан налог системы: ", tax, " DP. Продавец получил: ", seller_profit, " DP.")
	
	# Добавляем купленный предмет в инвентарь покупателя с сохранением его прочности
	var new_item = {"id": lot["item_id"], "count": 1}
	if lot["item_id"] in ["ak74", "pm", "val", "svd", "stalker_suit", "exo_suit"]: # если это снаряжение
		new_item["durability"] = lot["durability"]
		
	current_inventory.append(new_item)
	
	# Удаляем лот с доски объявлений рынка
	market_lots.remove_at(lot_index)
	return true
# =====================================================================
# 10. БАЗА ДАННЫХ МОНСТРОВ И БОССОВ ПО ТИРАМ (BESTIARY)
# =====================================================================
const ENEMY_DATABASE = {
	# ===== ТИР 1: ОКРАИНЫ И ПРИГОРОД =====
	"tier_1": {
		"normal": [
			{"name": "Слепой пес", "hp": 60.0, "damage": 10.0, "attack_speed": 1.5, "xp": 20},
			{"name": "Радиоактивная крыса", "hp": 40.0, "damage": 6.0, "attack_speed": 1.0, "xp": 15},
			{"name": "Мародер-новичок", "hp": 80.0, "damage": 14.0, "attack_speed": 2.2, "xp": 25}
		],
		"boss": {"name": "Дед-Людоед", "hp": 250.0, "damage": 25.0, "attack_speed": 3.0, "xp": 500}
	},
	
	# ===== ТИР 2: ГОРОДСКИЕ РАЗВАЛИНЫ =====
	"tier_2": {
		"normal": [
			{"name": "Мутировавший кабан", "hp": 180.0, "damage": 22.0, "attack_speed": 2.5, "xp": 90},
			{"name": "Зомбированный сталкер", "hp": 150.0, "damage": 18.0, "attack_speed": 2.0, "xp": 80},
			{"name": "Пси-мышь", "hp": 90.0, "damage": 12.0, "attack_speed": 1.2, "xp": 100}
		],
		"boss": {"name": "Бригадир Борзый", "hp": 600.0, "damage": 40.0, "attack_speed": 2.8, "xp": 2500}
	},
	
	# ===== ТИР 3: ИНДУСТРИАЛЬНАЯ ЗОНА =====
	"tier_3": {
		"normal": [
			{"name": "Снорк-прыгун", "hp": 300.0, "damage": 35.0, "attack_speed": 1.8, "xp": 400},
			{"name": "Кровосос в инвизе", "hp": 400.0, "damage": 50.0, "attack_speed": 2.0, "xp": 500},
			{"name": "Наемник Синдиката", "hp": 450.0, "damage": 45.0, "attack_speed": 1.6, "xp": 450}
		],
		"boss": {"name": "Ядро ИИ (ЦЕНТУРИОН)", "hp": 1800.0, "damage": 75.0, "attack_speed": 3.5, "xp": 10000}
	},
	
	# ===== ТИР 4: СЕРДЦЕ АНОМАЛИИ =====
	"tier_4": {
		"normal": [
			{"name": "Энергетический фантом", "hp": 600.0, "damage": 70.0, "attack_speed": 1.5, "xp": 1800},
			{"name": "Фанатик Монолита", "hp": 900.0, "damage": 90.0, "attack_speed": 2.0, "xp": 2000},
			{"name": "Тяжелый штурмовик", "hp": 1200.0, "damage": 110.0, "attack_speed": 2.5, "xp": 2200}
		],
		"boss": {"name": "ХОЗЯИН ЗОНЫ", "hp": 5000.0, "damage": 150.0, "attack_speed": 2.2, "xp": 50000}
	}
}

# Функция генерации случайного врага для рейда на основе Тира локации
# Выдает словарь с характеристиками монстра
func generate_raid_enemy(tier: int, spawn_boss: bool = false) -> Dictionary:
	var tier_key = "tier_" + str(tier)
	if not ENEMY_DATABASE.has(tier_key):
		# Если тир указан неверно, отдаем слепого пса по умолчанию
		return {"name": "Слепой пес", "hp": 60.0, "damage": 10.0, "attack_speed": 1.5, "xp": 20, "is_boss": false}
		
	var zone_data = ENEMY_DATABASE[tier_key]
	
	if spawn_boss:
		var boss_data = zone_data["boss"].duplicate()
		boss_data["is_boss"] = true
		return boss_data
	else:
		# Выбираем случайного обычного моба из списка
		var normal_list = zone_data["normal"]
		var random_index = randi_range(0, normal_list.size() - 1)
		var enemy_data = normal_list[random_index].duplicate()
		enemy_data["is_boss"] = false
		return enemy_data
# =====================================================================
# 11. БАЗА ДАННЫХ ЛОКАЦИЙ И СИСТЕМА КЛЮЧЕЙ (MAP & LOCKED ROOMS)
# =====================================================================
const REGIONS_DATABASE = {
	1: {"name": "Окраины", "locations": ["Заброшенные дачи", "Разграбленный блокпост"], "key_required": "", "key_dropped": "key_tier_2"},
	2: {"name": "Развалины", "locations": ["Депо 'Красный Партизан'", "Городская больница №4"], "key_required": "key_tier_2", "key_dropped": "key_tier_3"},
	3: {"name": "Промзона", "locations": ["Завод 'Квант'", "Химкомбинат 'Слеза'"], "key_required": "key_tier_3", "key_dropped": "key_tier_4"},
	4: {"name": "Эпицентр", "locations": ["Затопленный Бункер", "Саркофаг"], "key_required": "key_tier_4", "key_dropped": "none"}
}

# Вспомогательная функция: проверяет, есть ли у игрока нужный ключ в рюкзаке
func has_key_in_inventory(key_id: String) -> bool:
	if key_id == "": return true # Ключ не требуется
	for item in current_inventory:
		if item["id"] == key_id and item["count"] > 0:
			return true
	return false

# Функция удаления использованного ключа из инвентаря
func consume_key(key_id: String) -> void:
	if key_id == "": return
	for i in range(current_inventory.size()):
		if current_inventory[i]["id"] == key_id:
			current_inventory[i]["count"] -= 1
			if current_inventory[i]["count"] <= 0:
				current_inventory.remove_at(i)
			break
