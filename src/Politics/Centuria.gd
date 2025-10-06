extends Node
class_name Centuria

var centurion # dangerous zone.

var rows = 10
var columns = 8


var manpower = rows * columns
var support  = 20 # non-combatant auxillia within the centuria


func _init(ccenturion=null):
	if ccenturion:
		centurion=ccenturion
	else:
		centurion = Character.random_military()
func ch_leader(new_leader: Character):
	centurion = new_leader
