extends Weapon
# Fusil à pompes

export var fire_range = 10 # Distance de tir

func _ready():
	raycast.cast_to = Vector3(0, 0, -fire_range)
