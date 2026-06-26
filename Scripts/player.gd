extends CharacterBody3D

const SPEED = 5.0
const RUN_SPEED = 18.0
const STEP_HEIGHT = 0.9

@export var mouse_sensibilidad: float = 0.003
@onready var camara: Camera3D = $Camera3D
@onready var raycast:RayCast3D = $Camera3D/RayCast3D
@onready var ui = UI

@onready var journal = $InterfazUI/Journal 

var tiene_carta: bool = false
var puede_moverse: bool = true
var target_interactuable = null

func _ready() -> void:
	add_to_group("Player")
	puede_moverse = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if journal:
		journal.hide()

func _unhandled_input(event: InputEvent) -> void:
	if not puede_moverse:
		return
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensibilidad)
		camara.rotate_x(-event.relative.y * mouse_sensibilidad)
		camara.rotation.x = clamp(camara.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _process(delta):
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == null:
			return
		var obj = collider.get_parent()
		
		if obj.is_in_group("interactuable") and obj.puede_interactuar:
			ui.mostrar_acciones(obj)
			if Input.is_action_just_pressed("interact") and not obj.en_interaccion:
				obj.interact()
			if obj.is_in_group("recogible"):
				if Input.is_action_just_pressed("grab"):
					obj.grab()
			if Input.is_action_just_pressed("back") and obj.en_interaccion:
				obj.interact()
		else:
			ui.esconder_acciones()
	else:
		ui.esconder_acciones()

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
	
	if is_on_floor() and direction:
		_step_up(direction)

func _step_up(direction: Vector3) -> void:
	var space_state = get_world_3d().direct_space_state
	
	var from = global_position + Vector3(0, 0.1, 0)
	var to = from + direction * 0.3
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [self]
	var hit = space_state.intersect_ray(query)
	
	if not hit:
		return
	
	var from_top = global_position + Vector3(0, STEP_HEIGHT, 0) + direction * 0.3
	var to_top = from_top + Vector3(0, -STEP_HEIGHT, 0)
	var query_top = PhysicsRayQueryParameters3D.create(from_top, to_top)
	query_top.exclude = [self]
	var hit_top = space_state.intersect_ray(query_top)
	
	if hit_top:
		global_position.y = hit_top.position.y + 0.05

func set_camara_activa(active: bool):
	$Camera3D.current = active

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("folder"):
		if journal.visible:
			journal.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			puede_moverse = true
		else:
			journal.show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			puede_moverse = false
			ui.esconder_acciones()
		
		get_viewport().set_input_as_handled()
