extends Button

func _ready():
	self.theme = Theme.new()
	self.theme.set_color("Button1Off", "", Color.DIM_GRAY)

func _pressed():
	var time = get_node('/root/Menu/GameTime')
	if !time.speed == 20:
		time.speed += 1
	print(time.speed)
