extends Node
class_name EventHandler


var time: GameTime = null
var scheduled = []

func _init(time):
	self.time = time
	self.time.daytick.connect(daytick)

func daytick(tick): # each day
	for i in range(len(scheduled)):
		if scheduled[i].trigger_on >= tick:
			scheduled[i].trigger()
			scheduled.remove_at(i)
