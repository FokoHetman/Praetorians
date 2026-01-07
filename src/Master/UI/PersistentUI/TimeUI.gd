extends Container

var time

func _ready():
	time = get_node("/root/Map").time
	$Texture/Inc.connect("button_up", Callable(time.inc))
	$Texture/Dec.connect("button_up", Callable(time.dec))
	$Texture/State.connect("button_up", Callable(time.toggle))
	time.redraw_hooks.append(Callable(update))
	time.speed_redraw_hooks.append(Callable(update_texture))
	time.state_redraw_hooks.append(Callable(update_state))
	update_state(true)

func update(x):
	$Texture/Date.text = x

func update_texture(x):
	$Texture.texture = load(str("res://assets/textures/tablica/roman_"+str(x)+".png"))

func update_state(x):
	if x:
		$Texture/State.text = "play"
	else:
		$Texture/State.text = "stop"
