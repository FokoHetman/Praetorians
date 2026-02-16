extends Node
class_name Country

var commons = load("res://src/utils/commons.gd")

var id
var factions
var dominant_faction # index 
# TODO ^
var characters
var wars
var armies

var ruler
var time

func _init(id, time, ruler=null, factions=[], characters=[], wars=[], armies=[]):
	self.id = id
	self.factions = factions
	self.characters = characters
	self.wars = wars
	self.armies = armies

	self.ruler = ruler
	self.time = time

func set_dominant_faction(index):
	dominant_faction = index

func add_character(character: Character):
	self.characters.append(character)

# state: The state legion is assigned to. It will be reinforced from this state's population. State needs to be *fully* controlled in order to be able to deploy a legion
# loyalty: Faction the legion is loyal to. Usually it's the country/province's leader
# composition: List of Cohorts within the legion
func create_legion(state: State, loyalty: Faction = null, composition = []):
	var new_legion = Army.new(commons.ARMY_TYPES.LEGION, composition, self.id, Vector2(0,0), self.time)
	new_legion.assign(state)
	if loyalty:
		new_legion.loyalty = loyalty
	armies.append(new_legion)
