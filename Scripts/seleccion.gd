extends Control

signal diagnostico_confirmado(tipo_sueno: String)

















@onready var vbox: VBoxContainer = $PanelContainer/Panel2/VBoxContainer
@onready var btn_confirmar: Button = $confirmar

const TIPOS_DE_SUENOS = [
	"Sueño Ordinario",
	"Trauma",
	"Bucle",
	"Sueño Sintomático",
	"Sueño de Persecución",
	"Sueño Precognitivo",
	"Sueño de Visitación",
	"Sueño de Intrusión",
	"Sueño Compartido"
]

var diagnostico_seleccionado: String = ""

func _ready() -> void:
	hide() 
	var checkboxes = vbox.get_children()

	for i in checkboxes.size():
		if checkboxes[i] is CheckBox and i < TIPOS_DE_SUENOS.size():
			var cb = checkboxes[i]
			cb.text = TIPOS_DE_SUENOS[i]
			
			cb.toggled.connect(_on_checkbox_toggled.bind(cb, TIPOS_DE_SUENOS[i]))

func _on_checkbox_toggled(marcado: bool, checkbox_actual: CheckBox, tipo: String) -> void:
	if marcado:
		diagnostico_seleccionado = tipo
		
		for cb in vbox.get_children():
			if cb is CheckBox and cb != checkbox_actual:
				
				cb.set_pressed_no_signal(false) 
	else:
		if diagnostico_seleccionado == tipo:
			diagnostico_seleccionado = ""


func _on_confirmar_pressed() -> void:
	if diagnostico_seleccionado != "":
		print("Diagnóstico elegido: ", diagnostico_seleccionado)

		diagnostico_confirmado.emit(diagnostico_seleccionado)
		
		hide()
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		print("Debes seleccionar un sue;o")

func reset() -> void:
	diagnostico_seleccionado = ""
	for cb in vbox.get_children():
		if cb is CheckBox:
			cb.set_pressed_no_signal(false)
