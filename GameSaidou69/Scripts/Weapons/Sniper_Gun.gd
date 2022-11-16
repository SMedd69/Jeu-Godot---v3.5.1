extends Weapon
# Fusil de précision
export var fire_range = 1500 # Distance de tir

func _ready():
	raycast.cast_to = Vector3(0, 0, -fire_range)
