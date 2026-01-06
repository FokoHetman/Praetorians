extends Menu

@export var target: State = null

func _ready():
	self.menutype = commons.Menus.ProvinceInfo

func render(target: State):
	self.target = target
	$"state_info_ui/font-resize/state_name".text = target.getID()
	$"state_info_ui/font-resize/state_info".text = target.description()
	print(target.name)
