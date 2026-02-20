extends Area2D
class_name UnitArea

var unit

func _init(unit):
	self.unit = unit
# used for handling clickable units
func _input_event(vp, event, sidx):
	if (event is InputEventMouseButton && event.pressed):
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				### select the unit
				self.unit.select()
			MOUSE_BUTTON_RIGHT:
				### UNIT Context Menu
				get_node(Commons.ContextMenuHandler).spawn(UnitContextMenu.new(self.unit), get_global_mouse_position())


func _ready():
	self.input_pickable = true
