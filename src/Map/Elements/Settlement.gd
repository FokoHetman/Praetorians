extends Node
class_name Settlement

var utils = load("res://src/utils/utils.gd").new()

var buildings
var type
var population # this actually is a "spis powszechny". Calculated each year
func _init(type, starting_population, buildings = []):
	self.type = type
	self.buildings = buildings
	self.starting_population = population


# this function is called each year, as a "spis powszechny"
# this is dependent on multiple factors:
# * popularity of the city in the state
func calculate_population() -> int:
	# proposed equation:
	var parent = get_parent()
	# min(1, (development / average_development)) / 2 * parent_population
	population = parent.population * min(1,(calculate_development(self)/2/(utils.sum(utils.map(Callable(calculate_development), parent.settlements))/len(parent.settlements))))
	return population

func calculate_development(settlement: Settlement) -> float:
	#proposed equation:
	# sum of occupation of each building
	var avgs = []
	for b in settlement.buildings:
		avgs.append(b.workers / b.max_workers)
	return utils.sum(avgs)#/max(1,len(avgs))
