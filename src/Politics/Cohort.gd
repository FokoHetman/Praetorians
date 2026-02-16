extends Node
class_name Cohort

var commons = load("res://src/utils/commons.gd")
var utils = load("res://src/utils/utils.gd").new()
var type

var parent

var attached = true

var centurias

var time

var display_object

var position # relative to legion's root
var destination #WARNING: this is GLOBAL destination position, it doesn't account parents' position.

func _init(type, position, time, centurias = null):
	self.type=type
	self.position = position
	self.time = time
	if centurias:
		self.centurias = centurias
	else:
		self.centurias = default_centurias()
	print("CENTURIAS: ", default_centurias())
	self.time.hourtick.connect(Callable(tick))

func tick(_n):
	pass
func default_centurias():
	return range(6).map(func(_void): return Centuria.new(self.time))

# leader is the most experienced centurion.
func get_leader():
	var experiences = centurias.map(func(c): return c.centurion.history.battles)
	centurias.map(func(c): c.centurion).filter(func(c): return c.centurion.history.battles==max(experiences))[0]

func generate_display_object(perspective: Character):
	self.display_object = Polygon2D.new()
	self.display_object.set_polygon(PackedVector2Array(commons.rounded_square)) # cool rounded sqwuare
	self.display_object.scale = Vector2(0.75, 0.75)
	self.display_object.offset = - 0.75 * utils.get_center(commons.rounded_square)/5
	self.update_color(perspective)
	return self.display_object


func update_color(perspective: Character):
	if self in get_node("/root/Player").selected_units:
		self.display_object.color = Color.WHITE
	if parent.controllable_by(perspective):
		self.display_object.color = Color.WEB_GREEN
	elif parent.allied(perspective):
		self.display_object.color = Color.BLUE
	elif parent.aggressive(perspective):
		self.display_object.color = Color.DARK_RED
	else:
		self.display_object.color = Color.DIM_GRAY
