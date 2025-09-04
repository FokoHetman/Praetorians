extends Node2D
class_name Building
var commons = load("res://src/utils/commons.gd")
var utils = load("res://src/utils/utils.gd").new()

var type
var kind

var workers # amount of workers assigned to the building
var max_workers

func _init(kind):
	self.kind = kind
	self.type = commons.getType(kind)


func display():
	match self.type:
		commons.BUILDING_KIND.FORGE:
			return tr("BLACKSMITH")
		commons.BUILDING_KIND.PORT:
			return tr("PORT")

func description():
	match self.type:
		commons.BUILDING_KIND.FORGE:
			return tr("BLACKSMITH_DESCRIPTION")
		commons.BUILDING_KIND.PORT:
			return tr("PORT_DESCRIPTION")

func display_obj():
	# this method *should* be overriden by the buildings' script in Buildings/*
	print("this should never happen.")
