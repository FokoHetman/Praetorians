extends Node
class_name Centuria

var centurion # dangerous zone.
var optio

var rows = 10
var columns = 8


var manpower = rows * columns
var support  = 20 # non-combatant auxillia within the centuria


func _init(ccenturion=null, ooptio=null):
	if ccenturion:
		self.centurion = ccenturion
	else:
		self.centurion = Character.random_military()
	if ooptio:
		self.optio = ooptio
	else:
		self.optio = Character.random_military()

func ch_leader(new_leader: Character):
	centurion = new_leader
