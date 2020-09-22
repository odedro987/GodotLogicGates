extends "res://Scripts/LogicGate.gd"

func _ready():
	type = Enums.LOGIC_TYPE.AND
	create_slots(3)
	adjust_slot_locations()

#Updates value and sprite:
func update_value():
	var new_value = in_slots[0].value
	for i in range(1, in_slots_num):
		new_value = new_value and in_slots[i].value
		print(in_slots[i].value)
	value = new_value
	out_slot.value = value
	if value:
		sprite.frame = 1
	else:
		sprite.frame = 0
	if out_slot.connected_node != null:
		out_slot.connected_node.emit_signal("on_value_changed", value)
