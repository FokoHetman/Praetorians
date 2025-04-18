@tool
extends Node

var id
var countries_id
var army

func _init(id="unspecified",countries_id=null,army=0):
	self.id = id
	self.countries_id = countries_id
	self.army = army


func getID():
	return self.id
