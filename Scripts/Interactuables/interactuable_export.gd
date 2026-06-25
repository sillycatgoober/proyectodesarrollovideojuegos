extends Interactuable
class_name InteractuableExport

@export var modelo_export : PackedScene
@onready var modelo = $Modelo

func _ready() -> void:
	if usa_focus:
		camara = $Camera3D
	if modelo_export:
			var instancia = modelo_export.instantiate()
			modelo.add_child(instancia)
