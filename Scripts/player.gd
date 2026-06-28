extends CharacterBody3D

const SPEED = 4.5
const RUN_SPEED = 18.0

#movimiento ligero
const BOB_FREQ := 1.7
const BOB_AMP := 0.1
var bob_time := 0.0
var camara_pos_original := Vector3.ZERO

#escaleras
const STEP_HEIGHT = 0.4
var _snapped_to_stairs_last_frame:=false
var _last_frame_was_on_floor = -INF

@export var mouse_sensibilidad: float = 0.003
@onready var camara: Camera3D = $CameraPivot/Camera3D
@onready var camara_pivot = $CameraPivot
@onready var raycast:RayCast3D = $CameraPivot/Camera3D/RayCast3D
@onready var ui = UI
@onready var stairs_up:RayCast3D = $StairsUp
@onready var stairs_down:RayCast3D = $StairsDown

@onready var ticket = $CameraPivot/Camera3D/TicketHolder

#pasos sonido
@export var sonidos_pasos : Array[AudioStream]
@onready var pasos = $AudioPlayer
var tiempo_paso := 0.0
const INTERVALO_PASO := 0.55

var tiene_carta: bool = false
var puede_moverse: bool = true
var target_interactuable = null
var tiene_encendedor: bool = false
var ticket_en_mano_nodo = null
var rotacion_original_ticket = {}

func _ready() -> void:
	add_to_group("Player")
	puede_moverse = true
	camara_pos_original = camara_pivot.position
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

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

func _physics_process(delta: float) -> void:
	if is_on_floor():
		_last_frame_was_on_floor = Engine.get_physics_frames()
	
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
		
	if not _snap_up_to_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()
	
	#movimiento ligero
	var velocidad_horizontal = Vector2(velocity.x, velocity.z).length()
	if is_on_floor() and velocidad_horizontal > 0.1:
		tiempo_paso += delta
		if tiempo_paso >= INTERVALO_PASO:
			tiempo_paso = 0.0
			pasos.stream = sonidos_pasos.pick_random()
			pasos.play()
	else:
		tiempo_paso = 0.0
	var progreso = tiempo_paso / INTERVALO_PASO
	var offset = Vector3.ZERO
	if is_on_floor() and velocidad_horizontal > 0.1:
		offset.y = sin(progreso * BOB_FREQ * PI) * BOB_AMP
		offset.x = cos(progreso * BOB_FREQ * PI) * (BOB_AMP * 0.4)

	camara_pivot.position = camara_pivot.position.lerp(camara_pos_original + offset,delta * 8)
	var objetivo = -input_dir.x * deg_to_rad(2)
	camara.rotation.z = lerp(camara.rotation.z,objetivo,delta * 8)
	camara.fov = lerp(camara.fov,75 + velocidad_horizontal * 0.2,delta * 5)

#----ESCALERAS----#
func _snap_up_to_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame:
		return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var down_check_result = PhysicsTestMotionResult3D.new()
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, STEP_HEIGHT, 0))
	var hit = _run_body_test_motion(step_pos_with_clearance, Vector3(0, -STEP_HEIGHT * 2, 0),down_check_result)

	if (_run_body_test_motion(step_pos_with_clearance,Vector3(0,-STEP_HEIGHT*2,0),down_check_result)) and (down_check_result.get_collider().is_class("StaticBody3D")):
		var step_height = ((step_pos_with_clearance.origin+down_check_result.get_travel()) - self.global_position).y
		if step_height > STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_collision_point()-self.global_position).y > STEP_HEIGHT:
			return false
		stairs_up.global_position = down_check_result.get_collision_point() + Vector3(0,STEP_HEIGHT,0) + expected_move_motion.normalized()*0.1
		stairs_up.force_raycast_update()
		if stairs_up.is_colliding() and not is_surface_too_steep(stairs_up.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func _snap_down_to_stairs_check():
	var did_snap:=false
	var floor_below : bool = stairs_down.is_colliding() and not is_surface_too_steep(stairs_down.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor ==1
	if not is_on_floor() and velocity.y <=0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame):
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform,Vector3(0,-STEP_HEIGHT,0),body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func is_surface_too_steep(normal:Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _run_body_test_motion(from: Transform3D,motion:Vector3,result=null) -> bool:
	if not result:
		result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

#----FIN ESCALERAS----#

func set_camara_activa(active: bool):
	camara.current = active

func mostrar_ticket_en_mano(ticket_nodo: Node3D) -> void:
	ticket_en_mano_nodo = ticket_nodo
	rotacion_original_ticket[ticket_nodo] = ticket_nodo.global_rotation
	ticket_nodo.get_parent().remove_child(ticket_nodo)
	ticket.add_child(ticket_nodo)
	ticket_nodo.position = Vector3.ZERO
	ticket_nodo.rotation = Vector3.ZERO
	ticket_nodo.visible = true

func soltar_ticket_en_mano() -> void:
	if ticket_en_mano_nodo == null:
		return
	ticket.remove_child(ticket_en_mano_nodo)
	get_tree().current_scene.add_child(ticket_en_mano_nodo)
	ticket_en_mano_nodo.global_rotation = Vector3(-1.570796, 0.0, 0.0)
	ticket_en_mano_nodo = null
	
