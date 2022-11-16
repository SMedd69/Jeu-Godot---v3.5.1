extends KinematicBody

export var speed:int = 10
export var acceleration:int = 5
export var jump_power:int = 30
onready var flyMode:float = 1.6
export var gravity:float = 0.98

export var mouse_sensitivityX:float = 0.08
export var mouse_sensitivityY:float = 0.1
export var joystickSensitivity_X:float = 0.04
export var joystickSensitivity_Y:float = 0.035
onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	_rotMousePlayer(event)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	_movePlayer(delta)
	_jumping()
	_joystickTouch()
	_flyPlayer()

func _rotMousePlayer(event): # Fonction rotation souris Gauche/Droite (axe Y) & Haut/Bas (axe X)
	
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(event.relative.x * -mouse_sensitivityX))
	
		var x_delta = event.relative.y * mouse_sensitivityY
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta

func _joystickTouch(): # Fonction rotation avec joystick Droit
	head.rotate_x(Input.get_action_strength("look_up") * joystickSensitivity_Y)
	head.rotate_x(Input.get_action_strength("look_down") * joystickSensitivity_Y * -1)
	if(head.rotation_degrees.x < -70):
		head.rotation_degrees.x = -70
	if(head.rotation_degrees.x > 70):
		head.rotation_degrees.x = 70
	rotate_y(Input.get_action_strength("look_left") * joystickSensitivity_X)
	rotate_y(Input.get_action_strength("look_right") * joystickSensitivity_X * -1)

func _flyPlayer(): # Mode fly touch : ' F '
	if Input.is_action_pressed("flyMode"): 
		velocity.y += gravity * flyMode

func _movePlayer(delta): # Fonction déplacement joueur
	var head_basis = head.get_global_transform().basis #Tester avec ' interpolate '
	var direction = Vector3()
	
	# Déplacement Avant/Arriere
	if Input.get_action_strength("Move_Forward"):
		direction -= head_basis.z
	elif Input.get_action_strength("Move_Backward"):
		direction += head_basis.z
	
	# Déplacement Latérale
	if Input.get_action_strength("Move_Left"):
		direction -= head_basis.x
	elif Input.get_action_strength("Move_Right"):
		direction += head_basis.x
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	
	velocity = move_and_slide(velocity, Vector3.UP)

func _jumping():
	if Input.is_action_just_pressed("jumping") and is_on_floor():
		velocity.y += jump_power
