@tool
extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var font
var fparent

func _init(parent=null):
	fparent = parent

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		#print("hover")
		pass
	if (event is InputEventMouseButton && event.pressed):
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_node("/root/Menu/ui/state_info_ui/font-resize/state_name").text = str(fparent.id)
			get_node("/root/Menu/ui/state_info_ui/font-resize/state_info").text = 'Type: '+ str(fparent.type) +'\nPopulation: '+ str(fparent.population)+ '\nMan power: '+ str(fparent.man_power) +'\nCities number: '+ str(fparent.cities_number)
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			#open country info
			pass


func _ready():
	input_pickable = true
	font = FontFile.new()
	font.font_data = load("res://DaysOne.ttf")
