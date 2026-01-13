extends Container

var time: GameTime

func _ready():
	self.time = get_node("/root/Map").time
	$Texture/Inc.connect("button_up", Callable(time.inc))
	$Texture/Dec.connect("button_up", Callable(time.dec))
	$Texture/State.connect("button_up", Callable(time.toggle))
	self.time.redraw.connect(Callable(update))
	self.time.speed_redraw.connect(Callable(update_texture))
	self.time.state_redraw.connect(Callable(update_state))
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
