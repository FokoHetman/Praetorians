@tool
extends Node
class_name State

var utils = load("res://src/utils/utils.gd").new()
var state_area = load("res://src/Map/state_area.gd")
var commons = load("res://src/utils/commons.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id
var position
var curves
var area
var poly
var color_obj

var type

var settlements
var buildings

var population

var governor

var hovered
var selected

func _init(id=0, position=Vector2.ZERO, curves=[], type = commons.TYPES.FOREST, settlements = [], buildings = [], starting_population=0):
	self.id = id
	self.position = position
	self.curves = curves
	self.area = state_area.new(self)
	self.poly = CollisionPolygon2D.new()
	self.color_obj = Polygon2D.new()
	
	self.type = type
	
	self.population = starting_population
	self.settlements = settlements
	self.buildings = buildings

func display_type():
	var h = "PROVINCE_TYPE."
	match self.type:
		commons.TYPES.FOREST:
			return tr(h+"FOREST")
		commons.TYPES.PLAINS:
			return tr(h+"PLAINS")
		commons.TYPES.DESERT:
			return tr(h+"DESERT")
		commons.TYPES.MOUNTAINS:
			return tr(h+"MOUNTAINS")
		_:
			return tr(h+"ERROR")

func getID() -> String:
	return tr("PROVINCE." + str(self.id))
func description() -> String:
	var result = ""
	result += 'Type: '+ display_type() 
	result += '\nPopulation: '+ str(population)
	if governor:
		result += '\nGovernor: ' + governor.display()
	else:
		result += "\nUngoverned"
	return result
func gen_poly() -> CollisionPolygon2D:
	self.poly.set_polygon(PackedVector2Array(utils.correctify(self.position,curves)))
	
	self.color_obj.set_polygon(PackedVector2Array(utils.correctify(self.position,curves)))
	self.color_obj.color = commons.default_state_color
	#self.color_obj.texture = commons.get_biome_texture(self.type) # TODO
	return self.poly
func gen_area() -> Area2D:
	self.area.add_child(gen_poly())
	self.area.add_child(self.color_obj)
	return self.area
