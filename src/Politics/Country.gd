extends Node
class_name Country

var commons = load("res://src/utils/commons.gd")

var id
var states
var factions
var characters

func _init(id="unspecified",states=[], factions=[], characters=[]):
	self.id = id
	self.states = states
	self.factions = factions
	self.characters = characters
	
func add_character(character: Character):
	self.characters.append(character)

# state: The state legion is assigned to. It will be reinforced from this state's population. State needs to be *fully* controlled in order to be able to deploy a legion
# loyalty: Faction the legion is loyal to. Usually it's the country/province's leader
# composition: List of Cohorts within the legion
func create_legion(state: State, loyalty: Faction, composition = []):
	var new_legion = Army.new(commons.ARMY_TYPES.LEGION, composition)
	new_legion.assign(state)
	loyalty.armies.append(new_legion)
