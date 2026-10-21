# =====================================================================
# RaidZone.gd — Боевой Авто-Движок "Лицо в лицо" с динамическими мобами
# =====================================================================
extends Control

@onready var enemy_hp_bar: ProgressBar = $BattleLayout/EnemyPanel/VBoxContainer/EnemyHPBar
@onready var weapon_info_label: Label = $BattleLayout/PlayerPanel/VBoxContainer/WeaponInfoLabel
@onready var attack_progress_bar: ProgressBar = $BattleLayout/PlayerPanel/VBoxContainer/AttackProgressBar
@onready var player_hp_bar: ProgressBar = $BattleLayout/PlayerPanel/VBoxContainer/PlayerHPBar
@onready var player_armor_bar: ProgressBar = $BattleLayout/PlayerPanel/VBoxContainer/PlayerArmorBar

# ХАРАКТЕРИСТИКИ ИГРОКА (Авто-подгрузка из GlobalData)
var weapon_name: String = ""
var base_fire_rate: float = 2.0   
var player_damage: float = 10.0
var max_magazine: int = 30
var current_magazine: int = 30
var base_reload_time: float = 2.5 
var durability_drain: float = 0.3 

var player_max_hp: float = 100.0
var player_current_hp: float = 100.0
var player_max_armor: float = 0.0
var player_current_armor: float = 0.0

# ДИНАМИЧЕСКИЕ ХАРАКТЕРИСТИКИ ВРАГА (Загружаются из базы бестиария)
var enemy_name: String = ""
var enemy_max_hp: float = 100.0
var enemy_current_hp: float = 100.0
var enemy_attack_speed: float = 2.0 
var enemy_damage: float = 10.0       
var enemy_reward_xp: int = 0          # ВОТ ЭТА ПЕРЕМЕННАЯ, КОТОРОЙ НЕ ХВАТАЛО!
var is_boss_fight: bool = false

# ТЕКУЩИЕ НАСТРОЙКИ ЗОНЫ (Берутся из активной Карты в GlobalData)
var current_zone_tier: int = 1

# ВНУТРЕННИЕ СИСТЕМНЫЕ ТАЙМЕРЫ
var attack_timer: float = 0.0
var reload_timer: float = 0.0
var enemy_attack_timer: float = 0.0 
var is_reloading: bool = false
var is_battle_active: bool = true
var is_weapon_jammed: bool = false

# СЕТЕВЫЕ ПЕРЕМЕННЫЕ ЛОББИ И АГРО
var current_target_index: int = 0

func _ready() -> void:
	await get_tree().process_frame
	
	# 1. Загрузка статов Зоны и генерация СЛУЧАЙНОГО врага по Тиру локации
	current_zone_tier = GlobalData.active_raid_map["zone_tier"]
	
	# С шансом 20% в конце рейда может появиться Главный Босс, иначе — обычный моб
	var spawn_boss = randf() <= 0.20
	var enemy_stats = GlobalData.generate_raid_enemy(current_zone_tier, spawn_boss)
	
	enemy_name = enemy_stats["name"]
	enemy_max_hp = enemy_stats["hp"]
	enemy_attack_speed = enemy_stats["attack_speed"]
	enemy_damage = enemy_stats["damage"]
	enemy_reward_xp = enemy_stats["xp"]
	is_boss_fight = enemy_stats["is_boss"]
	
	# 2. Загрузка статов оружия и брони игрока
	var w_stats = GlobalData.get_active_weapon_stats()
	weapon_name = w_stats["name"]
	base_fire_rate = w_stats["fire_rate"]
	player_damage = w_stats["damage"]
	max_magazine = w_stats["max_magazine"]
	current_magazine = max_magazine
	durability_drain = w_stats["durability_drain"]
	
	if GlobalData.current_equipment["weapon_durability"] <= 0.0: 
		is_weapon_jammed = true
		
	var a_stats = GlobalData.get_equipped_armor_stats()
	player_max_armor = a_stats["max_armor"]
	player_current_armor = GlobalData.current_equipment["armor_durability"]
	
	player_max_hp = GlobalData.player_max_hp
	player_current_hp = GlobalData.player_hp

	# 3. МАТЕМАТИКА АДАПТИВНОЙ СЛОЖНОСТИ (ГРУППА ИЗ 3 ИГРОКОВ + КАРТА)
	enemy_max_hp = enemy_max_hp * 3.5 * GlobalData.active_raid_map["enemy_hp_multiplier"]
	enemy_current_hp = enemy_max_hp
	enemy_attack_speed = (enemy_attack_speed / 1.4) / GlobalData.active_raid_map["enemy_speed_multiplier"]
	
	# Инициализация шкал под мобильные размеры
	enemy_hp_bar.max_value = enemy_max_hp
	enemy_hp_bar.value = enemy_current_hp
	player_hp_bar.max_value = player_max_hp
	player_hp_bar.value = player_current_hp
	player_armor_bar.max_value = player_max_armor if player_max_armor > 0 else 100.0
	player_armor_bar.value = player_current_armor
	
	print("[OUTCAST WAY] Вы встретили противника лицо в лицо: ", enemy_name)
	
	_update_weapon_ui()

func _process(delta: float) -> void:
	if not is_battle_active: return
	
	if not is_weapon_jammed:
		if is_reloading: _handle_reload_cycle(delta)
		else: _handle_attack_cycle(delta)
	else:
		attack_progress_bar.value = 0
		weapon_info_label.text = weapon_name + " ЗАКЛИНИЛО! (0% Прочности)"
		
	_handle_enemy_attack_cycle(delta)
	_simulate_network_teammates_damage(delta)

func _handle_attack_cycle(delta: float) -> void:
	attack_timer += delta
	var progress_percent = (attack_timer / base_fire_rate) * 100.0
	attack_progress_bar.value = progress_percent
	
	if attack_timer >= base_fire_rate:
		attack_timer = 0.0
		_execute_player_shot()

func _execute_player_shot() -> void:
	if current_magazine >= 3:
		current_magazine -= 3
		GlobalData.current_equipment["weapon_durability"] -= durability_drain
		if GlobalData.current_equipment["weapon_durability"] <= 0.0:
			GlobalData.current_equipment["weapon_durability"] = 0.0
			is_weapon_jammed = true
		
		enemy_current_hp -= player_damage
		enemy_hp_bar.value = enemy_current_hp
		current_target_index = 0 
		_update_weapon_ui()
		
		if enemy_current_hp <= 0: _end_battle(true)
	else:
		is_reloading = true
		reload_timer = 0.0
		attack_progress_bar.modulate = Color(1, 0.3, 0.3)

func _handle_reload_cycle(delta: float) -> void:
	reload_timer += delta
	var reload_percent = (reload_timer / base_reload_time) * 100.0
	attack_progress_bar.value = reload_percent
	weapon_info_label.text = "ПЕРЕЗАРЯДКА: " + str(int(reload_percent)) + "%"
	
	if reload_timer >= base_reload_time:
		current_magazine = max_magazine
		is_reloading = false
		attack_timer = 0.0
		attack_progress_bar.modulate = Color(1, 1, 1)
		_update_weapon_ui()

func _simulate_network_teammates_damage(delta: float) -> void:
	enemy_current_hp -= 30.0 * delta 
	if enemy_current_hp < 0: enemy_current_hp = 0
	enemy_hp_bar.value = enemy_current_hp
	if enemy_current_hp <= 0 and is_battle_active: _end_battle(true)

func _handle_enemy_attack_cycle(delta: float) -> void:
	enemy_attack_timer += delta
	if enemy_attack_timer >= enemy_attack_speed:
		enemy_attack_timer = 0.0
		
		current_target_index = randi_range(0, GlobalData.current_lobby.size() - 1)
		var target_player = GlobalData.current_lobby[current_target_index]
		
		if current_target_index == 0:
			_execute_enemy_attack() 
		else:
			print("[СЕТЬ] ", enemy_name, " проигнорировал вас и ударил напарника: ", target_player["name"])

func _execute_enemy_attack() -> void:
	var final_damage = enemy_damage
	
	if player_max_armor > 0 and GlobalData.current_equipment["armor_durability"] > 0:
		var armor_damage = enemy_damage * 0.6
		GlobalData.current_equipment["armor_durability"] -= armor_damage
		if GlobalData.current_equipment["armor_durability"] < 0: GlobalData.current_equipment["armor_durability"] = 0
		final_damage = enemy_damage * 0.4
		player_armor_bar.value = GlobalData.current_equipment["armor_durability"]
	
	player_current_hp -= final_damage
	if player_current_hp < 0: player_current_hp = 0
	player_hp_bar.value = player_current_hp
	
	print("🚨 ", enemy_name, " НАНОСИТ УДАР! Урон по вам: ", final_damage)
	if player_current_hp <= 0: _end_battle(false)

func _update_weapon_ui() -> void:
	if not is_weapon_jammed:
		weapon_info_label.text = weapon_name + " (" + str(int(GlobalData.current_equipment["weapon_durability"])) + "%) | ЦЕЛЬ: " + enemy_name + " | Патроны: " + str(current_magazine) + "/" + str(max_magazine)

# ПОЛНЫЙ РАСЧЕТ ОПЫТА, ШТРАФОВ И КЛЮЧЕЙ ПРИ ОКОНЧАНИИ БОЯ
func _end_battle(player_won: bool) -> void:
	is_battle_active = false
	attack_progress_bar.value = 0
	
	if player_won:
		weapon_info_label.text = "ЛИКВИДАЦИЯ: " + enemy_name + " уничтожен!"
		var total_xp = int(enemy_reward_xp * GlobalData.get_clan_xp_bonus())
		GlobalData.add_xp(total_xp, current_zone_tier)
		
		# ВЫДАЧА КЛЮЧЕЙ С БОССОВ ТИРА ДЛЯ ЗАКРЫТЫХ КОМНАТ
		if is_boss_fight:
			var region_data = GlobalData.REGIONS_DATABASE[current_zone_tier]
			var dropped_key = region_data["key_dropped"]
			
			if dropped_key != "none" and dropped_key != "":
				GlobalData.current_inventory.append({"id": dropped_key, "count": 1})
				weapon_info_label.text = "БОСС ПОВЕРЖЕН! Выбит " + dropped_key.to_upper() + " от закрытых комнат!"
				print("[Рейд] Из трупа босса извлечен ключ доступа: ", dropped_key)
		
		# Начисление денег
		if is_boss_fight and current_zone_tier == 4:
			GlobalData.currency_dp += 5
		else:
			var marks_reward = 100 * current_zone_tier
			GlobalData.currency_marks += marks_reward
	else:
		weapon_info_label.text = "ВЫ ПОГИБЛИ. Рюкзак очищен. Снаряжение уничтожено."
		GlobalData.current_inventory.clear()
		GlobalData.current_equipment["weapon_durability"] = 0.0
		if GlobalData.current_equipment["armor"] != "": GlobalData.current_equipment["armor_durability"] = 0.0
		var penalty_xp = int(GlobalData.get_required_xp_for_level(GlobalData.player_level) * 0.15)
		GlobalData.player_xp -= penalty_xp
		if GlobalData.player_xp < 0: GlobalData.player_xp = 0
		print("[СМЕРТЬ] Штрафы применены.")

func _on_button_escape_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
