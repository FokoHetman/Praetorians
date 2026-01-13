extends Node
class_name Event

var title: String = ""
var texture: Texture2D = null
var description: String = ""
var options: Array[EventOption] = []

func _init(title, description, texture: Texture2D = null):
	self.title = title
	self.description = description
	self.texture = texture

func trigger():
	pass
