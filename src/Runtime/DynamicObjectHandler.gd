extends Node2D

@export var current_depth: int = 0

func render(depth):
	if get_node(Commons.GameRoot).view == Commons.VIEWS.PROVINCE:
		for i in get_children():
			var pv = get_node(Commons.ProvinceView)
			if i.depth == depth and pv.province.contains_position(i.position):
				var center = Utils.new().get_center(pv.province.curves)
				i.render(center * -pv.mult)
			else:
				i.derender()
		return
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
