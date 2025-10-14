extends Node
class_name Centuria

var commons = load("res://src/utils/commons.gd")
var utils = load("res://src/utils/utils.gd").new()

var centurion # dangerous zone.
var optio

var rows = 10
var columns = 8

var parent

var display_object

var manpower = rows * columns
var support  = floor(manpower/4) # non-combatant auxillia within the centuria

var position
var destination #WARNING: this is GLOBAL destination position, it doesn't account parents' position.

func _init(ccenturion=null, ooptio=null, pparent=null):
	if pparent:
		self.parent = pparent
	if ccenturion:
		self.centurion = ccenturion
	else:
		self.centurion = Character.random_military()
	if ooptio:
		self.optio = ooptio
	else:
		self.optio = Character.random_military()

func ch_leader(new_leader: Character):
	centurion = new_leader
	

func generate_display_object(perspective: Character):
	self.display_object = Polygon2D.new()
	self.display_object.set_polygon(PackedVector2Array(commons.rounded_square)) # cool rounded sqwuare
	self.display_object.scale = Vector2(0.75, 0.75)
	self.display_object.offset = - 0.75 * utils.get_center(commons.rounded_square)/5
	if self in get_node("/root/Player").selected_units:
		self.display_object.color = Color.WHITE
	if parent.parent.controllable_by(perspective):
		self.display_object.color = Color.WEB_GREEN
	elif parent.parent.allied(perspective):
		self.display_object.color = Color.BLUE
	elif parent.parent.aggressive(perspective):
		self.display_object.color = Color.DARK_RED
	else:
		self.display_object.color = Color.DIM_GRAY
	return self.display_object
