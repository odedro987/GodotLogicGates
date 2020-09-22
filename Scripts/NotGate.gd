extends "res://Scripts/LogicGate.gd"

func _ready():
	type = Enums.LOGIC_TYPE.NOT
	create_slots(1)
	adjust_slot_locations()

#Updates value and sprite:
func update_value():
	var new_value = !in_slots[0].value
	value = new_value
	out_slot.value = value
	if value:
		sprite.frame = 1
	else:
		sprite.frame = 0
	if out_slot.connected_node != null:
		out_slot.connected_node.emit_signal("on_value_changed", value)
