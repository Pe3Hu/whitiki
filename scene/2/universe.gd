extends MarginContainer


#region var
@onready var oceans = $Oceans

var sketch = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	sketch = input_.sketch
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_oceans()


func init_oceans() -> void:
	for _i in 1:
		var input = {}
		input.universe = self
	
		var ocean = Global.scene.ocean.instantiate()
		oceans.add_child(ocean)
		ocean.set_attributes(input)
#endregion
