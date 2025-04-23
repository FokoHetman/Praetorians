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
			#open state info
			get_node("/root/Menu/ui/state_info_ui/font-resize/state_name").text = fparent.id
			get_node("/root/Menu/ui/state_info_ui/font-resize/state_info").text = 'Type: '+ str(fparent.type) +'\nPopulation: '+ str(fparent.population)+ '\nMan power: '+ str(fparent.man_power) +'\nCities number: '+ str(fparent.cities_number)
			get_node("/root/Menu/ui/country_info_ui").hide()
			get_node("/root/Menu/ui/state_info_ui").show()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			#open country info
			for i in get_node('/root/Menu').countries:
				if fparent.id in i.states:
					print(fparent.id,' -> ',i.id)
					get_node("/root/Menu/ui/country_info_ui/font-resize/country_name").text = i.id
					get_node("/root/Menu/ui/country_info_ui/font-resize/country_info").text = "Nothing about it"
					get_node("/root/Menu/ui/state_info_ui").hide()
					get_node("/root/Menu/ui/country_info_ui").show()
					break



func _ready():
	input_pickable = true
	font = FontFile.new()
	font.font_data = load("res://DaysOne.ttf")
