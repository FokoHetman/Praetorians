extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	self.theme = Theme.new()
	self.theme.set_color("Button1Off", "", Color.DIM_GRAY)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _pressed():
	print('hi')
