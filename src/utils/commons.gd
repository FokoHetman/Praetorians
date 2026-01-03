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
enum SETTLEMENT_TYPE {CITY,VILLAGE,CAMP,FORTRESS}
enum BUILDING_TYPE {NATURAL, ARTIFICIAL}
enum BUILDING_KIND {PORT, WALL, BLACKSMITH, RIVER, MOUNTAIN}

func getType(kind):
	match kind:
		BUILDING_KIND.RIVER:
			return BUILDING_TYPE.NATURAL
		BUILDING_KIND.MOUNTAIN:
			return BUILDING_TYPE.NATURAL
		_:
			return BUILDING_TYPE.ARTIFICIAL


enum ARMY_TYPES {LEGION, LEVY}
enum COHORT_TYPES {ARCHERS,INFANTRY,CAVALRY}
enum STANCE {AGGRESSIVE, NEUTRAL, ALLIED}
const rounded_square = [Vector2(2,0), Vector2(18,0), Vector2(20, 2), Vector2(20, 8), Vector2(18, 10), Vector2(2, 10), Vector2(0, 8), Vector2(0,2)]
