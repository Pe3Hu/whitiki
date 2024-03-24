extends MarginContainer


#region vars
@onready var defenses = $HBox/Defenses
@onready var offenses = $HBox/Offenses

var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_starter_skills()


func init_starter_skills() -> void:
	for role in Global.arr.role:
		add_random_skill(role)


func add_random_skill(role_: String) -> void:
	var options = []
	options.append_array(Global.dict.skill.role[role_].keys())
	var type = options.pick_random()
	add_skill(role_, type)


func add_skill(role_: String, type_: String) -> void:
	var input = {}
	input.proprietor = self
	input.role = role_
	input.type = type_

	var skill = Global.scene.skill.instantiate()
	var skills = get(role_+"s")
	skills.add_child(skill)
	skill.set_attributes(input)
#endregion
