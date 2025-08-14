extends Node
class_name Building
var commons = load("res://src/utils/commons.gd")

var type

var workers # amount of workers assigned to the building
var max_workers

func _init(type):
	self.type = type

func display():
	match self.type:
		commons.BUILDINGS.FORGE:
			return tr("BLACKSMITH")
		commons.BUILDINGS.PORT:
			return tr("PORT")

func description():
	match self.type:
		commons.BUILDINGS.FORGE:
			return tr("BLACKSMITH_DESCRIPTION")
		commons.BUILDINGS.PORT:
			return tr("PORT_DESCRIPTION")
