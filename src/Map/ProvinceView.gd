extends Node2D

var utils = load("res://src/utils/utils.gd").new()
var commons = load("res://src/utils/commons.gd")

var province

var border_line_width = 5
var border_color = Color.from_hsv(32/360, .41, .39, 1)


func redraw():
	print("redrawing...")
	print(province.getID())
	queue_redraw()

const mult = 35

func draw_state(state):
	var center = utils.get_center(state.curves)
	var last_line = Vector2(-center.x, -center.y) * mult
	print(center)
	for line in state.curves:
		var color = border_color
		draw_line(last_line, last_line+line*mult, color, border_line_width)
		last_line = last_line+line*mult
	draw_line(last_line, Vector2(-center.x, -center.y)*mult, border_color, border_line_width)
	print("Drawn: ", state.id)
func _draw() -> void:
	if province:
		draw_state(province)

func _ready():
	var vp = get_viewport().size
	$ui/MapButton.connect("button_up", Callable(toMap))
	$ui/MapButton.position = Vector2(vp.x * 9/10, vp.y /2)
	
func toMap():
	get_parent().toggleView(commons.VIEWS.MAP)
	get_parent().remove_child(self)
