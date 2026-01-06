extends Menu

@export var target: Country = null

func _ready():
	self.menutype = commons.Menus.CountryInfo

func render(target: Country):
	self.target = target
