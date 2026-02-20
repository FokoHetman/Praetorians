extends ContextMenu
class_name UnitContextMenu

func _init(unit: Unit):
	var k1 = "button.select"
	var a1 = Callable(unit.select)
	if unit.is_selected():
		k1 = "button.unselect"
		a1 = Callable(unit.deselect)
	self.actions = {
		k1: a1,
		"buttons.show_leader": Callable(display_character_menu).bind(unit.leader),
		"buttons.inspect": Callable(display_unit_menu).bind(unit)
	}

func display_character_menu(character: Character):
	get_node(Commons.GameRoot).toggleMenu(Commons.Menus.CharacterInfo, character)
func display_unit_menu(unit: Unit):
	get_node(Commons.GameRoot).toggleMenu(Commons.Menus.UnitInfo, unit)
