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

			get_node("/root/Menu/ui/state_info_ui/font-resize/state_name").text = fparent.id
			pass
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			#open country info
			pass

# Called when the node enters the scene tree for the first time.
func _ready():
	input_pickable = true
	pass # Replace with function body.

	font = FontFile.new()
	font.font_data = load("res://DaysOne.ttf")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
