extends Node
class_name ContextMenuHandler

func spawn(cmenu: ContextMenu, pos: Vector2):
	for i in self.get_children():
		self.remove_child(i)
		i.queue_free()
	cmenu.position = pos
	add_child(cmenu)
