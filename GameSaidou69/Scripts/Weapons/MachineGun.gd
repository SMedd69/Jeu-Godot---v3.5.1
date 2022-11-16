extends Weapon
# Fusil mitrailleurs

export var fire_range = 1000 # Distance de tir

func _ready():
	raycast.cast_to = Vector3(0, 0, -fire_range)
