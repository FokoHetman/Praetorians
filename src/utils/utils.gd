@tool
extends Node
class_name Utils


func correctify(position, arr) -> Array:
	var last_val = position
	var n_arr = [last_val]
	for i in arr:
		n_arr.append(last_val+i)
		last_val = last_val+i
	return n_arr
func map_pos(position, arr) -> Array:
	var n_arr = []
	for i in arr:
		n_arr.append(-(Vector2.ZERO+position+i))
	return n_arr

var state = load("res://src/State/state.gd")
func create_state(id, pos, curves):
	var cstate = state.new(id,pos,curves)
	cstate.id = id
	cstate.position = pos
	cstate.curves = curves
	return cstate

func roof(x):
	if x > round(x):
		return round(x)+1
	else:
		return round(x)

func get_center(curves):
	var X = 0
	var Y = 0
	var current = Vector2(0,0)
	for i in curves:
		current += i
		X += current.x
		Y += current.y
	var rem = max(1,len(curves))
	print(rem, ":", X, ":", Y)
	return Vector2(X / rem, Y / rem)


func map(fun, list):
	var nlist = []
	for i in list:
		nlist.append(fun.call(i))
	return nlist

func sum(list):
	var summed = 0
	for i in list:
		summed += i
	return summed

func take(num, list):
	var new_list = []
	for i in range(0,num):
		new_list.append(list[i])
	return new_list

func intersect(l1, l2):
	var l3 = []
	for i in l1:
		if i in l2:
			l3.append(i)
	return l3

'''
# If the character controlling leaves the country (joins another country) - army stays, the character stops controlling the army.
# If the character is in a revolting faction, the army follows him.
# Considering the above rules, stance is calculated from character's faction wars + the country's wars.
# [NEUTRAL, AGRESSIVE, ALLIED]
func get_stance(army1, army2):
	if army1.country == army2.country:
		# check if their leaders are fighting against themselves in a civil war
		for i in army2.leader.factions:
			if len(intersect(army1.leader.factions, i.wars))>0:
				return Commons.STANCE.AGGRESSIVE
		return Commons.STANCE.ALLIED
	else:
		if army2.country in army1.country.wars:
			return Commons.STANCE.AGGRESSIVE
	return Commons.STANCE.NEUTRAL
'''
func get_stance(ch1: Character, ch2: Character) -> Commons.STANCE:
	if ch1.country == ch2.country:
		for i in ch1.factions:
			if len(Utils.new().intersect(ch2.factions, i.wars))>0:
				return Commons.STANCE.AGGRESSIVE
		return Commons.STANCE.ALLIED
	else:
		return Commons.STANCE.NEUTRAL

func controllable_by(unit: Unit, character: Character) -> bool:
	return character == unit.leader or (character!=null and unit.loyalty in character.factions)

func _ready():
	pass 
