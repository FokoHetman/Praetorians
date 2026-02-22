extends Node2D
class_name Unit

var template_name: String

var master: Unit = null :
	set(v):
		master = v
		master.movement.connect(follow_master_movement)
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
var pattern: Pattern = Pattern.Line :
	set(v):
		pattern = v
		reorder_subunits()
	get():
		return pattern

var is_base = false

var columns: int = 5
var offsets: Vector2  = Vector2.ZERO :
	get():
		return Vector2(4,4) /2**depth

enum Task {Nothing, FollowMaster, AttachToMaster, GoTowardsDestination}
var task: Task = Task.FollowMaster

# destinations set for the unit
var destinations: Array[Vector2] = []
# offset from master's position
var offset: Vector2 = Vector2.ZERO
var movement_speed: int

var loyalty: Faction
var leader: Character = null :
	get():
		if leader:
			return leader
		if master:
			return master.leader
		return null

func reorder_subunits():
	var x = -offsets.x * columns/2
	var orig = Vector2(x,0)
	match self.pattern:
		Pattern.Line:
			for i in range(len(subunits)):
				var col = i%columns
				var ii: int = i
				var row = ii / columns
				subunits[i].offset = orig + Vector2(offsets.x*col, offsets.y*row)
		Pattern.Checkboard:
			for i in range(len(subunits)):
				var col = i%columns
				var ii: int = i
				var row = ii / columns
				var row_offset = offsets.y*row
				if i%2 != row%2:
					row_offset += offsets.y/2
				subunits[i].offset = orig + Vector2(offsets.x*col, row_offset)

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

func render(offset=Vector2.ZERO):
	var do = craft_display_object()
	var area = craft_area()
	do.position = offset
	area.position = offset
	add_child(do)
	add_child(area)
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
	return area
func craft_display_object():
	var color_obj = Polygon2D.new()
	color_obj.set_polygon(PackedVector2Array(Commons.rounded_square))
	if !is_base:
		var l: int = len(self.subunits)
		var cols: float = self.columns
		var rows: float = l / self.columns + ((l % self.columns > 0) as int)
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
	$Display.color = Utils.new().get_perspective_color(self, perspective)

func recalculate_speed():
	print("! ", self.subunits.map(func(x): return x.recalculate_speed()))
	if len(self.subunits)>0:
		self.movement_speed = self.subunits.map(func(x): return x.recalculate_speed()).min()
	return self.movement_speed




func tick(_t):
	print(task)
	match task:
		Task.Nothing:
			return
		# the following 2 might serve the same purpose, I don't know
		Task.AttachToMaster:
			if self.master == null:
				self.task = Task.Nothing
				return
			self.move_towards(self.master.position + self.offset)
		Task.FollowMaster:
			if self.master == null:
				self.task = Task.Nothing
				return
			self.move_towards(self.master.position + self.offset)
		Task.GoTowardsDestination:
			if len(self.destinations)==0:
				self.task = Task.Nothing
				return
			self.move_towards(self.destinations[0])

signal movement(dp)

func follow_master_movement(dp):
	self.position += dp
func move_towards(pos: Vector2):
	if movement_speed == null || movement_speed == 0:
		return
	var paths = find_path(pos)
	if len(paths)==0:
		self.task = Task.Nothing
		return
	var destination = paths[0]
	var dir = destination - self.position
	var distance = dir.length()
	if distance <= movement_speed:
		self.position = destination
		if self.task == Task.AttachToMaster:
			self.task = Task.FollowMaster
		else:
			self.task = Task.Nothing
		return
	movement.emit(dir * movement_speed / distance)
	self.position = self.position + dir * movement_speed / distance

func find_path(pos) -> Array[Vector2]:
	return [pos] ### TODO: Implement a NavigationServer2D

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
