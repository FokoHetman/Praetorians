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

func _input(event):
	if event is InputEventMouseButton:
		redraw_gametime()

func _ready():
	var vp = get_viewport().size
	$ui/MapButton.connect("button_up", Callable(toMap))
	$ui/MapButton.position = Vector2(vp.x * 9/10, vp.y /2)
	redraw_gametime()
	
func toMap():
	get_parent().toggleView(commons.VIEWS.MAP)
	get_parent().remove_child(self)

func redraw_gametime():
	for i in $Armies.get_children():
		$Armies.remove_child(i)
	var center = utils.get_center(province.curves)
	var default_pos = Vector2(-center.x, -center.y) * mult
	var czoom = get_parent().get_node("Camera2D").zoom
	if czoom.x<1.5:
		for country in get_parent().countries:
			for army in country.armies:
				if army.state.id == province.id:
					var box_pos = default_pos + army.position * mult
					var object = army.display_object(get_parent().countries[0].ruler)
					object.scale = Vector2(5,5)
					object.position = box_pos
					$Armies.add_child(object)
	elif czoom.x<4.5:
		for country in get_parent().countries:
			for army in country.armies:
				if army.state.id == province.id:
					print("<4:", army.kind)
					match army.kind:
						commons.ARMY_TYPES.LEGION:
							#display cohorts
							print("DRAWING COHORTS")
							for cohort in army.composition:
								print("DRAWING COHORT:", cohort)
								var box_pos = default_pos + army.position * mult + cohort.position * mult/10
								var object = cohort.display_object(get_parent().countries[0].ruler)
								object.scale = Vector2(2,2)
								object.position = box_pos
								$Armies.add_child(object)
						commons.ARMY_TYPES.LEVY:
							print("its a levy")
							#display levies (a single big cohort type thing)
							pass
	else:
		# display soldiers
		pass
