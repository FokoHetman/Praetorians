extends Node
class_name Centuria

var centurion # dangerous zone.

func _init(ccenturion=null):
	if ccenturion:
		centurion=ccenturion
	else:
		centurion = Character.random_military()
func ch_leader(new_leader: Character):
	centurion = new_leader
