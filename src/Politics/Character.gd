extends Node
class_name Character

var character_name
var surname
var family
var factions

# klasa przedstawiająca jakąś postać

func _init(character_name, surname, family, factions):
	self.character_name = character_name
	self.surname = surname
	self.family = family
	self.factions = factions

func display():
	return self.character_name + " " + self.family.family_name + " " + self.surname
