extends Menu

@export var target: Unit = null

func _ready():
	self.menutype = commons.Menus.UnitInfo

func render(target: Unit):
	self.target = target
	$ArmyDisplayer.render(target, func(x): return x.offset)
	if target.leader:
		$Labels/Name.text = target.leader.display()
	else:
		$Labels/Name.text = "character.nobody"
