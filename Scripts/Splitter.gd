extends LogicGate


func _ready():
	type = Enums.LOGIC_TYPE.SPLITTER
	create_slots(1)
	adjust_slot_locations()
