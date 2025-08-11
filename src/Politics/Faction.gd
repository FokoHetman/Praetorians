extends Node

var id
var countries
var armies

func _init(id="unspecified",armies=[]):
	self.id = id
	self.armies = armies


func getID():
	return self.id
