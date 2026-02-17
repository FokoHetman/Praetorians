extends Node
class_name Commons
### probably move this stuff to a data file
const default_state_color = Color (1, 1, 1, 0.2)
const hover_color = Color(1, 1, 1, 0.6)
const select_color = Color(1, 1, 1, 0.8)

func font() -> FontFile:
	var font = FontFile.new()
	font.font_data = load("res://assets/DaysOne.ttf")
	return font

# port syntax to CamelCase
enum TYPES {FOREST, DESERT, PLAINS, MOUNTAINS}
enum VIEWS {MAP,PROVINCE}
enum SETTLEMENT_TYPE {CITY,VILLAGE,CAMP,FORTRESS}
enum BUILDING_TYPE {NATURAL, ARTIFICIAL}
enum BUILDING_KIND {PORT, WALL, BLACKSMITH, RIVER, MOUNTAIN}

### those are EXCLUSIVE menus, meaning only one can be opened at the same time. For Static UI Elements use Master, for popups spawn them individually.
enum Menus {Pause,CountryInfo,ProvinceInfo,MissionTree}
const MenuScenes = [
	  preload("res://scenes/Menus/Pause.tscn")
	, preload("res://scenes/Menus/CountryInfo.tscn")
	, preload("res://scenes/Menus/ProvinceInfo.tscn")
	, preload("res://scenes/Menus/CountryInfo.tscn") # doesn't exist yet
]

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

const resolutions = [Vector2(2560,1440),Vector2(1920,1080),Vector2(1280,720)]
# resolution should be possible to be made anything, in case of weird devices. Above list is only "recommended" values.
const default_resolution = 1


func resolutionStr(vec: Vector2) -> String:
	return "%sx%s" % [vec.x, vec.y]
func resolutionFromStr(s: String):
	var splt = s.split("x")
	return Vector2(int(splt[0]),int(splt[1]))
func set_resolution(res: Vector2 = resolutions[default_resolution]) -> void:
	get_window().size = res
	get_window().position = Vector2((DisplayServer.screen_get_size().x-get_window().size.x)/2,(DisplayServer.screen_get_size().y-get_window().size.y)/2)
func set_resolution_str(s: String):
	set_resolution(resolutionFromStr(s))
