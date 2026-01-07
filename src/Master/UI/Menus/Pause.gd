extends Menu

### TODO: Localisation

func setup_submenus():
	for i in commons.resolutions:
		$Submenus/video/Resolution/Resolutions.add_item(commons.new().resolutionStr(i))
	$Submenus/video/Resolution/Resolutions.selected = commons.default_resolution
	$Submenus/video/Resolution/Resolutions.connect("item_selected", Callable(commons.new().set_resolution_str))

func _ready():
	setup_submenus()
	self.menutype = commons.Menus.Pause
	$CategoryContainer/return.connect("button_up", Callable(returnt))
	$CategoryContainer/exit.connect("button_up", Callable(exit))
	for i in $CategoryContainer.get_children():
		if i in [$CategoryContainer/exit, $CategoryContainer/return, $CategoryContainer/save]:
			continue
		i.connect("button_up", Callable(open_submenu).bind(i.name))

func render():
	pass

func returnt():
	get_node("/root/Map").exitCurrentMenu()

func exit():
	get_tree().quit()

func open_submenu(name):
	name = NodePath(name)
	if $Submenus.get_node(name):
		for i in $Submenus.get_children():
			i.visible = false
		$Submenus.get_node(name).visible = true
