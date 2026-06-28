extends Interactuable

@export var material_textura: Material
@export_multiline var texto_pista: String

@onready var pivot: Node3D = $Pivot
# Apuntamos directamente a tu nodo FotoModelo tal cual lo tienes en la imagen
@onready var foto_modelo: Node3D = $Pivot/FotoModelo 

var esta_girado: bool = false
const ANGULO_GIRO: float = 180.0 

func _ready() -> void:
	if $AudioStreamPlayer != null:
		audio = $AudioStreamPlayer
	if usa_focus:
		camara = $Camera3D
	
	# Como ya tienes FotoModelo en la escena, solo le aplicamos tu material (.tres)
	if material_textura and foto_modelo:
		aplicar_material_a_malla(foto_modelo)
		
	# Buscamos el Label3D para la pista (por si aún no lo has agregado)
	var label_3d = $Pivot.get_node_or_null("Label3D")
	if label_3d:
		label_3d.text = texto_pista
		
	set_process_unhandled_input(false)

func aplicar_material_a_malla(nodo: Node) -> void:
	if nodo is MeshInstance3D:
		nodo.material_override = material_textura
	
	for hijo in nodo.get_children():
		aplicar_material_a_malla(hijo)

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
