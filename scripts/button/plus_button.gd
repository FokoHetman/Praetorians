extends Button

var roman = []

func _ready():
	for i in range(5):
		roman.append(load(str("res://textures/tablica/roman_"+str(i+1)+".png")))
	self.theme = Theme.new()
	self.theme.set_color("Button1Off", "", Color.DIM_GRAY)

func _pressed():
	var time = get_node('/root/Menu/GameTime')
	if !time.speed == 5:
		time.speed += 1
		get_node("/root/Menu/ui/Time").texture = roman[time.speed - 1]
	print(time.speed)
