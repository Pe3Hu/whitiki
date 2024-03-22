extends MarginContainer


#region vars
@onready var gods = $Gods

var cradle = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	cradle = input_.cradle
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_gods()
	sort_gods()


func init_gods() -> void:
	var rank = "d"
	
	for _i in 10:
		var input = {}
		input.pantheon = self
		input.rank = rank
	
		var god = Global.scene.god.instantiate()
		gods.add_child(god)
		god.set_attributes(input)
	
	var steps = {}
	var count = 0
	
	for god in gods.get_children():
		for talent in god.summary.pedigree.talents.get_children():
			var step = Global.arr.rank.find(talent.rank.subtype) - Global.arr.rank.find(rank)
			
			if step > 0:
				if !steps.has(step):
					steps[step] = 0
				
				steps[step] += 1
				count += step


func sort_gods() -> void:
	var datas = {}
	
	while gods.get_child_count() > 0:
		var data = {}
		data.god = gods.get_child(0)
		data.ranks = data.god.summary.pedigree.get_learnability_ranks()
		data.appraisal = data.god.summary.pedigree.get_learnability_appraisal()
		
		if !datas.has(data.ranks):
			datas[data.ranks] = []
		
		datas[data.ranks].append(data)
		gods.remove_child(data.god)
	
	var keys = datas.keys()
	keys.sort()
	
	datas[keys.front()].sort_custom(func(a, b): return a.appraisal < b.appraisal)
	var _data = datas[keys.front()].pop_front()
	pull_up_learnability(_data.god)
	_data.ranks = _data.god.summary.pedigree.get_learnability_ranks()
	_data.appraisal = _data.god.summary.pedigree.get_learnability_appraisal()
	
	if !datas.has(_data.ranks):
		datas[_data.ranks] = []
	
	datas[_data.ranks].append(_data)
	keys = datas.keys()
	keys.sort()
	
	for key in keys:
		datas[key].sort_custom(func(a, b): return a.appraisal < b.appraisal)
		
		for data in datas[key]:
			gods.add_child(data.god)


func pull_up_learnability(god_: MarginContainer) -> void:
	#var god = gods.get_child(gods.get_child_count()-1)
	
	for talent in god_.summary.pedigree.talents.get_children():
		var rank = talent.rank.subtype
		
		if god_.rank == rank:
			#print(talent.designation.subtype)
			var index = Global.arr.rank.find(rank) + 1
			rank = Global.arr.rank[index]
			talent.rank.set_subtype(rank)
#endregion
