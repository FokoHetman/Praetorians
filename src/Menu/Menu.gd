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

# probably make it per country-ish?
var CHARACTER_POOL = []


var savedCameraPos
var savedCameraZoom
var defaultCameraPosition
func toggleView(viewc, province=null):
	# TODO: disable UI, make the province view.
	if view == commons.VIEWS.MAP:
		savedCameraPos = $Camera2D.position
		savedCameraZoom = $Camera2D.zoom
	view = viewc
	match view:
		commons.VIEWS.PROVINCE:
			$Camera2D.position = defaultCameraPosition
			$Camera2D.zoom = Vector2(1,1)
			toggleUI()
			spawnProvinceView(province)
			queue_redraw()
			$States.visible = false
			pass
		commons.VIEWS.MAP:
			$Camera2D.position = savedCameraPos
			$Camera2D.zoom = savedCameraZoom
			toggleUI()
			toggleMap()
	pass


func toggleUI():
	$ui.visible = not $ui.visible


var province_view = preload("res://scenes/Province.tscn").instantiate()
func spawnProvinceView(province):
	province_view.province = province
	add_child(province_view)
	province_view.redraw()
	#get_tree().change_scene_to_packed(province_view)

func draw_state(state):
	var last_line = state.position
	for line in state.curves:
		var color = border_color
		draw_line(last_line, last_line+line, color, border_line_width)
		last_line = last_line+line
	draw_line(last_line, state.position, border_color, border_line_width)
	print("Drawn: ", state.id)

func _draw() -> void:
	match view:
		commons.VIEWS.MAP:
			draw_line(Vector2.ZERO, Vector2.DOWN*300, Color.AQUA, 0)
	
			draw_string(font, Vector2.ZERO+Vector2.DOWN*30+Vector2.LEFT*50, 'Ave Caesar!')
			print("Drawing states...")
			for state in states:
				draw_state(state)


func disintegrate(pos):
	return pos + Vector2((randi()% 20-2)*10, (randi()% 20-2)*10)

func _ready():
	var player_scene = load("res://scenes/Player.tscn").instantiate()
	get_tree().root.add_child.call_deferred(player_scene)
	savedCameraPos = $Camera2D.position
	defaultCameraPosition = savedCameraPos
	savedCameraZoom = $Camera2D.zoom
	toggleUI()
	var preferred_language = OS.get_locale_language()
	TranslationServer.set_locale(preferred_language)

	time.name = 'GameTime'
	add_child(time)
	toggleView(commons.VIEWS.MAP)
	define_states()
	define_countries()
func toggleMap(): # not actually a toggle
	$ui/Time.position.x = get_viewport().size.x - 0.1*get_viewport().size.x
	$ui/Time.position.y = get_viewport().size.y - 0.9*get_viewport().size.y
	$ui/Time.scale.x = get_viewport().size.x / 1920 * $ui/Time.scale.x
	$ui/Time.scale.y = get_viewport().size.y / 1080 * $ui/Time.scale.y
	
	$States.visible = true
	queue_redraw()



func define_states():
	# TODO: make it read from json instead. Data separation ykwim
	var sicily = state_supplier.new(1, Vector2.ZERO+ 118*Vector2.DOWN + 122*Vector2.RIGHT, [Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*4+Vector2.LEFT*2, Vector2.DOWN*4+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.DOWN*3, Vector2.RIGHT*4, Vector2.RIGHT*5+Vector2.DOWN*2, Vector2.DOWN*2+Vector2.RIGHT, Vector2.RIGHT*4+Vector2.DOWN*3, Vector2.DOWN*2+Vector2.RIGHT*4,
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

	var calabria = state_supplier.new(2, Vector2.ZERO+ 119*Vector2.DOWN + 165*Vector2.RIGHT, [Vector2.DOWN*2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT*4, Vector2.UP+Vector2.RIGHT*2, Vector2.UP*5+Vector2.RIGHT, Vector2.RIGHT*5+Vector2.UP*2, Vector2.UP*8+Vector2.DOWN,
		Vector2.RIGHT*5+Vector2.UP*4, Vector2.RIGHT*4+Vector2.DOWN, Vector2.RIGHT+Vector2.UP*2, Vector2.UP*2+Vector2.LEFT, Vector2.UP*5+Vector2.RIGHT, Vector2.LEFT*4+Vector2.UP*4, Vector2.LEFT*5+Vector2.UP, Vector2.UP*4+Vector2.LEFT, Vector2.RIGHT+Vector2.UP, Vector2.UP*2, Vector2.UP*3+Vector2.RIGHT*2,
		Vector2.LEFT*3+Vector2.UP, Vector2.DOWN*2+Vector2.LEFT*2, Vector2.DOWN*3+Vector2.LEFT, Vector2.LEFT+Vector2.UP, Vector2.DOWN+Vector2.LEFT*2, Vector2.LEFT*3+Vector2.UP*2, Vector2.LEFT*2, Vector2.LEFT+Vector2.DOWN,
		Vector2.DOWN*4+Vector2.RIGHT, Vector2.RIGHT*4+Vector2.DOWN*8, Vector2.LEFT+Vector2.DOWN*2, Vector2.DOWN*8+Vector2.RIGHT*3, Vector2.LEFT*5+Vector2.DOWN*3, Vector2.DOWN*4+Vector2.RIGHT])
	states.append(calabria)
	
	
	var basilicata = state_supplier.new(3, Vector2.ZERO + 180*Vector2.RIGHT + 80*Vector2.DOWN, [Vector2.UP*5+Vector2.RIGHT*3, Vector2.LEFT+Vector2.UP, Vector2.UP+2*Vector2.LEFT, Vector2.UP+Vector2.RIGHT, Vector2.UP*4+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3+Vector2.UP*2, Vector2.UP*2+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.UP, Vector2.UP+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP*2.5, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3.5,
		Vector2.DOWN*2+Vector2.RIGHT, Vector2.DOWN*2+Vector2.LEFT*2, Vector2.LEFT*1.5, Vector2.DOWN*2, Vector2.DOWN*2.5+Vector2.RIGHT*1.5, Vector2.DOWN, Vector2.RIGHT+Vector2.DOWN, Vector2.DOWN*0.5, Vector2.DOWN*5+Vector2.RIGHT*4, Vector2.DOWN*4+Vector2.LEFT*3, Vector2.DOWN*2+Vector2.RIGHT*2,
		 Vector2.UP*0.5,
		 Vector2.RIGHT+Vector2.UP, Vector2.RIGHT*2, Vector2.RIGHT*3+Vector2.DOWN*2, Vector2.UP+Vector2.RIGHT*2, Vector2.RIGHT+Vector2.DOWN, Vector2.UP*3+Vector2.RIGHT
		])
	states.append(basilicata)

	var apulia = state_supplier.new(4, Vector2.ZERO + 183*Vector2.RIGHT + 75*Vector2.DOWN, [Vector2.LEFT+Vector2.UP, Vector2.UP+2*Vector2.LEFT, Vector2.UP+Vector2.RIGHT, Vector2.UP*4+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3+Vector2.UP*2, Vector2.UP*2+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT+Vector2.UP, Vector2.UP+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP*2.5, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT*3.5,
		Vector2.LEFT+Vector2.DOWN/2, Vector2.LEFT+Vector2.UP, Vector2.LEFT*1.5+Vector2.DOWN/2, Vector2.UP+Vector2.LEFT, Vector2.UP*2+Vector2.RIGHT/2, Vector2.UP+Vector2.LEFT, Vector2.LEFT, Vector2.LEFT+Vector2.UP, Vector2.UP+Vector2.RIGHT, Vector2.LEFT*2+Vector2.UP*2,
		Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.RIGHT, Vector2.UP+Vector2.RIGHT*2, Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.UP*2,
		Vector2.RIGHT*4+Vector2.DOWN*1.5, Vector2.RIGHT*6+Vector2.UP/2, Vector2.UP+Vector2.RIGHT, Vector2.RIGHT*3, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.DOWN*2, Vector2.DOWN*2+Vector2.LEFT*4, Vector2.DOWN*3, Vector2.DOWN*6+Vector2.RIGHT*12, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN*2+Vector2.RIGHT*6, Vector2.DOWN*4+Vector2.RIGHT*4, Vector2.DOWN*2+Vector2.RIGHT*6, Vector2.DOWN+Vector2.RIGHT*1.5, Vector2.DOWN*4+Vector2.RIGHT*1.5, Vector2.RIGHT*4+Vector2.DOWN*2, Vector2.DOWN, Vector2.DOWN*4+Vector2.RIGHT*2, Vector2.DOWN*4+Vector2.LEFT*2, Vector2.DOWN*2, Vector2.LEFT*2, Vector2.UP*3+Vector2.LEFT*4, Vector2.UP+Vector2.LEFT/2, Vector2.UP, Vector2.RIGHT+Vector2.UP, Vector2.UP*3.5+Vector2.LEFT*3, Vector2.UP*2+Vector2.LEFT*8, Vector2.UP*2+Vector2.LEFT*2, Vector2.LEFT*2
	])
	states.append(apulia)
	var campania = state_supplier.new(5, Vector2.ZERO + 163*Vector2.RIGHT+61.5*Vector2.DOWN, [
		Vector2.DOWN*2+Vector2.RIGHT, Vector2.DOWN*2+Vector2.LEFT*2, Vector2.LEFT*1.5, Vector2.DOWN*2, Vector2.DOWN*2.5+Vector2.RIGHT*1.5, Vector2.DOWN, Vector2.RIGHT+Vector2.DOWN, Vector2.DOWN*0.5, Vector2.DOWN*5+Vector2.RIGHT*4, Vector2.DOWN*4+Vector2.LEFT*3,
		Vector2.UP+Vector2.LEFT, Vector2.LEFT*3+Vector2.DOWN*2, Vector2.UP*3+Vector2.LEFT*3, Vector2.LEFT*3+Vector2.UP, Vector2.LEFT/2+Vector2.UP*1.5, Vector2.UP*2+Vector2.RIGHT*2, Vector2.UP*5+Vector2.LEFT*4, Vector2.LEFT*6+Vector2.DOWN, Vector2.UP*1, Vector2.UP+Vector2.RIGHT*2, Vector2.UP, Vector2.LEFT*3+Vector2.UP, Vector2.LEFT*3, Vector2.UP*8+Vector2.LEFT*5,
		Vector2.UP*2+Vector2.RIGHT*2, Vector2.UP*2, Vector2.UP+Vector2.RIGHT, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.RIGHT/2+Vector2.UP, Vector2.UP*1.5, Vector2.RIGHT*2, Vector2.RIGHT*5+Vector2.DOWN*2, Vector2.RIGHT*2, Vector2.UP/2+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.UP,
 		Vector2.UP/2, Vector2.RIGHT*2+Vector2.DOWN*2, Vector2.DOWN+Vector2.LEFT, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN*2+Vector2.LEFT/2, Vector2.DOWN+Vector2.RIGHT, Vector2.RIGHT*1.5+Vector2.UP/2, Vector2.RIGHT+Vector2.DOWN,Vector2.RIGHT+Vector2.UP/2,
	])
	states.append(campania)
	
	var molise = state_supplier.new(6, Vector2.ZERO+139.5*Vector2.RIGHT+54*Vector2.DOWN, [
		Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.RIGHT/2+Vector2.UP, Vector2.UP*1.5, Vector2.RIGHT*2, Vector2.RIGHT*5+Vector2.DOWN*2, Vector2.RIGHT*2, Vector2.UP/2+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.UP,
		Vector2.UP/2, 	Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.RIGHT, Vector2.UP+Vector2.RIGHT*2, Vector2.LEFT+Vector2.UP, Vector2.UP*2+Vector2.RIGHT/2, Vector2.UP*2,
		Vector2.LEFT*3+Vector2.UP*1.5, Vector2.LEFT*2, 
		Vector2.LEFT*3+Vector2.DOWN*3.5, Vector2.LEFT/2+Vector2.DOWN*1.5, Vector2.LEFT, Vector2.LEFT+Vector2.UP*1.5, Vector2.LEFT*1.5+Vector2.UP/2, Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.DOWN*1.5, 
		Vector2.DOWN*3+Vector2.RIGHT/2
	])
	states.append(molise)
	
	var lazio = state_supplier.new(7, Vector2.ZERO+136.5*Vector2.RIGHT+59*Vector2.DOWN, [
		Vector2.UP*2+Vector2.RIGHT*2, Vector2.UP*2, Vector2.UP+Vector2.RIGHT,
		Vector2.UP+Vector2.RIGHT*1.5, Vector2.UP*3+Vector2.LEFT/2,
		Vector2.LEFT*4+Vector2.UP*1.5, Vector2.UP+Vector2.LEFT/2, Vector2.LEFT, Vector2.DOWN+Vector2.LEFT/2, Vector2.LEFT, Vector2.UP+Vector2.LEFT, Vector2.LEFT*1.5+Vector2.UP, Vector2.UP*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP, Vector2.UP/2+Vector2.LEFT/2, Vector2.LEFT*2+Vector2.UP/2, Vector2.UP*2+Vector2.RIGHT*1.5, Vector2.RIGHT*2+Vector2.DOWN/2, Vector2.RIGHT*1.5+Vector2.UP, Vector2.UP*2+Vector2.LEFT*2, Vector2.UP*4+Vector2.LEFT, Vector2.UP*1.5, Vector2.RIGHT*4+Vector2.UP/2, Vector2.UP+Vector2.LEFT, Vector2.UP,
		Vector2.LEFT*1.5+Vector2.UP*1.5,
		Vector2.LEFT*1.5+Vector2.DOWN*1.5, Vector2.DOWN, Vector2.DOWN/2+Vector2.LEFT, Vector2.LEFT/2+Vector2.UP/2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN*2, Vector2.LEFT+Vector2.UP/2, Vector2.DOWN*2+Vector2.LEFT*1.5, Vector2.LEFT/2, Vector2.UP*2.5+Vector2.LEFT*1.5, Vector2.LEFT*2+Vector2.UP, Vector2.UP, Vector2.UP+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT*2+Vector2.UP*2, Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT,
		Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*2+Vector2.RIGHT/2, Vector2.DOWN*2+Vector2.LEFT*1.5, Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*1.5, Vector2.LEFT, Vector2.LEFT*1+Vector2.DOWN*2.5,
		Vector2.RIGHT*3+Vector2.DOWN, Vector2.DOWN*2+Vector2.RIGHT, Vector2.DOWN*6+Vector2.RIGHT*7, Vector2.DOWN*2+Vector2.RIGHT, Vector2.RIGHT*3+Vector2.DOWN*2, Vector2.DOWN*5+Vector2.RIGHT*4, Vector2.DOWN+Vector2.RIGHT*3, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.RIGHT*4+Vector2.UP, Vector2.DOWN*2+Vector2.RIGHT*2
	])
	states.append(lazio)

	var abruzzo = state_supplier.new(8, Vector2.ZERO+152*Vector2.RIGHT+43*Vector2.DOWN, [
		Vector2.LEFT*3+Vector2.DOWN*3.5, Vector2.LEFT/2+Vector2.DOWN*1.5, Vector2.LEFT, Vector2.LEFT+Vector2.UP*1.5, Vector2.LEFT*1.5+Vector2.UP/2, Vector2.LEFT*2+Vector2.DOWN, Vector2.DOWN*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.DOWN*1.5, 
		Vector2.LEFT*4+Vector2.UP*1.5, Vector2.UP+Vector2.LEFT/2, Vector2.LEFT, Vector2.DOWN+Vector2.LEFT/2, Vector2.LEFT, Vector2.UP+Vector2.LEFT, Vector2.LEFT*1.5+Vector2.UP, Vector2.UP*1.5+Vector2.RIGHT/2, Vector2.LEFT*3+Vector2.UP, Vector2.UP/2+Vector2.LEFT/2, Vector2.LEFT*2+Vector2.UP/2, Vector2.UP*2+Vector2.RIGHT*1.5, Vector2.RIGHT*2+Vector2.DOWN/2, Vector2.RIGHT*1.5+Vector2.UP, Vector2.UP*2+Vector2.LEFT*2, Vector2.UP*4+Vector2.LEFT, Vector2.UP*1.5, Vector2.RIGHT*4+Vector2.UP/2, Vector2.UP+Vector2.LEFT, Vector2.UP,
		
		Vector2.RIGHT*2, Vector2.RIGHT+Vector2.UP*2, Vector2.RIGHT*2, Vector2.RIGHT+Vector2.UP*2, Vector2.RIGHT*3,
		Vector2.LEFT/2+Vector2.DOWN*2, Vector2.RIGHT*2+Vector2.DOWN*4
		
	])
	states.append(abruzzo)
	
	var umbria = state_supplier.new(9, Vector2.ZERO+129.5*Vector2.RIGHT+29*Vector2.DOWN, [
		Vector2.LEFT*1.5+Vector2.DOWN*1.5, Vector2.DOWN, Vector2.DOWN/2+Vector2.LEFT, Vector2.LEFT/2+Vector2.UP/2, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN, Vector2.LEFT, Vector2.LEFT+Vector2.DOWN*2, Vector2.LEFT+Vector2.UP/2, Vector2.DOWN*2+Vector2.LEFT*1.5, Vector2.LEFT/2, Vector2.UP*2.5+Vector2.LEFT*1.5, Vector2.LEFT*2+Vector2.UP, Vector2.UP, Vector2.UP+Vector2.LEFT, Vector2.LEFT*2, Vector2.LEFT*2+Vector2.UP*2, Vector2.UP+Vector2.RIGHT, Vector2.UP+Vector2.LEFT,
		Vector2.RIGHT*1+Vector2.UP*4, Vector2.LEFT+Vector2.UP, Vector2.UP*3+Vector2.RIGHT*2, Vector2.RIGHT, Vector2.RIGHT+Vector2.UP, Vector2.UP*2+Vector2.LEFT*2, Vector2.RIGHT+Vector2.UP*2,  Vector2.UP*2+Vector2.RIGHT*2, 
		Vector2.RIGHT*1.5, Vector2.DOWN+Vector2.LEFT/2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT, Vector2.RIGHT*2+Vector2.DOWN, Vector2.RIGHT*2, Vector2.DOWN*4+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.DOWN+Vector2.LEFT, Vector2.DOWN*2+Vector2.RIGHT*2, Vector2.DOWN*3, Vector2.RIGHT*2, Vector2.RIGHT+Vector2.DOWN, Vector2.RIGHT*1.5
	])
	states.append(umbria)
	
	var marche = state_supplier.new(10, Vector2.ZERO+115*Vector2.RIGHT+12.5*Vector2.DOWN, [
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
		$States.add_child(state.gen_area())
	font = commons.font()
	#update() # Replace with function body.

func state_from_id(id: int):
	for i in states:
		if i.id == id:
			return i
func define_countries():
	var loyalists = Faction.new(1, [])

	var romulus_family = Family.new("Mars")
	var king = Character.new("Romulus", "", romulus_family, [], 1)

	var rome = Country.new(1, king, [state_from_id(7)], [loyalists])


	rome.states[0].governor = king
	rome.create_legion(rome.states[0], rome.factions[0], 
		[Cohort.new(commons.COHORT_TYPES.INFANTRY, Vector2(10, 10)), Cohort.new(commons.COHORT_TYPES.INFANTRY, Vector2(-10, 10)), 
		 Cohort.new(commons.COHORT_TYPES.ARCHERS, Vector2(10, -10)), Cohort.new(commons.COHORT_TYPES.ARCHERS, Vector2(-10, -10))])
	countries.append(rome)
	redraw_gametime()
	#utils.get_stance(loyalists, loyalists)

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



### WHO IS  THE PLAYER?
# for now - player is handled as the chosen country's ruler.



# redraw based on things such as legion positions etc
func redraw_gametime():
	pass
	
	for country in countries:
		for army in country.armies:
			var box_pos = army.state.position + army.position # DONE: offset not by center, but by accurate position of the army
			var object = army.generate_display_object(countries[0].ruler) # rome's ruler
			object.position = box_pos
			$States.add_child(object)
			print(object)
			


# this is dumb.
func _process(delta):
	if time:
		$ui/Time/Date.text = time.format()
