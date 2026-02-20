extends Menu

@export var target: Character = null

func _ready():
	self.menutype = commons.Menus.CharacterInfo

func render(target: Character):
	self.target = target
	$Labels/Name.text = target.display()
