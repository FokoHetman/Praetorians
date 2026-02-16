extends Node
class_name Army

var utils = load("res://src/utils/utils.gd").new()
var commons = load("res://src/utils/commons.gd")

var kind
var leader

var position	# position INSIDE of a state
var destination # desired position (movement)

var display_object

var state		# state where the legion is stationing

var country
var loyalty # loyalty. TODO: counted over the leader's loyalty

var time

var composition

func _init(type, composition, country, position, time):
	self.country = country
	var composition2 =  composition
	for i in composition:
		i.parent = self
	self.composition = composition2
	self.position = position
	self.kind = type
	self.time = time
	self.time.hourtick.connect(Callable(tick))

func tick(_n):
	pass
func assign(state: State):
	self.leader = state.governor
	self.state = state

func assign_leader(leader: Character):
	self.leader = leader

func generate_display_object(perspective: Character):
	self.display_object = Polygon2D.new()
	self.display_object.set_polygon(PackedVector2Array(commons.rounded_square)) # cool rounded sqwuare
	self.display_object.scale = Vector2(0.75, 0.75)
	self.display_object.offset = - 0.75 * utils.get_center(commons.rounded_square)/5
	return self.display_object

func update_color(perspective: Character):
	if self in get_node("/root/Player").selected_units:
		self.display_object.color = Color.WHITE
	if controllable_by(perspective):
		self.display_object.color = Color.WEB_GREEN
	elif allied(perspective):
		self.display_object.color = Color.BLUE
	elif aggressive(perspective):
		self.display_object.color = Color.DARK_RED
	else:
		self.display_object.color = Color.DIM_GRAY


func allied(character):
	if character.country == self.country:
		for i in character.factions:
			if len(utils.intersect(leader.factions, i.wars))>0:
				return false
		return true
	else:
		# TODO: add cross-country alliances
		return false
	return false


func aggressive(character):
	if character.country == self.country:
		for i in character.factions:
			if len(utils.intersect(leader.factions, i.wars))>0:
				return true
		return false
	else:
		if country in character.country.wars:
			return true
	return false

func controllable_by(character):
	return character == leader or (character!=null and loyalty in character.factions)
