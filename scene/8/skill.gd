extends MarginContainer


#region vars
@onready var low = $HBox/Synchronizations/Low
@onready var medium = $HBox/Synchronizations/Medium
@onready var high = $HBox/Synchronizations/High
@onready var aspects = $HBox/Aspects
@onready var first = $HBox/Aspects/First
@onready var second = $HBox/Aspects/Second

var proprietor = null
var role = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_synchronizations()
	init_aspects()


func init_synchronizations() -> void:
	for type in Global.arr.synchronization:
		var synchronization = get(type)
		var input = {}
		input.skill = self
		input.type = type
		synchronization.set_attributes(input)


func init_aspects() -> void:
	var branch = Global.dict.skill.branch[role]
	var roots = []
	roots.append_array(Global.arr.root)
	var keys = ["first", "second"]
	
	for key in keys:
		var token = get(key)
		var root = roots.pick_random()
		roots.erase(root)
		
		var input = {}
		input.proprietor = self
		input.type = root
		input.subtype = branch
		input.value = 0
		token.set_attributes(input)
	
	update_aspects()


func update_aspects() -> void:
	for aspect in aspects.get_children():
		var donor = proprietor.god.summary.get_aspect_based_on_root_and_branch(aspect.type , aspect.subtype)
		var value = donor.get_value()
		aspect.set_value(value)
	
	sort_aspects()


func sort_aspects() -> void:
	var _aspects = []
	
	while aspects.get_child_count() > 0:
		var aspect = aspects.get_child(0)
		aspects.remove_child(aspect)
		_aspects.append(aspect)
	
	_aspects.sort_custom(func(a, b): return a.get_value() > b.get_value())
	
	for aspect in _aspects:
		aspects.add_child(aspect)
#endregion
