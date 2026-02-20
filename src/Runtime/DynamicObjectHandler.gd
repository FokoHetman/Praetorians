extends Node2D

@export var current_depth: int = 0

func render(depth, province = null):
	for i in get_children():
		if i.depth == depth:
			i.render()
		else:
			i.derender()

func _input(event):
	var ddepth = 0
	if event.is_action_released("decrease_depth"):
		ddepth -= 1
	if event.is_action_released("increase_depth"):
		ddepth += 1
	var odepth := current_depth
	current_depth += ddepth
	if current_depth < 0:
		current_depth = 0
	if current_depth != odepth:
		
		render(current_depth)
