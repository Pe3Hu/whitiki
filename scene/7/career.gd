extends MarginContainer


#region vars
@onready var crafts = $Crafts

var summary = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	summary = input_.summary
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_crafts()
	sort_craft_based_on_appraisal()


func init_crafts() -> void:
	for profession in Global.arr.profession:
		add_craft(profession)
	
	#var n = 0
	#
	#for carft in crafts.get_children():
		#var _value = carft.appraisal.get_number()
		#n += float(_value)
	#
	#print(round(n / crafts.get_child_count()))


func add_craft(profession_: String) -> void:
	var input = {}
	input.career = self
	input.profession = profession_

	var craft = Global.scene.craft.instantiate()
	crafts.add_child(craft)
	craft.set_attributes(input)


func sort_craft_based_on_appraisal() -> void:
	var _crafts = []
	
	while crafts.get_child_count() > 0:
		var craft = crafts.get_child(0)
		crafts.remove_child(craft)
		_crafts.append(craft)
	
	_crafts.sort_custom(func(a, b): return a.designation.get_value() > b.designation.get_value())
	
	for craft in _crafts:
		crafts.add_child(craft)
#endregion
