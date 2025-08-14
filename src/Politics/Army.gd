extends Node
class_name Army

var kind

var leader


func _init(type, composition):
	pass

func assign(state: State):
	self.leader = state.governor

func assign_leader(leader: Character):
	self.leader = leader
