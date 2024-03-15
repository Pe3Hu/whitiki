extends MarginContainer


#region vars
@onready var aspects = $Aspects

var summary = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	summary = input_.summary
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.channel


func add_aspect(aspect_: MarginContainer) -> void:
	var input = {}
	input.proprietor = self
	input.type = aspect_.type
	input.subtype = aspect_.subtype

	var aspect = Global.scene.aspect.instantiate()
	aspects.add_child(aspect)
	aspect.set_attributes(input)
	#aspect.replicate(aspect_)
	reload()


func reload() -> void:
	if Global.num.channel.n == aspects.get_child_count():
		var aspect = aspects.get_child(0)
		aspects.remove_child(aspect)


func get_convenient_roots() -> Array:
	var roots = []
	roots.append_array(Global.arr.root)
	
	for aspect in aspects.get_children():
		roots.erase(aspect.type)
	
	return roots
#endregion
