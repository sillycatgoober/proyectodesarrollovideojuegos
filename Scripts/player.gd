extends CharacterBody3D

const SPEED = 5.0
const RUN_SPEED = 18.0

const STEP_HEIGHT = 0.75
var _snapped_to_stairs_last_frame:=false
var _last_frame_was_on_floor = -INF

@export var mouse_sensibilidad: float = 0.003
@onready var camara: Camera3D = $Camera3D
@onready var raycast:RayCast3D = $Camera3D/RayCast3D
@onready var ui = UI
@onready var stairs_up:RayCast3D = $StairsUp
@onready var stairs_down:RayCast3D = $StairsDown

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

func get_current_interactable():
	for obj in get_tree().get_nodes_in_group("interactuable"):
		if obj.jugador_cerca and obj.volteando(self):
			return obj
	return null

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

func is_surface_too_steep(normal:Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _run_body_test_motion(from: Transform3D,motion:Vector3,result=null) -> bool:
	if not result:
		result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

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
