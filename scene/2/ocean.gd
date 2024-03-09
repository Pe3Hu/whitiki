extends MarginContainer


#region var
@onready var seas = $Seas

var universe = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	universe = input_.universe
	
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_seas()


func init_seas() -> void:
	for _i in 1:
		var input = {}
		input.ocean = self
	
		var sea = Global.scene.sea.instantiate()
		seas.add_child(sea)
		sea.set_attributes(input)
#endregion
