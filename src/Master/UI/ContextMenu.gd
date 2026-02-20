extends Node2D
class_name ContextMenu

var actions: Dictionary = {}

var base_zoom := Vector2.ONE
var base_scale := Vector2.ONE

func _init(actions: Dictionary):
	self.actions = actions

func _ready():
	var c = VBoxContainer.new()
	c.name = "Container"
	add_child(c)
	self.actions["buttons.cancel"] = Callable(func(): self.queue_free())
	for i in self.actions:
		var b = Button.new()
		b.theme = preload("res://assets/themes/MenuButton.tres")
		b.text = tr(i)
		b.button_up.connect(Callable(Utils.new().compose.bindv([self.actions[i], Callable(queue_free)])))
		$Container.add_child(b)
	var cam = get_node(Commons.Camera)
	cam.zoom_changed.connect(Callable(scale_c))
	base_scale = $Container.scale
	scale_c(cam.zoom)

func scale_c(z):
	var ratio = z.x / base_zoom.x
	$Container.scale = base_scale / ratio
