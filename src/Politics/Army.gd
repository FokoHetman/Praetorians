extends Node
class_name Army

var utils = load("res://src/utils/utils.gd").new()
var commons = load("res://src/utils/commons.gd")

var kind

var leader

var position	# position INSIDE of a state
var state		# state where the legion is stationing

var country
var loyalty # loyalty. TODO: counted over the leader's loyalty


var composition

func _init(type, composition, country):
	self.country = country
	self.composition = composition

func assign(state: State):
	self.leader = state.governor
	self.state = state

func assign_leader(leader: Character):
	self.leader = leader

func display_object(perspective: Character):
	var color_obj = Polygon2D.new()
	color_obj.set_polygon(PackedVector2Array(commons.rounded_square)) # cool rounded sqwuare
	color_obj.scale = Vector2(0.75, 0.75)
	color_obj.offset = - 0.75 * utils.get_center(commons.rounded_square)/5
	if controllable_by(perspective):
		color_obj.color = Color.WEB_GREEN
	elif allied(perspective):
		color_obj.color = Color.BLUE
	elif aggressive(perspective):
		color_obj.color = Color.DARK_RED
	else:
		color_obj.color = Color.DIM_GRAY
	return color_obj

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
	return character == leader or loyalty in character.factions
