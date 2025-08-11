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
var population
var man_power
var cities_number
var cities_max


var hovered
var selected

func _init(id="unspecified", position=Vector2.ZERO, curves=[], type = commons.TYPES.FOREST, population=0, man_power=0, cities_number=0, cities_max=0):
	self.id = id
	self.position = position
	self.curves = curves
	self.area = state_area.new(self)
	self.poly = CollisionPolygon2D.new()
	self.color_obj = Polygon2D.new()
	
	self.type = type
	self.population = population
	self.man_power = man_power
	self.cities_number = cities_number
	self.cities_max = cities_max
	

func display_type():
	match self.type:
		commons.TYPES.FOREST:
			return "Forest"
		commons.TYPES.PLAINS:
			return "Plains"
		commons.TYPES.DESERT:
			return "Desert"
		commons.TYPES.MOUNTAINS:
			return "Mountains"
		_:
			return "Stalinium (error)"

func getID():
	return self.id

func gen_poly() -> CollisionPolygon2D:
	self.poly.set_polygon(PackedVector2Array(utils.correctify(self.position,curves)))
	
	self.color_obj.set_polygon(PackedVector2Array(utils.correctify(self.position,curves)))
	self.color_obj.color = commons.default_state_color
	#self.color_obj.texture = commons.get_biome_texture(self.type) # TODO
	match self.type:
		commons.TYPES.MOUNTAINS:
			self.color_obj.texture_offset = Vector2(300, 200)
			self.color_obj.texture_scale = Vector2(5,5)
		commons.TYPES.PLAINS:
			self.color_obj.texture_scale = Vector2(4,4)
			self.color_obj.texture_offset = Vector2(250, -200)
		commons.TYPES.FOREST:
			self.color_obj.texture_scale = Vector2(4,4)
			self.color_obj.texture_offset = Vector2(250, -200)
		commons.TYPES.DESERT:
			self.color_obj.texture_scale = Vector2(4,4)
			self.color_obj.texture_offset = Vector2(-150, -200)
		_:
			self.color_obj.texture_scale = Vector2(6,6)
	return self.poly
func gen_area() -> Area2D:
	self.area.add_child(gen_poly())
	self.area.add_child(self.color_obj)
	return self.area
