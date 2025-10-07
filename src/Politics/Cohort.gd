extends Node
class_name Cohort

var commons = load("res://src/utils/commons.gd")
var utils = load("res://src/utils/utils.gd").new()
var type

var parent

var centurias

var position # relative to legion's root
var destination

func _init(type, position, centurias = null):
	self.type=type
	self.position = position
	if centurias:
		self.centurias = centurias
	else:
		self.centurias = default_centurias()
	print("CENTURIAS: ", default_centurias())

func default_centurias():
	return range(6).map(func(_void): return Centuria.new())

# leader is the most experienced centurion.
func get_leader():
	var experiences = centurias.map(func(c): return c.centurion.history.battles)
	centurias.map(func(c): c.centurion).filter(func(c): return c.centurion.history.battles==max(experiences))[0]

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
