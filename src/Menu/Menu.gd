@tool
extends Node2D


var utils = load("res://src/utils/utils.gd").new()
var state_supplier = load("res://src/Map/State.gd")
var country_supplier = load("res://src/Politics/Country.gd")

var countries = []

var font
var states = []
var border_line_width = 1.2

var border_color = Color.from_hsv(32/360, .41, .39, 1)
var select_color = Color.from_hsv(45/360, 75/360, 96/360, 1)
var game_size = Vector2(0.226, 0.308)


var time = load("res://src/Runtime/GameTime.gd").new(-753,110,0)

var commons = load("res://src/utils/commons.gd")

var view

func toggleView(view, province=null):
	view = view
	match view:
		commons.VIEWS.PROVINCE:
			print("province!!")
			print(province)
			pass
		commons.VIEWS.MAP:
			toggleMap()
	pass


func draw_state(state):
	var last_line = state.position
	for line in state.curves:
		var color = border_color
		draw_line(last_line, last_line+line, color, border_line_width)
		last_line = last_line+line
	draw_line(last_line, state.position, border_color, border_line_width)
	print("Drawn: ", state.id)

func _draw() -> void:
	
	draw_line(Vector2.ZERO, Vector2.DOWN*300, Color.AQUA, 0)
	
	draw_string(font, Vector2.ZERO+Vector2.DOWN*30+Vector2.LEFT*50, 'Ave Caesar!')
	print("Drawing states...")
	for state in states:
		draw_state(state)

func disintegrate(pos):
	return pos + Vector2((randi()% 20-2)*10, (randi()% 20-2)*10)

func _ready():
	time.name = 'GameTime'
	add_child(time)
	toggleView(commons.VIEWS.MAP)
func toggleMap():
	$ui/Time.position.x = get_viewport().size.x - 0.1*get_viewport().size.x
	$ui/Time.position.y = get_viewport().size.y - 0.9*get_viewport().size.y
	$ui/Time.scale.x = get_viewport().size.x / 1920 * $ui/Time.scale.x
	$ui/Time.scale.y = get_viewport().size.y / 1080 * $ui/Time.scale.y
	
	define_states()
	define_countries()


func define_states():
	var sicily = state_supplier.new("Sicily", Vector2.ZERO+ 118*Vector2.DOWN + 122*Vector2.RIGHT, [Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*4+Vector2.LEFT*2, Vector2.DOWN*4+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.DOWN*3, Vector2.RIGHT*4, Vector2.RIGHT*5+Vector2.DOWN*2, Vector2.DOWN*2+Vector2.RIGHT, Vector2.RIGHT*4+Vector2.DOWN*3, Vector2.DOWN*2+Vector2.RIGHT*4,
		Vector2.RIGHT*5, Vector2.RIGHT*4+Vector2.DOWN*6, Vector2.RIGHT*2, Vector2.DOWN+Vector2.RIGHT, Vector2.RIGHT*4, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT+Vector2.UP, Vector2.UP*3+Vector2.LEFT, Vector2.UP*4+Vector2.RIGHT*4, Vector2.UP*3+Vector2.LEFT*3, Vector2.UP+Vector2.RIGHT, Vector2.UP*2+Vector2.LEFT*2, Vector2.UP*2, Vector2.RIGHT*2+Vector2.UP*6, Vector2.UP*5+Vector2.RIGHT*4,
		Vector2.UP*2, Vector2.UP*2+Vector2.RIGHT, Vector2.LEFT*2+Vector2.UP, Vector2.LEFT*6+Vector2.DOWN*3, Vector2.UP+Vector2.LEFT*3, Vector2.DOWN*3+Vector2.LEFT*4, Vector2.LEFT*8, Vector2.LEFT*2+Vector2.DOWN, Vector2.LEFT*3, Vector2.LEFT*5+Vector2.UP*4, Vector2.LEFT*2, Vector2.DOWN*3+Vector2.LEFT*4])
	states.append(sicily)
	
	#Vector2.DOWN*5+Vector2.LEFT*2.5, Vector2.DOWN*5+Vector2.RIGHT*2.5, Vector2.UP*2+Vector2.RIGHT*2, Vector2.DOWN*5+Vector2.RIGHT*15, Vector2.DOWN*6+Vector2.RIGHT*4,
	#		Vector2.RIGHT*10+Vector2.DOWN*4, Vector2.UP*10+Vector2.RIGHT*4, Vector2.UP*4+Vector2.LEFT*3, Vector2.UP*8+Vector2.RIGHT*2, Vector2.UP*2+Vector2.RIGHT*4, Vector2.UP*4+Vector2.RIGHT*2, 
	#		
	#		Vector2.LEFT*10+Vector2.DOWN/2, Vector2.LEFT*2+Vector2.UP*2, Vector2.LEFT*2+Vector2.DOWN*2,
	#		Vector2.LEFT*6+Vector2.DOWN*2,
	#		
	#		Vector2.LEFT*10+Vector2.DOWN, Vector2.LEFT*3+Vector2.UP*3, Vector2.DOWN*3+Vector2.LEFT*3, Vector2.LEFT*2, Vector2.UP*2

	var calabria = state_supplier.new("Calabria", Vector2.ZERO+ 119*Vector2.DOWN + 165*Vector2.RIGHT, [Vector2.DOWN*2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT*4, Vector2.UP+Vector2.RIGHT*2, Vector2.UP*5+Vector2.RIGHT, Vector2.RIGHT*5+Vector2.UP*2, Vector2.UP*8+Vector2.DOWN,
		Vector2.RIGHT*5+Vector2.UP*4, Vector2.RIGHT*4+Vector2.DOWN, Vector2.RIGHT+Vector2.UP*2, Vector2.UP*2+Vector2.LEFT, Vector2.UP*5+Vector2.RIGHT, Vector2.LEFT*4+Vector2.UP*4, Vector2.LEFT*5+Vector2.UP, Vector2.UP*4+Vector2.LEFT, Vector2.RIGHT+Vector2.UP, Vector2.UP*2, Vector2.UP*3+Vector2.RIGHT*2,
		Vector2.LEFT*3+Vector2.UP, Vector2.DOWN*2+Vector2.LEFT*2, Vector2.DOWN*3+Vector2.LEFT, Vector2.LEFT+Vector2.UP, Vector2.DOWN+Vector2.LEFT*2, Vector2.LEFT*3+Vector2.UP*2, Vector2.LEFT*2, Vector2.LEFT+Vector2.DOWN,
		Vector2.DOWN*4+Vector2.RIGHT, Vector2.RIGHT*4+Vector2.DOWN*8, Vector2.LEFT+Vector2.DOWN*2, Vector2.DOWN*8+Vector2.RIGHT*3, Vector2.LEFT*5+Vector2.DOWN*3, Vector2.DOWN*4+Vector2.RIGHT])
	states.append(calabria)
	
	
	var basilicata = state_supplier.new("Basilicata", Vector2.ZERO + 180*Vector2.RIGHT + 80*Vector2.DOWN, [Vector2.UP*5+Vector2.RIGHT*3, Vector2.LEFT+Vector2.UP, Vector2.UP+2*Vector2.LEFT, Vector2.UP+Vector2.RIGHT, Vector2.UP*4+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3+Vector2.UP*2, Vector2.UP*2+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.UP, Vector2.UP+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP*2.5, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3.5,
		Vector2.DOWN*2+Vector2.RIGHT, Vector2.DOWN*2+Vector2.LEFT*2, Vector2.LEFT*1.5, Vector2.DOWN*2, Vector2.DOWN*2.5+Vector2.RIGHT*1.5, Vector2.DOWN, Vector2.RIGHT+Vector2.DOWN, Vector2.DOWN*0.5, Vector2.DOWN*5+Vector2.RIGHT*4, Vector2.DOWN*4+Vector2.LEFT*3, Vector2.DOWN*2+Vector2.RIGHT*2,
		 Vector2.UP*0.5,
		 Vector2.RIGHT+Vector2.UP, Vector2.RIGHT*2, Vector2.RIGHT*3+Vector2.DOWN*2, Vector2.UP+Vector2.RIGHT*2, Vector2.RIGHT+Vector2.DOWN, Vector2.UP*3+Vector2.RIGHT, Vector2.UP*2+Vector2.RIGHT*2, Vector2.RIGHT*3+Vector2.DOWN
		])
	states.append(basilicata)

	var apulia = state_supplier.new("Apulia", Vector2.ZERO + 183*Vector2.RIGHT + 75*Vector2.DOWN, [Vector2.LEFT+Vector2.UP, Vector2.UP+2*Vector2.LEFT, Vector2.UP+Vector2.RIGHT, Vector2.UP*4+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3+Vector2.UP*2, Vector2.UP*2+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.UP, Vector2.UP+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP*2.5, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3.5,
		Vector2.LEFT+Vector2.DOWN/2, Vector2.LEFT+Vector2.UP, Vector2.LEFT*1.5+Vector2.DOWN/2, Vector2.UP+Vector2.LEFT, Vector2.UP*2+Vector2.RIGHT/2, Vector2.UP+Vector2.LEFT, Vector2.LEFT, Vector2.LEFT+Vector2.UP, Vector2.UP+Vector2.RIGHT, Vector2.LEFT*2+Vector2.UP*2,
		Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.RIGHT, Vector2.UP+Vector2.RIGHT*2, Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.UP*2,
		Vector2.RIGHT*4+Vector2.DOWN*1.5, Vector2.RIGHT*6+Vector2.UP/2, Vector2.UP+Vector2.RIGHT, Vector2.RIGHT*3, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.DOWN*2, Vector2.DOWN*2+Vector2.LEFT*4, Vector2.DOWN*3, Vector2.DOWN*6+Vector2.RIGHT*12, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN*2+Vector2.RIGHT*6, Vector2.DOWN*4+Vector2.RIGHT*4, Vector2.DOWN*2+Vector2.RIGHT*6, Vector2.DOWN+Vector2.RIGHT*1.5, Vector2.DOWN*4+Vector2.RIGHT*1.5, Vector2.RIGHT*4+Vector2.DOWN*2, Vector2.DOWN, Vector2.DOWN*4+Vector2.RIGHT*2, Vector2.DOWN*4+Vector2.LEFT*2, Vector2.DOWN*2, Vector2.LEFT*2, Vector2.UP*3+Vector2.LEFT*4, Vector2.UP+Vector2.LEFT/2, Vector2.UP, Vector2.RIGHT+Vector2.UP, Vector2.UP*3.5+Vector2.LEFT*3, Vector2.UP*2+Vector2.LEFT*8, Vector2.UP*2+Vector2.LEFT*2, Vector2.LEFT*2
	])
	states.append(apulia)
	var campania = state_supplier.new("Campania", Vector2.ZERO + 163*Vector2.RIGHT+61.5*Vector2.DOWN, [
		Vector2.DOWN*2+Vector2.RIGHT, Vector2.DOWN*2+Vector2.LEFT*2, Vector2.LEFT*1.5, Vector2.DOWN*2, Vector2.DOWN*2.5+Vector2.RIGHT*1.5, Vector2.DOWN, Vector2.RIGHT+Vector2.DOWN, Vector2.DOWN*0.5, Vector2.DOWN*5+Vector2.RIGHT*4, Vector2.DOWN*4+Vector2.LEFT*3,
		Vector2.UP+Vector2.LEFT, Vector2.LEFT*3+Vector2.DOWN*2, Vector2.UP*3+Vector2.LEFT*3, Vector2.LEFT*3+Vector2.UP, Vector2.LEFT/2+Vector2.UP*1.5, Vector2.UP*2+Vector2.RIGHT*2, Vector2.UP*5+Vector2.LEFT*4, Vector2.LEFT*6+Vector2.DOWN, Vector2.UP*1, Vector2.UP+Vector2.RIGHT*2, Vector2.UP, Vector2.LEFT*3+Vector2.UP, Vector2.LEFT*3, Vector2.UP*8+Vector2.LEFT*5,
		Vector2.UP*2+Vector2.RIGHT*2, Vector2.UP*2, Vector2.UP+Vector2.RIGHT, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.RIGHT/2+Vector2.UP, Vector2.UP*1.5, Vector2.RIGHT*2, Vector2.RIGHT*5+Vector2.DOWN*2, Vector2.RIGHT*2, Vector2.UP/2+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.UP,
 		Vector2.UP/2, Vector2.RIGHT*2+Vector2.DOWN*2, Vector2.DOWN+Vector2.LEFT, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN*2+Vector2.LEFT/2, Vector2.DOWN+Vector2.RIGHT, Vector2.RIGHT*1.5+Vector2.UP/2, Vector2.RIGHT+Vector2.DOWN,Vector2.RIGHT+Vector2.UP/2,
	])
	states.append(campania)
	
	var molise = state_supplier.new("Molise", Vector2.ZERO+139.5*Vector2.RIGHT+54*Vector2.DOWN, [
		Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.RIGHT/2+Vector2.UP, Vector2.UP*1.5, Vector2.RIGHT*2, Vector2.RIGHT*5+Vector2.DOWN*2, Vector2.RIGHT*2, Vector2.UP/2+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.UP,
		Vector2.UP/2, 	Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.RIGHT, Vector2.UP+Vector2.RIGHT*2, Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.UP*2,
		Vector2.LEFT*3+Vector2.UP*1.5, Vector2.LEFT*2, 
		Vector2.LEFT*3+Vector2.DOWN*3.5, Vector2.LEFT/2+Vector2.DOWN*1.5, Vector2.LEFT, Vector2.LEFT+Vector2.UP*1.5, Vector2.LEFT*1.5+Vector2.UP/2, Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.DOWN*1.5, 
		Vector2.DOWN*3+Vector2.RIGHT/2
	])
	states.append(molise)
	
	var lazio = state_supplier.new("Lazio", Vector2.ZERO+136.5*Vector2.RIGHT+59*Vector2.DOWN, [
		Vector2.UP*2+Vector2.RIGHT*2, Vector2.UP*2, Vector2.UP+Vector2.RIGHT,
		Vector2.UP+Vector2.RIGHT*1.5, Vector2.UP*3+Vector2.LEFT/2,
		Vector2.LEFT*4+Vector2.UP*1.5, Vector2.UP+Vector2.LEFT/2, Vector2.LEFT, Vector2.DOWN+Vector2.LEFT/2, Vector2.LEFT, Vector2.UP+Vector2.LEFT, Vector2.LEFT*1.5+Vector2.UP, Vector2.UP*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP, Vector2.UP/2+Vector2.LEFT/2, Vector2.LEFT*2+Vector2.UP/2, Vector2.UP*2+Vector2.RIGHT*1.5, Vector2.RIGHT*2+Vector2.DOWN/2, Vector2.RIGHT*1.5+Vector2.UP, Vector2.UP*2+Vector2.LEFT*2, Vector2.UP*4+Vector2.LEFT, Vector2.UP*1.5, Vector2.RIGHT*4+Vector2.UP/2, Vector2.UP+Vector2.LEFT, Vector2.UP,
		Vector2.LEFT*1.5+Vector2.UP*1.5,
		Vector2.LEFT*1.5+Vector2.DOWN*1.5, Vector2.DOWN, Vector2.DOWN/2+Vector2.LEFT, Vector2.LEFT/2+Vector2.UP/2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN*2, Vector2.LEFT+Vector2.UP/2, Vector2.DOWN*2+Vector2.LEFT*1.5, Vector2.LEFT/2, Vector2.UP*2.5+Vector2.LEFT*1.5, Vector2.LEFT*2+Vector2.UP, Vector2.UP, Vector2.UP+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT*2+Vector2.UP*2, Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT,
		Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*2+Vector2.RIGHT/2, Vector2.DOWN*2+Vector2.LEFT*1.5, Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*1.5, Vector2.LEFT, Vector2.LEFT*1+Vector2.DOWN*2.5,
		Vector2.RIGHT*3+Vector2.DOWN, Vector2.DOWN*2+Vector2.RIGHT, Vector2.DOWN*6+Vector2.RIGHT*7, Vector2.DOWN*2+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.DOWN*2, Vector2.DOWN*5+Vector2.RIGHT*4, Vector2.DOWN+Vector2.RIGHT*3, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.RIGHT*4+Vector2.UP, Vector2.DOWN*2+Vector2.RIGHT*2
	])
	states.append(lazio)

	var abruzzo = state_supplier.new("Abruzzo", Vector2.ZERO+152*Vector2.RIGHT+43*Vector2.DOWN, [
		Vector2.LEFT*3+Vector2.DOWN*3.5, Vector2.LEFT/2+Vector2.DOWN*1.5, Vector2.LEFT, Vector2.LEFT+Vector2.UP*1.5, Vector2.LEFT*1.5+Vector2.UP/2, Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.DOWN*1.5, 
		Vector2.LEFT*4+Vector2.UP*1.5, Vector2.UP+Vector2.LEFT/2, Vector2.LEFT, Vector2.DOWN+Vector2.LEFT/2, Vector2.LEFT, Vector2.UP+Vector2.LEFT, Vector2.LEFT*1.5+Vector2.UP, Vector2.UP*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP, Vector2.UP/2+Vector2.LEFT/2, Vector2.LEFT*2+Vector2.UP/2, Vector2.UP*2+Vector2.RIGHT*1.5, Vector2.RIGHT*2+Vector2.DOWN/2, Vector2.RIGHT*1.5+Vector2.UP, Vector2.UP*2+Vector2.LEFT*2, Vector2.UP*4+Vector2.LEFT, Vector2.UP*1.5, Vector2.RIGHT*4+Vector2.UP/2, Vector2.UP+Vector2.LEFT, Vector2.UP,
		
		Vector2.RIGHT*2, Vector2.RIGHT+Vector2.UP*2, Vector2.RIGHT*2, Vector2.RIGHT+Vector2.UP*2, Vector2.RIGHT*3,
		Vector2.LEFT/2+Vector2.DOWN*2, Vector2.RIGHT*2+Vector2.DOWN*4
		
	])
	states.append(abruzzo)
	
	var umbria = state_supplier.new("Umbria", Vector2.ZERO+129.5*Vector2.RIGHT+29*Vector2.DOWN, [
		Vector2.LEFT*1.5+Vector2.DOWN*1.5, Vector2.DOWN, Vector2.DOWN/2+Vector2.LEFT, Vector2.LEFT/2+Vector2.UP/2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN*2, Vector2.LEFT+Vector2.UP/2, Vector2.DOWN*2+Vector2.LEFT*1.5, Vector2.LEFT/2, Vector2.UP*2.5+Vector2.LEFT*1.5, Vector2.LEFT*2+Vector2.UP, Vector2.UP, Vector2.UP+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT*2+Vector2.UP*2, Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT,
		Vector2.RIGHT*1+Vector2.UP*4, Vector2.LEFT+Vector2.UP, Vector2.UP*3+Vector2.RIGHT*2, Vector2.RIGHT, Vector2.RIGHT+Vector2.UP, Vector2.UP*2+Vector2.LEFT*2, Vector2.RIGHT+Vector2.UP*2,  Vector2.UP*2+Vector2.RIGHT*2, 
		Vector2.RIGHT*1.5, Vector2.DOWN+Vector2.LEFT/2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT, Vector2.RIGHT*2+Vector2.DOWN, Vector2.RIGHT*2, Vector2.DOWN*4+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN+Vector2.LEFT, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.DOWN*3, Vector2.RIGHT*2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT*1.5
	])
	states.append(umbria)
	
	var marche = state_supplier.new("Marche", Vector2.ZERO+115*Vector2.RIGHT+12.5*Vector2.DOWN, [
		Vector2.RIGHT*1.5, Vector2.DOWN+Vector2.LEFT/2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT, Vector2.RIGHT*2+Vector2.DOWN, Vector2.RIGHT*2, Vector2.DOWN*4+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN+Vector2.LEFT, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.DOWN*3, Vector2.RIGHT*2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT*1.5, Vector2.DOWN*2, Vector2.RIGHT*1.5+Vector2.DOWN,
		Vector2.RIGHT*2, Vector2.RIGHT+Vector2.UP*2, Vector2.RIGHT*2, Vector2.RIGHT+Vector2.UP*2, Vector2.RIGHT*3,
		Vector2.LEFT*2+Vector2.UP*4, Vector2.UP*8+Vector2.LEFT*2, Vector2.LEFT*4+Vector2.UP*2, Vector2.LEFT*9+Vector2.UP*7,
		Vector2.LEFT+Vector2.DOWN*2.5, Vector2.LEFT, Vector2.LEFT+Vector2.UP, Vector2.LEFT*3, Vector2.LEFT*1.5+Vector2.DOWN*2,
		Vector2.DOWN*1.5+Vector2.RIGHT*1.5, Vector2.LEFT*2+Vector2.DOWN
	])
	states.append(marche)

	
	print("Initializing states:")
	for state in states:
		print(state.id)
		add_child(state.gen_area())
	font = commons.font()
	#update() # Replace with function body.

func define_countries():
	var rome = country_supplier.new("Rome",["Sicily","Calabria","Basilicata","Apulia","Campania","Molise","Lazio","Abruzzo","Umbria","Marche"])
	countries.append(rome)


func _input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if $Menu.visible:
			$Menu.restart()
		else:
			$Menu.show()
	
	if event is InputEventMouseMotion:
		#print("hover")
		reset_hover()

func reset_selection():
	for state in states:
		state.selected = false
func reset_hover():
	for state in states:
		state.hovered = false

func redraw_focus():
	for state in states:
		if state.selected:
			state.area.get_children()[1].color = commons.select_color
		elif state.hovered:
			state.area.get_children()[1].color = commons.hover_color
		else:
			state.area.get_children()[1].color = commons.default_state_color


func _process(delta):
	if time:
		$ui/Time/Date.text = time.format()
