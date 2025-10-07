extends Node
class_name Character

# self explanatory
var character_name
var surname
var family

# TODO: cultures
var culture

# FACTIONS that the character is a part of
var factions

# the COUNTRY that the character  pledges loyalty to.
var country


func _init(character_name, surname, family, factions, country):
	self.character_name = character_name
	self.surname = surname
	self.family = family
	self.factions = factions
	self.country = country
	if get_node("/root/Map"):
		get_node("/root/Map").CHARACTER_POOL.append(self)
	else:
		print_debug("WARNING: Character ", character_name, " ", surname, " ", family, " of ", country, " couldn't be added to the CHARACTER POOL.")

# create a random character. used by Centurias
static func random_military():
	# TODO: make it look for an existing character first, given the culture/country character pool
	# TODO: make it select *specifically* military characters
	#get_node("/root/Menu").CHARACTER_POOL
	return randomized()

static func randomized():
	return Character.new(TEMP_NAMES.pick_random(), TEMP_SURNAMES.pick_random(), Family.new("TESTING"), null, null)



func display():
	return self.character_name + " " + self.family.family_name + " " + self.surname

# TESTING DATA

# IN REALITY pick from countries' names.
const TEMP_NAMES = ["Aecius", "Marcus", "Remus"]
const TEMP_SURNAMES = ["Caesar", "Romulus", "Aurelius"]
