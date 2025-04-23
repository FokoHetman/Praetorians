extends Node

var id
var countries
var army

func _init(id="unspecified",countries=[],army=[]):
	self.id = id
	self.countries = countries
	self.army = army


func getID():
	return self.id
