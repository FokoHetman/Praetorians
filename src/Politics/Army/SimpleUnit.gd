extends Unit
class_name SimpleUnit

func _init(mov_speed: int = 5.0, tname: String = "dummy"):
	self.movement_speed = mov_speed
	self.template_name = tr(tname)
	self.is_base = true
