extends Node

const default_state_color = Color (1, 1, 1, 0.2)
const hover_color = Color(1, 1, 1, 0.6)
const select_color = Color(1, 1, 1, 0.8)

func font() -> FontFile:
	var font = FontFile.new()
	font.font_data = load("res://assets/DaysOne.ttf")
	return font
enum TYPES {FOREST, DESERT, PLAINS, MOUNTAINS}

enum VIEWS {MAP,PROVINCE}

#<<<<<DISCUSSION
# TODO: explain purpose of each type
# unsure about FORTRESS belonging
enum SETTLEMENT_TYPE {CITY,VILLAGE,CAMP,FORTRESS}
enum BUILDING_TYPE {BLACKSMITH, PORT} 
#>>>>>>
