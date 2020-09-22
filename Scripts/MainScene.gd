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
		if node.type == Enums.SLOT_TYPE.OUT || Enums.SLOT_TYPE.MULTI_OUT:
			first_slot = node
	#If second slot is null and node is an in type and not already connected
	elif second_slot == null:
		if node.get_parent() == first_slot.get_parent():
			#Reset selection and exit
			reset_selection()
			return
		elif node.type == Enums.SLOT_TYPE.IN:
			#If first or second node are connected, reset selection and exit
			if node.connected_node != null:
				reset_selection()
				return
			if first_slot.type == Enums.SLOT_TYPE.OUT:
				if first_slot.connected_node != null:
					reset_selection()
					return
			second_slot = node
			#Connect slots
			first_slot.connect_to(second_slot)
			#Reset selection and exit
			reset_selection()
			return

func reset_selection():
	first_slot = null
	second_slot = null
