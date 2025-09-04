extends Building
class_name River

var stream
var stream_width
func _init(pos, stream, stream_width):
	self.stream = stream
	self.stream_width = stream_width
	self.position = pos # start of the river ("source", probably)
	self.kind = commons.BUILDING_KIND.RIVER
	self.type = commons.BUILDING_TYPE.NATURAL

# rd stands for a *third* point calculated from previous two
func get_rd(A: Vector2,B: Vector2, width) -> Vector2:
	var D = B - A
	var perpendicular = Vector2(-D[1], D[0])
	var perp_unit = perpendicular.normalized()
	return B + width * perp_unit

func center(left, right):
	return Vector2(left.x + right.x, left.y + right.y)/2


### faulty logic. very faulty logic
func populate(left, current, offset, depth = 3):
	if depth == 0:
		return
	var center = center(left[-1], current) + offset*2
	populate(left, center, offset/2, depth-1)
	var right = [center]
	populate(right, current, offset/2, depth-1)
	print("L: ", left)
	print("R: ", right)
	left.append(center)
	left.append(current) # the last point

func display_obj():
	var last_position = Vector2(0,0)
	var river = Node2D.new()
	for i in range(len(stream)): # to make previous and next vectors available.
		var current = stream[i] # pun intended
		var river_part = Polygon2D.new()
		river_part.position = last_position
		river_part.color = Color.DEEP_SKY_BLUE
		var rd = get_rd(Vector2(0,0), current, stream_width)
		var left = [Vector2(0,0)]
		var offset
		if abs(current.x) > abs(current.y):
			offset = Vector2(0, [-1,1][randi() % 2])
		else:
			offset = Vector2([-1,1][randi() % 2], 0)

		populate(left, current, offset)
		#left.append(current)
		print("LEFT")
		print(left)
		var right = [rd]
		populate(right, rd-current, offset)
		print("RIGHT")
		print(right)
		#right.append(rd - current) # the last point
		var points = left + right
		#var points = [Vector2(0,0), current, rd, rd - current]
		river_part.set_polygon(PackedVector2Array(points))
		river.add_child(river_part)
		last_position += current
	return river
