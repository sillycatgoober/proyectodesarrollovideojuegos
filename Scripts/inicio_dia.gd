extends CanvasLayer

@onready var label_dia: Label = $Ratio/LabelDia
@onready var label_resumen: Label = $Ratio/LabelResumen

func _ready() -> void:
	label_dia.text = "Día " + str(GameManager.dream_actual)
	
	if GameManager.dream_actual == 1:
		label_resumen.text = ""  # primer día, sin resumen
	else:
		var dia_anterior = GameManager.dream_actual - 1
		var correcto = GameManager.dreams[dia_anterior].diagnostico_correcto
		label_resumen.text = "Ayer: caso " + str(dia_anterior)
		if correcto:
			label_resumen.text += "\nDiagnóstico correcto."
		else:
			label_resumen.text += "\nDiagnóstico incorrecto."
	
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/office.tscn")
