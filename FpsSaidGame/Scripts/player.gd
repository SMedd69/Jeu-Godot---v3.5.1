extends KinematicBody

const MIN_CAMERA_ANGLE = -60
const MAX_CAMERA_ANGLE = 70
const GRAVITY = -20

export var jumpForce: float = 11.9
export var MoveSpeed: float = 09.9
export var accel: float = 6.1
export var camera_sensitivity_X: float
export var camera_sensitivity_Y: float
export var joystickSensitivity_Vertical: float = 0.06
export var joystickSensitivity_Horizontal: float = 0.07
var velocity: Vector3 = Vector3.ZERO

onready var head: Spatial = $Head

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	_joystickTouch()
	_movePlayer(delta)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		_handle_camera_rotation(event)

func _handle_camera_rotation(event):
	rotate_y(deg2rad(-event.relative.x * camera_sensitivity_X)) # Rotation du Body sur Y - Rot horizontal
	head.rotate_x(deg2rad(-event.relative.y * camera_sensitivity_Y)) # Rotation de Head sur X - Rot vertical
	head.rotation.x = clamp(head.rotation.x, deg2rad(MIN_CAMERA_ANGLE), deg2rad(MAX_CAMERA_ANGLE)) # Bloque l'angle Rot camera 

func _get_movement_direction():
	var direction = Vector3.DOWN # gravite

	if Input.get_action_strength("forward_move"):
		direction -= transform.basis.z
	if Input.get_action_strength("backward_move"):
		direction += transform.basis.z
	if Input.get_action_strength("left_move"):
		direction -= transform.basis.x
	if Input.get_action_strength("right_move"):
		direction += transform.basis.x

	return direction.normalized()

func _movePlayer(delta):
	var movement = _get_movement_direction()
	velocity.x = lerp(velocity.x, movement.x * MoveSpeed, accel * delta)
	velocity.z = lerp(velocity.z, movement.z * MoveSpeed, accel * delta)
	_isJump()
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity)

func _isJump():
	if Input.is_action_just_pressed("jump_move") and is_on_floor():
		velocity.y = jumpForce
		print_debug(velocity)

func _joystickTouch(): # Fonction Rotation avec joystick Droit
		head.rotate_x(Input.get_action_raw_strength("look_up") * joystickSensitivity_Vertical)
		head.rotate_x(Input.get_action_raw_strength("look_down") * joystickSensitivity_Vertical * -1)
		if(head.rotation_degrees.x < -70):
				head.rotation_degrees.x = -70
		if(head.rotation_degrees.x > 70):
				head.rotation_degrees.x = 70
		rotate_y(Input.get_action_raw_strength("look_left") * joystickSensitivity_Horizontal)
		rotate_y(Input.get_action_raw_strength("look_right") * joystickSensitivity_Horizontal * -1)

