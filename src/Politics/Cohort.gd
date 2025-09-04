extends Node
class_name Cohort

var commons = load("res://src/utils/commons.gd")
var utils = load("res://src/utils/utils.gd").new()
var type

var parent

var rows = 20
var columns = 25

var position # relative to legion's root

func _init(type, position):
	self.type=type
	self.position = position


func display_object(perspective: Character):
	var color_obj = Polygon2D.new()
	color_obj.set_polygon(PackedVector2Array(commons.rounded_square)) # cool rounded sqwuare
	color_obj.scale = Vector2(0.75, 0.75)
	color_obj.offset = - 0.75 * utils.get_center(commons.rounded_square)/5
	if parent.controllable_by(perspective):
		color_obj.color = Color.WEB_GREEN
	elif parent.allied(perspective):
		color_obj.color = Color.BLUE
	elif parent.aggressive(perspective):
		color_obj.color = Color.DARK_RED
	else:
		color_obj.color = Color.DIM_GRAY
	return color_obj
