extends MarginContainer


#region vars
@onready var gods = $VBox/Gods
@onready var packs = $VBox/Packs

var cradle = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_basic_setting()


func init_basic_setting() -> void:
	add_pack()


func add_pack() -> void:
	var input = {}
	input.pantheon = self

	var pack = Global.scene.pack.instantiate()
	packs.add_child(pack)
	pack.set_attributes(input)
#endregion
