extends Node
class_name Character

var character_name
var surname
var family

var factions

var country

# klasa przedstawiająca jakąś postać

func _init(character_name, surname, family, factions, country):
	self.character_name = character_name
	self.surname = surname
	self.family = family
	self.factions = factions
	self.country = country


func display():
	return self.character_name + " " + self.family.family_name + " " + self.surname
