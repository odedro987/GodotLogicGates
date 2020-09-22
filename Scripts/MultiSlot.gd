extends Node2D

var size
var lines
var type
var sprite
var connected_nodes
var value
var highlight
var can_click

const HIGHLIGHT_BUFFER = 1
const LINE_COLORS = [Color.white, Color.greenyellow]

signal on_clicked(node)
signal on_value_changed(new_value)
signal on_connection_created(new_value)

func _ready():
	value = false
	connected_nodes = [null]
	highlight = null
	can_click = false
	type = Enums.SLOT_TYPE.IN
	sprite = get_node("Area2D/Sprite")
	highlight = get_node("Highlight")
	size = sprite.texture.get_size()
	size.x /= sprite.hframes
	#Add Slot to global array
	Globals.slots.append(self)
	connect("on_value_changed", self, "signal_parent")
	connect("on_connection_created", self, "signal_parent")

func _process(delta):
	#Makes Hightlight visible on mouse hover 
	highlight.visible = is_mouse_over()
	#Updates the position of ConnectionLine
	update_connection_line_pos()
	#Click Input check
	if Input.is_action_just_pressed("click"):
		#Change frame if clicked
		if can_click:
			emit_signal("on_clicked", self)
			sprite.frame = 1
		else:
			sprite.frame = 0
	else:
		can_click = false

#Init if dynamically created
func init_slot(type):
	self.type = type
	#If an out slot create a Line2D node
	#if type == Enums.SLOT_TYPE.OUT:
	#	line = Line2D.new()
	#	line.name = "ConnectionLine"
	#	line.width = 1.0
	#	line.default_color = LINE_COLORS[0]
	#	add_child(line)
	#	line.add_point(Vector2(5, 0.5))
	#	line.add_point(Vector2(5, 0.5))
	#Init Highlight
	highlight.set_position(Vector2(size.x, 0.5))
	highlight.visible = false

#Signals parent node when value changed
func signal_parent(new_value):
	value = new_value
	for node in connected_nodes:
		node.value = new_value
	for line in lines:
		line.default_color = LINE_COLORS[1] if new_value else LINE_COLORS[0]
	var parent = null
	#Signal all parents
	for node in connected_nodes:
		parent = node.get_parent()
		if parent is LogicGate:
			parent.update_value()
#Checks if mous is over sprite
func is_mouse_over():
	var mouse_pos = get_global_mouse_position()
	return (mouse_pos.x >= global_position.x && mouse_pos.x <= global_position.x + size.x \
			&& mouse_pos.y >= global_position.y - HIGHLIGHT_BUFFER && mouse_pos.y <= global_position.y + HIGHLIGHT_BUFFER)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		can_click = event.pressed

func reset():
	for node in connected_nodes:
		node.emit_signal("on_value_changed", false)
		node.connected_node = null
		node = null

#Updates the position of ConnectionLine
func update_connection_line_pos():
	#Checks if slot is connected to another
	if lines.size > 0:
		var i = 0
		for line in lines:
			line.points[1] = Vector2(connected_nodes[i].global_position.x - global_position.x, \
									 connected_nodes[i].global_position.y - global_position.y + 0.5)
