extends Node2D

var first_slot
var second_slot

func _ready():
	#Connect all slots from global array
	for node in Globals.slots:
		node.connect("on_clicked", self, "connect_slots")

#Connects two slots with a line
func connect_slots(node):
	#If first slot is null and clicked slot is an out type
	if first_slot == null:
		if node.type == Enums.SLOT_TYPE.OUT:
			first_slot = node
	#If second slot is null and node is an in type and not already connected
	elif second_slot == null:
		if node.get_parent() == first_slot.get_parent():
			#Reset selection and exit
			reset_selection()
			return
		elif node.type == Enums.SLOT_TYPE.IN:
			#If first or second node are connected, reset selection and exit
			if first_slot.connected_node != null || node.connected_node != null:
				reset_selection()
				return
			second_slot = node
			#Connect slots
			first_slot.connected_node = second_slot
			second_slot.connected_node = first_slot
			second_slot.line = first_slot.line
			#Calculate positions
			var pos = first_slot.get_node("ConnectionLine").global_position
			var new_pos = Vector2(second_slot.global_position.x - pos.x, second_slot.global_position.y - pos.y + 0.5)
			#Update out slot's line
			first_slot.get_node("ConnectionLine").points[1] = new_pos
			#Signal connection
			first_slot.emit_signal("on_connection_created", first_slot.value)
			#Reset slots
			first_slot = null
			second_slot = null

func reset_selection():
	first_slot = null
	second_slot = null
