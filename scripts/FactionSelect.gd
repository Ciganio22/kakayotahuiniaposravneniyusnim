extends Control

@onready var btn_medic: Button = $Layout/BtnMedic
@onready var btn_military: Button = $Layout/BtnMilitary
@onready var btn_marauder: Button = $Layout/BtnMarauder

func _ready() -> void:
	# Подключаем кнопки кодом
	btn_medic.pressed.connect(func(): _select_class("medic"))
	btn_military.pressed.connect(func(): _select_class("military"))
	btn_marauder.pressed.connect(func(): _select_class("marauder"))

func _select_class(chosen_class: String) -> void:
	GlobalData.player_class = chosen_class
	print("Игрок выбрал класс: ", chosen_class)
	# После выбора фракции запускаем Главное Меню Базы
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
