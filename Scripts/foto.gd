extends Interactuable

@export var foto: Texture2D
@onready var mesh_imagen: MeshInstance3D = $Pivot/foto/Foto
@export_multiline var texto_pista: String
@onready var pivot: Node3D = $Pivot

var esta_girado: bool = false
const ANGULO_GIRO: float = 180.0 

func _ready() -> void:
	if $AudioStreamPlayer != null:
		audio = $AudioStreamPlayer
	if usa_focus:
		camara = $Camera3D
	
	texto_f = "Voltear"
	
	if foto:
		var material := mesh_imagen.get_active_material(0).duplicate()
		material.albedo_texture = foto
		mesh_imagen.set_surface_override_material(0, material)
		
	var label_3d = $Pivot.get_node_or_null("Label3D")
	if label_3d:
		label_3d.text = texto_pista
		
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if en_interaccion:
		if event.is_action_pressed("interact"):
			grab()
			get_viewport().set_input_as_handled()

func grab() -> void:
	girar_modelo()

func girar_modelo() -> void:
	esta_girado = !esta_girado
	var angulo_objetivo: float = deg_to_rad(ANGULO_GIRO) if esta_girado else deg_to_rad(0.0)
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(pivot, "rotation:y", angulo_objetivo, 0.4)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = true
		set_process_unhandled_input(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.name == "Player":
		jugador_cerca = false
		set_process_unhandled_input(false)
