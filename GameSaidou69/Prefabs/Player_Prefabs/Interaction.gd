extends RayCast

var current_collider

onready var interaction_label = get_node("/root/Map/UI/InteractionLabel")

func _ready():
	set_interaction_text("")

func _process(delta):
	var collider = get_collider()

	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			set_interaction_text(collider.get_interaction_text())
			current_collider = collider

		if Input.is_action_just_pressed("Interact"):
			collider.interact()
			set_interaction_text(collider.get_interaction_text())
	elif current_collider:
		current_collider = null
		set_interaction_text("")

func set_interaction_text(text): # Condition d'interaction
	if !text:
		interaction_label.set_text("")
		interaction_label.set_visible(false)
	else:
		var interact_key = OS.get_scancode_string(InputMap.get_action_list("Interact")[0].scancode)
		interaction_label.set_text("Appuie sur %s à %s" % [interact_key, text])
		interaction_label.set_visible(true)
