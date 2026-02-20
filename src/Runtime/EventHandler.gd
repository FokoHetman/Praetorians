extends Node
class_name EventHandler


var scheduled = []

func _ready():
	get_node("/root/Map/GameTime").daytick.connect(daytick)

func daytick(tick): # each day
	for i in range(len(scheduled)):
		if scheduled[i].trigger_on >= tick:
			scheduled[i].trigger()
			scheduled.remove_at(i)
