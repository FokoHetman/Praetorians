extends Node
class_name Country

var commons = load("res://src/utils/commons.gd")

var id
var factions
var characters
var wars
var armies

var ruler

func _init(id, ruler=null, factions=[], characters=[], wars=[], armies=[]):
	self.id = id
	self.factions = factions
	self.characters = characters
	self.wars = wars
	self.armies = armies
	self.ruler = ruler

### TODO: depreciate
func add_character(character: Character):
	self.characters.append(character)
