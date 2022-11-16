extends Node

class_name Weapon

export var fire_rate = 0.5 # Temps entre chaque tirs
export var clip_size = 5 # Nombres de munition
export var reload_rate = 1 # Temps de chargement d'arme

onready var ammo_label = $"/root/Map/UI/Label"
onready var raycast = $"../Head/Camera/RayCast"
var current_ammo = 0
var can_fire = true
var reloading = false

func _ready():
	current_ammo = clip_size

func _process(delta):
	shooting()

func shooting():
	if reloading:
		ammo_label.set_text("Rechargement de l'arme...")
	else:
		ammo_label.set_text("%d / %d" % [current_ammo, clip_size])

	if Input.is_action_just_pressed("primary_fire") and can_fire:
		if current_ammo > 0 and not reloading:
			fire()
		elif not reloading:
			reload()
	if Input.is_action_just_released("Reloading") and not reloading: #Touche ' A '
		reload()

func fire():
	print("Bim Bim")
	can_fire = false
	current_ammo -= 1
	check_collision()
	yield(get_tree().create_timer(fire_rate), "timeout") # Temps pour l'action
	can_fire = true

func reload():
	print(" Rechargement de l'arme en cours...")
	reloading = true
	yield(get_tree().create_timer(reload_rate), "timeout")
	current_ammo = clip_size
	reloading = false
	print(" Rechargement de l'arme terminé ! ")

func check_collision():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("Enemies"):
			collider.queue_free()
			print("Tu as touché : " + collider.name)
