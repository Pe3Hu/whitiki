extends Line2D


#region vars
var island = null
var lands = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	island = input_.island
	lands = input_.lands
	init_basic_setting()


func init_basic_setting() -> void:
	if check_crossroads():
		lands[0].neighbors[lands[1]] = self
		lands[1].neighbors[lands[0]] = self
		
		for land in lands:
			add_point(land.center)
	else:
		island.boundaries.remove_child(self)
		queue_free()


func check_crossroads() -> bool:
	var grids = []
	for land in lands:
		grids.append(land.grid)
	
	for crossroad in Global.dict.crossroads[island.title]:
		var flag = true
		
		for grid in crossroad:
			if !grids.has(grid):
				flag = false
				break
		
		if flag:
			return false
	
	return true
#endregion
