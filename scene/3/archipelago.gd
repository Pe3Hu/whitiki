extends MarginContainer


#region vars
@onready var islands = $Islands

var sea = null
var turn = 0
#endregion


func set_attributes(input_: Dictionary) -> void:
	sea = input_.sea
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_islands()


func init_islands() -> void:
	var n = 4
	islands.columns = 2
	
	for _i in n:
		var input = {}
		input.archipelago = self
		input.title = _i
		
		var island = Global.scene.island.instantiate()
		islands.add_child(island)
		island.set_attributes(input)
