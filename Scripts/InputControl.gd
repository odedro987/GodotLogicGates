extends Node2D

var is_active
var sprite
var out_slot
var can_grab
var grabbed_offset

func _ready():
	is_active = false
	out_slot = null
	can_grab = false
	grabbed_offset = Vector2()
	sprite = get_node("Area2D/Sprite")

func _process(delta):
	#Move node when grabbed
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset
#Create out slot
func create_slot():
	out_slot = load("res://Scenes/Slot.tscn").instance()
	add_child(out_slot)
	out_slot.init_slot(Enums.SLOT_TYPE.OUT)
	var size = sprite.texture.get_size()
	var h_frames = sprite.hframes
	out_slot.set_position(Vector2(size.x / h_frames, floor(size.y / 2)))

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = global_position - get_global_mouse_position()
