extends Button

func _ready() -> void:
	self.text = 'play'

func _pressed():
	var time = get_node('/root/Map/GameTime')
	time.paused = !time.paused
	if time.paused:
		self.text = 'play'
	else:
		self.text = 'stop'
	print('paused: ',time.paused)
