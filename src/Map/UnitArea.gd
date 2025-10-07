extends Area2D
class_name UnitArea

var unit

func _init(unit):
	self.unit = unit
# used for handling clickable units
func _input_event(vp, event, sidx):
	print("unit event!")
	if (event is InputEventMouseButton && event.pressed):
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				# select the unit
				if not get_node("/root/Player"):
					return
				if Input.is_key_pressed(KEY_SHIFT): # shift+click *adds* the unit to already selected ones
					get_node("/root/Player").selected_units.append(unit)
				else:
					get_node("/root/Player").selected_units = [unit]
				print(get_node("/root/Player").selected_units)
			MOUSE_BUTTON_RIGHT:
				# TODO: display info about unit's general/commander/leader/whoever
				pass

func _ready():
	self.input_pickable = true
