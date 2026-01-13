extends Node
class_name EventOption

var text: String = ""
var hovertext: String = ""
var outcome: Callable

func _init(text,hover,outcome):
	self.text = text
	self.hovertext = hover
	self.outcome=outcome
