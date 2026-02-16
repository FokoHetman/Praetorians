extends Area2D
class_name ProvinceArea


func _init():
	pass
# used for handling clickable units
func _input_event(vp, event, sidx):
	print("unit event!")
	if (event is InputEventMouseButton && event.pressed):
		var player = get_node("/root/Player")
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				# set destination of all selected units
				if not player:
					return
				for i in player.selected_units:
					var army_object = i
					while not army_object.has_method("controllable_by") and "parent" in army_object:
						army_object = i.parent
					if army_object.has_method("controllable_by") and army_object.controllable_by(player.character):
						i.destination = get_local_mouse_position()
					print(get_local_mouse_position())
				print(player.selected_units)
			MOUSE_BUTTON_LEFT:
				# deselect all units, I think
				print("hi")
				if not player:
					return
				var old_units = player.selected_units.map(func(x): x)
				player.selected_units = []
				for i in old_units:
					i.update_color(player.character)
func _ready():
	self.input_pickable = true
