extends Node2D
class_name Unit


var template_name: String

var master: Unit = null
var subunits: Array[Unit] = []

enum Pattern {Checkboard, Line}
var pattern: Pattern = Pattern.Line

var columns: int

enum Task {Nothing, FollowMaster, AttachToMaster, GoTowardsDestination}
var task: Task = Task.Nothing

var destinations: Array[Vector2] = []

var movement_speed: int

var loyalty: Faction
var leader: Character

func _init(tname: String, subunits: Array[Unit] = [], pattern: Pattern = Pattern.Line, columns: int = 5):
	self.template_name = tname
	self.subunits = subunits
	self.pattern = pattern
	self.columns = columns
	recalculate_speed()
	
	add_child(craft_display_object())

func craft_display_object():
	var color_obj = Polygon2D.new()
	color_obj.set_polygon(PackedVector2Array(Commons.rounded_square))
	color_obj.scale = Vector2(0.75, 0.75)
	color_obj.offset = - 0.75 * Utils.new().get_center(Commons.rounded_square)/5
	color_obj.name = "Display"
	return color_obj

func renderPerspective(perspective: Character):
	if Utils.new().controllable_by(self, perspective):
		$Display.color = Color.WEB_GREEN
	else:
		match Utils.new().get_stance(self.leader, perspective):
			Commons.STANCE.ALLIED:
				$Display.color = Color.BLUE
			Commons.STANCE.AGGRESSIVE:
				$Display.color = Color.DARK_RED
			Commons.STANCE.NEUTRAL:
				$Display.color = Color.DIM_GRAY

func recalculate_speed():
	print("! ", self.subunits.map(func(x): return x.recalculate_speed()))
	if len(self.subunits)>0:
		self.movement_speed = self.subunits.map(func(x): return x.recalculate_speed()).min()
	return self.movement_speed
func tick(_t):
	match task:
		Task.Nothing:
			return
		# the 2 below might server the same purpose, I don't know
		Task.AttachToMaster:
			if self.master == null:
				self.task = Task.Nothing
				return
			self.move_towards(self.master.position)
		Task.FollowMaster:
			if self.master == null:
				self.task = Task.Nothing
				return
			self.move_towards(self.master.position)
		Task.GoTowardsDestination:
			if len(self.destinations)==0:
				self.task = Task.Nothing
				return
			self.move_towards(self.destinations[0])

func move_towards(pos: Vector2):
	if movement_speed == null || movement_speed == 0:
		return
	var paths = find_path(pos)
	if len(paths)==0:
		if self.task == Task.AttachToMaster:
			self.task = Task.FollowMaster
		elif self.task == Task.FollowMaster:
			pass
		else:
			self.task = Task.Nothing
		return
	var destination = paths[0]
	var dir = destination - self.position
	var distance = dir.length()
	if distance <= movement_speed:
		self.position = destination
		return
	self.position = self.position + dir * movement_speed / distance

func find_path(pos) -> Array[Vector2]:
	return []

func reorganize():
	self.task = Task.FollowMaster
	for i in subunits:
		i.reorganize()
