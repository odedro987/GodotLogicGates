extends LogicGate


func _ready():
	type = Enums.LOGIC_TYPE.SPLITTER
	create_slots(1, true)
	adjust_slot_locations()

#Updates value and sprite:
func update_value():
	value = in_slots[0].value
	out_slot.value = value
	if value:
		sprite.frame = 1
	else:
		sprite.frame = 0
	if out_slot.connected_nodes.size() > 0:
		for node in out_slot.connected_nodes:
			node.emit_signal("on_value_changed", value)
