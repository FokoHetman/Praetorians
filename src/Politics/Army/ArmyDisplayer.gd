extends Node2D

### This scene serves a specific purpose, displaying SUBUNITS of an UNIT
var def_attr = Callable(func(x: Unit): return x.position)

func render(unit: Unit, attr: Callable = def_attr):
	for i in get_children():
		self.remove_child(i)
		i.queue_free()
	if unit.is_base:
		render_unit(unit)
		return
	for i in unit.subunits:
		render_unit(i,attr.call(i))

func render_unit(unit: Unit, pos=Vector2.ZERO):
	### TODO: calculate space for a single unit, given specific box restrictions
	### and apply calculated space to displayed objects
	var unit_container = Node2D.new()
	unit_container.position = pos
	var dobj = unit.craft_display_object()
	dobj.color = Utils.new().get_perspective_color(unit, get_node(Commons.Player).character)
	var area = unit.craft_area()
	unit_container.add_child(dobj)
	unit_container.add_child(area)
	add_child(unit_container)
