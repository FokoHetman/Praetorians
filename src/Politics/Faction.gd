extends Node
class_name Faction

var id
var countries

func _init(id=0,countries=[]):
	self.id = id
	self.countries = countries

func getID():
	return tr("FACTION."+str(self.id))
