@tool
extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func correctify(position, arr) -> Array:
	var last_val = position
	var n_arr = [last_val]
	for i in arr:
		n_arr.append(last_val+i)
		last_val = last_val+i
	return n_arr
func map_pos(position, arr) -> Array:
	var n_arr = []
	for i in arr:
		n_arr.append(-(Vector2.ZERO+position+i))
	return n_arr

var state = load("res://src/State/state.gd")
func create_state(id, pos, curves):
	var cstate = state.new(id,pos,curves)
	cstate.id = id
	cstate.position = pos
	cstate.curves = curves
	return cstate

func get_center(curves):
	var X = 0
	var Y = 0
	var current = Vector2(0,0)
	for i in curves:
		current += i
		X += current.x
		Y += current.y
	return Vector2(X / len(curves), Y/len(curves))

func take(num, list):
	var new_list = []
	for i in range(0,num):
		new_list.append(list[i])
	return new_list



func _ready():
	pass 
