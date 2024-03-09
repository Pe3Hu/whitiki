extends MarginContainer


#region vars
@onready var archipelago = $HBox/Archipelago
#@onready var biome = $HBox/Biome

var ocean = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	ocean = input_.ocean
	
	init_basic_setting()


func init_basic_setting() -> void:
	var input = {}
	input.sea = self
	archipelago.set_attributes(input)
	#biome.set_attributes(input)
#endregion
