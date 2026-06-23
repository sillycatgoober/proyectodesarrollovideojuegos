extends CharacterBody3D

const SPEED = 5.0
const RUN_SPEED = 18.0

@export var mouse_sensibilidad: float = 0.003
@onready var camara: Camera3D = $Camera3D
@onready var ui = UI

var puede_moverse:bool = true
var target_interactuable = null

func _ready() -> void:
	add_to_group("Player")
	puede_moverse = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if not puede_moverse:
		return
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensibilidad)
		camara.rotate_x(-event.relative.y * mouse_sensibilidad)
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(delta):
	var obj = get_current_interactable()
	if obj:
		ui.mostrar_interact()
		if Input.is_action_just_pressed("interact"):
			obj.interact()
	else:
		ui.esconder_interact()

func get_current_interactable():
	for obj in get_tree().get_nodes_in_group("interactuable"):
		if obj.jugador_cerca and obj.volteando(self):
			return obj
	return null

func _physics_process(delta: float) -> void:
	if not puede_moverse:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func set_camara_activa(active: bool):
	$Camera3D.current = active
