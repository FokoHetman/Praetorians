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

var state = load("res://state.gd")
func create_state(id, pos, curves):
	var cstate = state.new(id,pos,curves)
	cstate.id = id
	cstate.position = pos
	cstate.curves = curves
	return cstate
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
