extends Control
#paneles
@onready var panel_opciones = $Opciones
@onready var botones = $Bots
@onready var slots = $Slots

@onready var slider_master = $Opciones/VBoxContainer/SliderMaster
@onready var slider_fx = $Opciones/VBoxContainer/SliderFX
@onready var slider_musica = $Opciones/VBoxContainer/SliderMusica
@onready var audio_player = $AudioStreamPlayer
@onready var cont_bot = $Bots/ContinueButton
@onready var cont_label = $Bots/LabelCont
@onready var lslot1: Label = $Slots/LSlot1
@onready var lslot2: Label = $Slots/LSlot2
@onready var lslot3: Label = $Slots/LSlot3
@onready var lslot4: Label = $Slots/LSlot4
@onready var slot1 = $Slots/Slot1
@onready var slot2 = $Slots/Slot2
@onready var slot3 = $Slots/Slot3
@onready var slot4 = $Slots/Slot4
@onready var del1: TextureButton = $Slots/r1
@onready var del2: TextureButton = $Slots/r2
@onready var del3: TextureButton = $Slots/r3
@onready var del4: TextureButton = $Slots/r4
var modo_slots:=""

func _ready() -> void:
	slider_master.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	slider_fx.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	slider_musica.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	cont_bot.visible = GameManager.hay_partida_guardada()
	cont_label.visible = GameManager.hay_partida_guardada()
	botones.visible = true
	panel_opciones.visible = false
	slots.visible = false
	UI.visible = false

func _on_options_pressed() -> void:
	panel_opciones.visible = true
	botones.visible = false

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_slider_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	GameManager.guardar_config()

func _on_slider_fx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	GameManager.guardar_config()

func _on_slider_musica_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	GameManager.guardar_config()

func _on_close_button_pressed() -> void:
	panel_opciones.visible = false
	botones.visible = true

#---- Slots y cargar partida ----#
func _on_new_game_button_pressed() -> void:
	botones.visible = false
	modo_slots = "nuevo"
	mostrar_slots()

func _on_continue_button_pressed() -> void:
	GameManager.cargar()
	botones.visible = false
	modo_slots = "cargar"
	mostrar_slots()

func _on_back_button_pressed() -> void:
	botones.visible = true
	slots.visible = false

func mostrar_slots() -> void:
	slots.visible = true
	_actualizar_slot(slot1, lslot1, 1)
	_actualizar_slot(slot2, lslot2, 2)
	_actualizar_slot(slot3, lslot3, 3)
	_actualizar_slot(slot4, lslot4, 4)

func _actualizar_slot(boton: TextureButton, label: Label, slot: int) -> void:
	var del_boton = get_node("Slots/r" + str(slot))
	if GameManager.hay_partida_guardada(slot):
		var file = FileAccess.open("user://savegame_" + str(slot) + ".dat", FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		label.text = "Slot " + str(slot) + "\nDía " + str(data.dream_actual)
		boton.disabled = (modo_slots == "nuevo")
		del_boton.visible = true
	else:
		if modo_slots == "cargar":
			label.text = "Slot " + str(slot) + "\nVacío"
			boton.disabled = true
		else:
			label.text = "Slot " + str(slot) + "\nNuevo"
			boton.disabled = false
		del_boton.visible = false

func _on_slot_pressed(slot: int) -> void:
	UI.visible = true
	if modo_slots == "nuevo":
		GameManager.reset_dreams()
		GameManager.fase_actual = GameManager.Fase.INTRO 
		GameManager.slot_actual = slot
		GameManager.guardar(slot)
	else:
		if not GameManager.hay_partida_guardada(slot):
			return
		GameManager.cargar(slot)
		GameManager.slot_actual = slot
	slots.visible = false
	set_process_input(false)
	get_tree().change_scene_to_file("res://Scenes/office.tscn")

func _on_cerrar_slots_pressed() -> void:
	slots.visible = false
	for slot in range(1, 4):
		slots.get_node("Slot" + str(slot)).disabled = false

func _on_slot_1_pressed() -> void:
	_on_slot_pressed(1)
func _on_slot_2_pressed() -> void:
	_on_slot_pressed(2)
func _on_slot_3_pressed() -> void:
	_on_slot_pressed(3)
func _on_slot_4_pressed() -> void:
	_on_slot_pressed(4)

func _on_r_1_pressed() -> void:
	GameManager.eliminar_partida(1)
	_actualizar_slot(slot1, lslot1, 1)
func _on_r_2_pressed() -> void:
	GameManager.eliminar_partida(2)
	_actualizar_slot(slot2, lslot2, 2)
func _on_r_3_pressed() -> void:
	GameManager.eliminar_partida(3)
	_actualizar_slot(slot3, lslot3, 3)
func _on_r_4_pressed() -> void:
	GameManager.eliminar_partida(4)
	_actualizar_slot(slot4, lslot4, 4)
