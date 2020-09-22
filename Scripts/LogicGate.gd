extends Node2D

class_name LogicGate

var type
var value
var in_slots_num
var sprite
var in_slots
var out_slot
var can_grab
var grabbed_offset

func _ready():
	sprite = get_node("Area2D/Sprite")
	sprite.z_index = 2
	can_grab = false
	value = false
	grabbed_offset = Vector2()
	type = Enums.LOGIC_TYPE.BASE
	in_slots_num = 1
	in_slots = []

func _process(delta):
	#Move node to mouse if grabbed
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset

#Create slots
func create_slots(in_slots_num, multiout=false):
	self.in_slots_num = in_slots_num
	#For all in slots
	for i in range(in_slots_num):
		var temp_in = load("res://Scenes/Slot.tscn").instance()
		temp_in.name = name + "Slot" + str(i)
		in_slots.append(temp_in)
		add_child(in_slots[i])
		temp_in.init_slot(Enums.SLOT_TYPE.IN)
	#Create out slot
	if !multiout:
		out_slot = load("res://Scenes/Slot.tscn").instance()
		add_child(out_slot)
		out_slot.init_slot(Enums.SLOT_TYPE.OUT)
	else:
		out_slot = load("res://Scenes/MultiSlot.tscn").instance()
		add_child(out_slot)
		out_slot.init_slot(Enums.SLOT_TYPE.MULTI_OUT)

#Updates value and sprite:
func update_value():
	pass

#Position slots after creation
func adjust_slot_locations():
	if(sprite.texture != null):
		var size = self.sprite.texture.get_size()
		var h_frames = sprite.hframes
		out_slot.set_position(Vector2(size.x / h_frames, floor(size.y / 2)))
		for i in range(in_slots_num):
			#Position the in slots by their hardcoded positions
			in_slots[i].set_position(Vector2(-((in_slots[i].size.x + 1) / 2), get_in_slot_height_by_num()[i]))
#In slot hardcoded positions
func get_in_slot_height_by_num():
	match(self.in_slots_num):
		1:  return [5]
		2:  return [3, 7]
		3:  return [2, 5, 8]
		4:  return [1 ,4, 6, 9]
		5:  return [1, 3, 5, 7, 9]
		_:  return [-1]

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = global_position - get_global_mouse_position()
