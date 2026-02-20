extends Camera2D

var commons = load("res://src/utils/commons.gd")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var zoom_acceleration = 0.1
var acceleration = 0
var slowness = 0.75
var max_acc = 100
var speed = 0.05
var min_zoom = 1
var max_zoom = 10

var dead_zone
var zero_pos = Vector2(0,0)

var off_acc_x = 1
var off_acc_y = 0
var border_range = Vector2(250, 50)
var d_speed = 15
var bg_size = null

var mode = commons.VIEWS.MAP

var border_size = 25

signal zoom_changed(new_zoom)

func _process(delta):
	update_lims()
	match get_node("/root/Map").view:
		_:
			if get_node("/root/Map").camera_locked:
				return 
			var move_speed = d_speed / zoom.x * delta * 100
			var viewPortMousePos = get_viewport().get_mouse_position()
			var viewport = get_viewport()
			#if not dead_zone.has_point(viewPortMousePos):
			if moving_scroll[0]:
				#var away = viewPortMousePos - moving_scroll[1]
				position = position.move_toward(moving_scroll[1] - viewPortMousePos, move_speed*10)
				return
			if viewPortMousePos.x > viewport.size.x - border_size or viewPortMousePos.x < border_size:
				position = position.move_toward(Vector2((-get_viewport().size/2)) + (viewPortMousePos), move_speed)	
			if viewPortMousePos.y > viewport.size.y - border_size or viewPortMousePos.y < border_size:
				position = position.move_toward(Vector2(-get_viewport().size/2) + (viewPortMousePos), move_speed)	
			
			acceleration = clamp(acceleration, -max_acc, max_acc)

			if acceleration>0:
				acceleration = clamp(acceleration - slowness*delta, -max_acc, acceleration)
			elif acceleration<0:
				acceleration = clamp(acceleration + slowness*delta, acceleration, max_acc)
			if zoom.x==clamp(zoom.x-acceleration*speed, min_zoom, max_zoom) or zoom.y==clamp(zoom.y-acceleration*speed, min_zoom, max_zoom): #resetting acceleration on reaching max
				acceleration=0
			var old_zoom := zoom
			zoom = Vector2(clamp(zoom.x-acceleration*speed, min_zoom, max_zoom), clamp(zoom.y-acceleration*speed, min_zoom, max_zoom))
			if zoom != old_zoom:
				zoom_changed.emit(zoom)
			if Input.is_action_pressed("ui_down"):
				position = position.move_toward(position + Vector2(0, 50), d_speed / zoom.x * delta * 100)
			if Input.is_action_pressed("ui_up"):
				position = position.move_toward(position - Vector2(0, 50), d_speed / zoom.x * delta * 100)
			if Input.is_action_pressed("ui_right"):
				position = position.move_toward(position + Vector2(50, 0), d_speed / zoom.x * delta * 100)
			if Input.is_action_pressed("ui_left"):
				position = position.move_toward(position - Vector2(50, 0), d_speed / zoom.x * delta * 100)


### this indicates whether user is using scroll to move the map, also gives starting position of the movement.
var moving_scroll = [false, Vector2(0,0)]

func _input(event):
	match get_node("/root/Map").view:
		_:
			if get_node("/root/Map").camera_locked:
				return
			
			if event is InputEventMouseButton:
				if event.is_pressed():
					if event.button_index == MOUSE_BUTTON_WHEEL_UP:
						acceleration-=0.1
					if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
						acceleration+=0.1
					if event.button_index == MOUSE_BUTTON_MIDDLE:
						moving_scroll = [true, event.position]
				if event.is_released() and event.button_index == MOUSE_BUTTON_MIDDLE:
					moving_scroll = [false, Vector2(0,0)]
var bg
func _ready():
	bg = get_node("/root/Map/Background")
	update_lims()
	print(mode)


func update_lims():
	var v_size = get_viewport().size
	var dead_zone_size = v_size * 0.66
	var dead_zone_position = (Vector2(v_size) - dead_zone_size) / 2  # Center it
	dead_zone = Rect2(dead_zone_position, dead_zone_size)

	match get_node("/root/Map").view:
		commons.VIEWS.MAP:
			border_range = Vector2(v_size.x/10, v_size.y/10)
			bg_size = bg.scale * bg.size
			var pos = bg.position
			limit_left = pos.x
			limit_right = pos.x + bg_size.x
			limit_top = pos.y
			limit_bottom = pos.y + bg_size.y
		commons.VIEWS.PROVINCE:
			pass
