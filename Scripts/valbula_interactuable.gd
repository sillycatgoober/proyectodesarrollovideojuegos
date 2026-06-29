extends Interactuable

@export var dream_manager: Node3D
@export var id:int
@onready var rueda = $valvula/Valvula/Cylinder005
var girada: bool = false

func _ready() -> void:
	if $AudioStreamPlayer!=null:
		audio = $AudioStreamPlayer
	audio.bus = "SFX"
	texto_e = "Girar"
	
func interact() -> void:
	girada = true
	create_tween().tween_property(rueda,"rotation_degrees:y",
		rueda.rotation_degrees.y - 90.0,0.5)
	audio.play()
	if dream_manager and dream_manager.has_method("registrar_valvula"):
		dream_manager.registrar_valvula(id)
	set_process_unhandled_input(false)
