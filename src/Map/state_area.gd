@tool
extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var font
var fparent

var commons = load("res://src/utils/commons.gd")

func _init(parent=null):
	fparent = parent

func double_click():
	get_node("/root/Map").toggleView(commons.VIEWS.PROVINCE, fparent)

func _input_event(viewport, event, shape_idx):
	if not get_node("/root/Map").camera_locked:
		if event is InputEventMouseMotion:
			#print("hover")
			get_node("/root/Map").reset_hover()
			fparent.hovered = true
			get_node("/root/Map").redraw_focus()
			pass
		if (event is InputEventMouseButton && event.pressed):
			if event.button_index == MOUSE_BUTTON_LEFT:
				#open state info
				get_node("/root/Map").toggleMenu(commons.Menus.ProvinceInfo, fparent)
				if fparent.selected:
					get_node("/root/Map").reset_selection()
					double_click()
					return
				get_node("/root/Map").reset_selection()
				#get_node("/root/Map/ui/state_info_ui").show()
				fparent.selected = true
				get_node("/root/Map").redraw_focus()
			elif event.button_index == MOUSE_BUTTON_RIGHT:
				#open country info
				if fparent.governor:
					print(fparent.governor.country)
					get_node("/root/Map").toggleMenu(commons.Menus.CountryInfo, fparent.governor.country)



func _ready():
	input_pickable = true
	font = commons.font()
