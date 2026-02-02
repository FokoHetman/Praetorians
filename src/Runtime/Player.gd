extends Node
class_name Player

var selected_units = []

### Player at a time represents **1** character, until their end of life.
### Depending on character's status the player will be able to influnce different decisions, engage with government differently.
### After death, player will be able to pick the successor, or any other allied political position.
var character = null

func become(character):
	self.character = character
	self.character.is_player = true

func _init():
	print("PLAYER")
func _ready():
	self.name="Player"
