extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var zoom_acceleration = 0.1
var acceleration = 0
var slowness = 0.25
var max_acc = 100
var speed = 0.05
var min_zoom = 1
var max_zoom = 10

var dead_zone = 500 # never used?
var zero_pos = Vector2(0,0)

var off_acc_x = 1
var off_acc_y = 0
var border_range = Vector2(200, 75)
var d_speed = 8
var bg_size = null
func _process(delta):
	var move_speed = d_speed / zoom.x
	var viewPortMousePos = get_viewport().get_mouse_position()

	if get_viewport().get_mouse_position().x<border_range.x or (get_viewport().size.x-get_viewport().get_mouse_position().x)<border_range.x:
		offset.x = offset.move_toward(Vector2((-get_viewport().size/2).x, (-get_viewport().size/2).y) + (viewPortMousePos), move_speed).x
		
	if get_viewport().get_mouse_position().y<border_range.y or (get_viewport().size.y-get_viewport().get_mouse_position().y)<border_range.y:
		offset.y = offset.move_toward(Vector2((-get_viewport().size/2).x, (-get_viewport().size/2).y) + (viewPortMousePos), move_speed).y
	
	#print(offset.x)
	if abs(offset.x) > (bg_size.x - bg_size.x/self.zoom.x) / (self.zoom.x *2):
		offset.x = sign(offset.x) * (bg_size.x - bg_size.x/self.zoom.x) / (self.zoom.x*2)
	#	print("block")
	
	if abs(offset.y) > (bg_size.y - (1/self.zoom.y) * bg_size.y) / self.zoom.y / 2:
		offset.y = sign(offset.y) * (bg_size.y - (1/self.zoom.y) * bg_size.y) / self.zoom.y / 2
		#print("block")
	
	
	acceleration= clamp(acceleration, -max_acc, max_acc)

	if acceleration>0:
		acceleration = clamp(acceleration - slowness*delta, -max_acc, acceleration)
	elif acceleration<0:
		acceleration = clamp(acceleration + slowness*delta, acceleration, max_acc)
	if zoom.x==clamp(zoom.x-acceleration*speed, min_zoom, max_zoom) or zoom.y==clamp(zoom.y-acceleration*speed, min_zoom, max_zoom): #resetting acceleration on reaching max
		acceleration=0
	zoom = Vector2(clamp(zoom.x-acceleration*speed, min_zoom, max_zoom), clamp(zoom.y-acceleration*speed, min_zoom, max_zoom))


func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				acceleration-=0.1
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				acceleration+=0.1



func _ready():
	bg_size = get_node("/root/Menu/Background").texture.get_size()
	pass
