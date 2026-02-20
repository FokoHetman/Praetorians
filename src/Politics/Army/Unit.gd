extends Node2D
class_name Unit


var template_name: String

var master: Unit = null :
	set(v):
		master = v
		self.depth = master.depth + 1
		for i in self.subunits:
			i.depth = self.depth
			i.add_depth()
	get():
		return master

var depth = 0 # A unit with no master has a depth zero, subunits of this unit have depth equal to 1, subunits of the subunits have depth equal to 2....
var subunits: Array[Unit] = [] :
	set(v):
		subunits = v
		var dobj = get_node(Commons.DynamicObjects)
		if dobj:
			var childr = dobj.get_children()
			for i in self.subunits:
				i.master = self
				if i not in childr:
					dobj.add_child(i)
	get():
		return subunits

enum Pattern {Checkboard, Line}
var pattern: Pattern = Pattern.Line

var is_base = false

var columns: int

enum Task {Nothing, FollowMaster, AttachToMaster, GoTowardsDestination}
var task: Task = Task.Nothing

var destinations: Array[Vector2] = []

var movement_speed: int

var loyalty: Faction
var leader: Character = null :
	get():
		if leader:
			return leader
		if master:
			return master.leader
		return null

func _init(tname: String, subunits: Array[Unit] = [], pattern: Pattern = Pattern.Line, columns: int = 5):
	self.template_name = tname
	self.subunits = subunits
	self.pattern = pattern
	self.columns = columns
	recalculate_speed()

func add_subunit(unit: Unit):
	unit.depth = self.depth
	unit.add_depth()
	self.subunits.append(unit)

func add_depth():
	self.depth += 1
	for i in self.subunits:
		i.depth += 1

var base_zoom := Vector2.ONE
var base_scale := Vector2(4,4)
func _ready():
	get_node(Commons.GameTime).hourtick.connect(Callable(tick))
	var dobj = get_node(Commons.DynamicObjects)
	var childr = dobj.get_children()
	for i in self.subunits:
		i.master = self
		if i not in childr:
			dobj.add_child(i)

func scale_displayed(z):
	if $Display and $Area:
		var ratio = z.x / base_zoom.x
		$Display.scale = base_scale / ratio
		$Area.scale = base_scale / ratio

func render():
	add_child(craft_display_object())
	add_child(craft_area())
	var cam = get_node(Commons.Camera)
	cam.zoom_changed.connect(Callable(scale_displayed))
	#base_scale = $Display.scale
	scale_displayed(cam.zoom)
	if get_node(Commons.Player):
		renderPerspective(get_node(Commons.Player).character)

func derender():
	for i in self.get_children():
		self.remove_child(i)
		i.queue_free()

func craft_area():
	var area = UnitArea.new(self)
	var col_shape = CollisionPolygon2D.new()
	col_shape.set_polygon(PackedVector2Array(Commons.rounded_square))
	if !is_base:
		var l: int = len(self.subunits)
		var cols: float = self.columns
		var rows: float = l / self.columns + ((l % self.columns > 0) as int)
		col_shape.scale = Vector2(max(0.1,cols / rows), max(0.1,rows / cols))
	else:
		col_shape.scale = Vector2(1,1)
	col_shape.position = - (col_shape.scale * Utils.new().get_center(Commons.rounded_square)/5)
	area.add_child(col_shape)
	area.name = "Area"
	add_child(area)
func craft_display_object():
	var color_obj = Polygon2D.new()
	color_obj.set_polygon(PackedVector2Array(Commons.rounded_square))
	if !is_base:
		var l: int = len(self.subunits)
		var cols: float = self.columns
		var rows: float = l / self.columns + ((l % self.columns > 0) as int)
		print(cols, "x", rows, "|", l, self.template_name)
		color_obj.scale = Vector2(max(0.1,cols / rows), max(0.1,rows / cols))
	else:
		color_obj.scale = Vector2(1,1)
	base_scale = color_obj.scale * 4 / 2**self.depth
	color_obj.offset = - (color_obj.scale * Utils.new().get_center(Commons.rounded_square)/5)
	color_obj.name = "Display"
	return color_obj

func renderPerspective(perspective: Character):
	if get_node("Display") == null:
		self.render()
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

func is_selected() -> bool:
	if not get_node(Commons.Player):
		return false
	return self in get_node(Commons.Player).selected_units

func deselect():
	if not get_node(Commons.Player):
		return
	if is_selected():
		get_node(Commons.Player).selected_units.erase(self)
		renderPerspective(get_node(Commons.Player).character)

func select():
	if not get_node(Commons.Player):
		return
	if not Utils.new().controllable_by(self, get_node(Commons.Player).character):
		return
	if Input.is_key_pressed(KEY_SHIFT): # shift+click *adds* the unit to already selected ones
		get_node(Commons.Player).selected_units.append(self)
	else:
		get_node(Commons.Player).selected_units = [self]
	$Display.color = Color.WHITE
