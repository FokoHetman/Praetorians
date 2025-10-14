extends Node2D

var utils = load("res://src/utils/utils.gd").new()
var commons = load("res://src/utils/commons.gd")

var province
var province_area

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
	if event is InputEventMouseMotion:
		redraw_gametime()
	elif (event is InputEventMouseButton && event.pressed):
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				# idk
				pass
			MOUSE_BUTTON_RIGHT:
				# set all selected units destination and (TODO) redraw movement arrows
				var loc = get_local_mouse_position()
				print(loc)
				for i in get_node("/root/Player").selected_units:
					i.destination = loc
			
func _ready():
	var vp = get_viewport().size
	$ui/MapButton.connect("button_up", Callable(toMap))
	$ui/MapButton.position = Vector2(vp.x * 9/10, vp.y /2)
	redraw_gametime()
	
	# TODO: make an area2D out of province's curves, it'll be used for army movement
	
	province_area = ProvinceArea.new()
	var poly = CollisionPolygon2D.new()
	poly.set_polygon(PackedVector2Array(utils.correctify(province.position,province.curves)))
	province_area.add_child(poly)
	add_child(province_area)

func toMap():
	get_parent().toggleView(commons.VIEWS.MAP)
	get_parent().remove_child(self)

enum DISPLAYED {ARMIES, COHORTS, UNITS}
var current = null

func clear():
	for i in $Armies.get_children():
		$Armies.remove_child(i)

func redraw_gametime():
	var center = utils.get_center(province.curves)
	var default_pos = Vector2(-center.x, -center.y) * mult
	var czoom = get_parent().get_node("Camera2D").zoom
	if czoom.x<1.5:
		if current != DISPLAYED.ARMIES:
			current = DISPLAYED.ARMIES
			clear()
			for country in get_parent().countries:
				for army in country.armies:
					if army.state.id == province.id:
						var box_pos = default_pos + army.position * mult
						var object = army.generate_display_object(get_parent().countries[0].ruler)
						object.scale = Vector2(5,5)
						object.position = box_pos
						mkLead(object, army)
						$Armies.add_child(object)
	elif czoom.x<4.5:
		if current != DISPLAYED.COHORTS:
			current = DISPLAYED.COHORTS
			clear()
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
									var object = cohort.generate_display_object(get_parent().countries[0].ruler)
									object.scale = Vector2(2,2)
									object.position = box_pos
									mkLead(object, cohort)
									$Armies.add_child(object)
							commons.ARMY_TYPES.LEVY:
								print("its a levy")
								#display levies (a single big cohort type thing)
								pass
	elif current != DISPLAYED.UNITS:
		current = DISPLAYED.UNITS
		clear()
		for country in get_parent().countries:
			for army in country.armies:
				if army.state.id == province.id:
					print("<4:", army.kind)
					match army.kind:
						commons.ARMY_TYPES.LEGION:
							#display cohorts
							print("DRAWING COHORTS")
							for cohort in army.composition:
								var breakage = round(len(cohort.centurias) / 2) # round is ~ roof when dividing by 2
								print("BREAKAGE: ", breakage)
								
								var centuria_position = Vector2(0,0)
								
								# displaying centurias
								for ci in range(len(cohort.centurias)):
									var centuria = cohort.centurias[ci]
									var y = floor(ci/breakage)
									var centuria_pos = default_pos + army.position * mult + cohort.position * mult/10 + centuria_position * mult/15
									
									### displaying centurions and optios
									
									if centuria.centurion:
										print("CENTURION")
										# todo: make them more distinct
										var centurion_pos = centuria_pos + (Vector2(-1.2, -0.2) - Vector2(7,7)) * mult/20
										var centurion = cohort.generate_display_object(get_parent().countries[0].ruler)
										centurion.scale = Vector2(0.105, 0.105)
										centurion.position = centurion_pos
										mkLead(centurion, centuria)
										$Armies.add_child(centurion)
									if centuria.optio:
										print("OPTIO")
										# todo: make them more distinct
										var optio_pos = centuria_pos + (Vector2(centuria.columns, centuria.rows) - Vector2(6.75,8)) * mult/20 
										var optio = cohort.generate_display_object(get_parent().countries[0].ruler)
										optio.scale = Vector2(0.1, 0.1)
										optio.position = optio_pos
										$Armies.add_child(optio)
									### displaying units
									var used_manpower = 0
									for r in range(centuria.rows):
										for c in range(centuria.columns):
											print("DRAWING ", c, "x", r, " UNIT")
											if used_manpower < centuria.manpower:
												var box_pos = centuria_pos + (Vector2(c, r) - Vector2(7,7)) * mult/20
												var object = cohort.generate_display_object(get_parent().countries[0].ruler)
												object.scale = Vector2(0.08, 0.08)
												object.position = box_pos
												$Armies.add_child(object)
												used_manpower+=1
									if ci+1==breakage:
										centuria_position = Vector2(0,8)
									else:
										centuria_position += Vector2(8,0)
						commons.ARMY_TYPES.LEVY:
							print("its a levy")
							#display levies (a single big cohort type thing)
							pass
		# display soldiers
		pass

# Display OBJect
func mkLead(dobj, army):
	var area = UnitArea.new(army)
	army.display_object = dobj
	var col = CollisionPolygon2D.new()
	col.set_polygon(dobj.polygon)
	area.add_child(col)
	dobj.add_child(area)
