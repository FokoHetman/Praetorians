extends Menu

### TODO: Localisation

func _ready():
	self.menutype = commons.Menus.Pause
	$CategoryContainer/return.connect("button_up", Callable(returnt))
	$CategoryContainer/exit.connect("button_up", Callable(exit))
	for i in $CategoryContainer.get_children():
		if i in [$CategoryContainer/exit, $CategoryContainer/return, $CategoryContainer/save]:
			return
		i.connect("button_up", Callable(open_submenu).bind(i.name))

func render():
	pass

func returnt():
	get_node("/root/Map").exitCurrentMenu()

func exit():
	get_tree().quit()

func open_submenu(name):
	for i in $Submenus.get_node(name):
		i.visible = false
	$Submenus.get_node(name).visible = true
