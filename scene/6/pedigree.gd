extends MarginContainer


#region vars
@onready var talents = $Talents

var summary = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	summary = input_.summary
	
	init_basic_setting()


func init_basic_setting() -> void:
	#custom_minimum_size = Global.vec.size.pedigree
	init_talents()


func init_talents() -> void:
	for talent in Global.arr.talent:
		add_talent(talent)


func add_talent(talent_: String) -> void:
	var input = {}
	input.pedigree = self
	input.designation = talent_
	input.rank = Global.get_random_key(Global.dict.talent.rank)

	var talent = Global.scene.talent.instantiate()
	talents.add_child(talent)
	talent.set_attributes(input)
