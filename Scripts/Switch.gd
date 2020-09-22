extends "res://Scripts/InputControl.gd"

func _ready():
	create_slot()

func _process(delta):
	if Input.is_action_just_pressed("click") and can_grab:
		change_state()

func change_state():
	if out_slot.connected_node != null:
		is_active = !is_active
		if(is_active): 
			sprite.frame = 1
		else:
			sprite.frame = 0
		out_slot.value = is_active
		out_slot.connected_node.emit_signal("on_value_changed", is_active)
