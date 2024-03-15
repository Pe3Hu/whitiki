extends MarginContainer


#region vars
@onready var channel = $VBox/Channel
@onready var aspects = $VBox/Aspects

var god = null
var roots = {}
var branchs = {}
var aspect = null
var predispositions = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_predispositions()
	init_aspects()
	spread_aspects()
	god.core.update_indicators()
	
	var input = {}
	input.summary = self
	channel.set_attributes(input)


func init_predispositions() -> void:
	predispositions.root = {}
	predispositions.branch = {}
	
	for key in predispositions:
		var total = Global.arr[key].size() * Global.num.predisposition.avg
		var options = {}
		
		for type in Global.arr[key]:
			predispositions[key][type] = 0
			options[type] = Global.num.predisposition.max
		
		for _i in total:
			var type = Global.get_random_key(options)
			options[type] -= 1
			predispositions[key][type] += 1
			
			if options[type] == 0:
				options.erase(type)


func init_aspects() -> void:
	for root in Global.arr.root:
		roots[root] = []
	
	for branch in Global.arr.branch:
		branchs[branch] = []
		
		for root in Global.arr.root:
			var input = {}
			input.proprietor = self
			input.type = root
			input.subtype = branch
		
			var _aspect = Global.scene.aspect.instantiate()
			aspects.add_child(_aspect)
			_aspect.set_attributes(input)
			roots[root].append(_aspect)
			branchs[branch].append(_aspect)


func spread_aspects() -> void:
	var total = int(Global.num.aspect.total)
	var weights = {}
	
	for branch in Global.arr.branch:
		for root in Global.arr.root:
			var data = {}
			data.root = root
			data.branch = branch
			weights[data] = predispositions.root[root] + predispositions.branch[branch] + Global.dict.aspect.weight[branch]
			
			var _aspect = get_aspect_based_on_root_and_branch(root, branch)
			var value = Global.rng.randi_range(Global.num.aspect.min, Global.num.aspect.max)
			_aspect.change_value(value)
			total -= value
			weights[data] -= value
	
	while total > 0:
		var data = Global.get_random_key(weights)
		var _aspect = get_aspect_based_on_root_and_branch(data.root, data.branch)
		var value = Global.rng.randi_range(Global.num.aspect.min, Global.num.aspect.max)
		value = min(value, total)
		weights[data] -= value
		_aspect.change_value(value)
		total -= value
		
		if weights[data] <= 0:
			weights.erase(data)
	
	weights = {}
	total = int(Global.num.aspect.total)
	
	for branch in Global.arr.branch:
		weights[branch] = 0
		
		for root in Global.arr.root:
			var _aspect = get_aspect_based_on_root_and_branch(root, branch)
			weights[branch] += _aspect.get_value()
		
		weights[branch] = round(float(weights[branch]) / total * 100)


func get_aspect_based_on_root_and_branch(root_: String, branch_: String) -> MarginContainer:
	var a = Global.arr.root.find(root_)
	var b = Global.arr.branch.find(branch_)
	var index = b * Global.arr.root.size() + a
	return aspects.get_child(index)
#endregion


func pick_best_aspect_based_on_role_and_phase(role_: String, phase_: String) -> void:
	var branch = Global.dict.aspect.role[phase_][role_]
	pick_best_aspect_based_on_branch(branch)
	#var options = branchs[branch]
	#aspect = options.pick_random()


func pick_best_aspect_based_on_branch(branch_: String) -> void:
	#var datas = []
	#
	#for aspect in branchs[branch_]:
		#var data = {}
		#data.aspect = aspect
		#data.value = aspect.get_value()
		#datas.append(data)
	#
	#datas.sort_custom(func(a, b): return a.value < b.value)
	
	var _roots = channel.get_convenient_roots()
	
	var _aspects = []
	#_aspects.append_array(branchs[branch_])
	
	for _aspect in branchs[branch_]:
		if _roots.has(_aspect.type):
			_aspects.append(_aspect)
	
	_aspects.sort_custom(func(a, b): return a.get_value() > b.get_value())
	aspect = _aspects.front()
