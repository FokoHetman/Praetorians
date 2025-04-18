@tool
extends Node
class_name State

var utils = load("res://scripts/utils.gd").new()
var state_area = load("res://scripts/state_area.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var id
var position
var curves
var area
var poly
func _init(id="unspecified", position=Vector2.ZERO, curves=[]):
	self.id = id
	self.position = position
	self.curves = curves
	self.area = state_area.new(self)
	self.poly = CollisionPolygon2D.new()
	
# Called when the node enters the scene tree for the first time.
func getID():
	return self.id

func gen_poly() -> CollisionPolygon2D:
	self.poly.set_polygon(PackedVector2Array(utils.correctify(self.position,curves)))
	return self.poly
func gen_area() -> Area2D:
	self.area.add_child(gen_poly())
	return self.area
