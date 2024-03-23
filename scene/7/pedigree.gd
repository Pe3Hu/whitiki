extends MarginContainer


#region vars
@onready var learnabilities = $Talents/Learnabilities
@onready var professions = $Talents/Professions

var summary = null
var stigmas = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	summary = input_.summary
	
	init_basic_setting()


func init_basic_setting() -> void:
	#custom_minimum_size = Global.vec.size.pedigree
	roll_stigmas()
	init_professions()
	init_learnabilities()


func roll_stigmas() -> void:
	stigmas.learnability = Global.get_random_key(Global.dict.rarity.stigma)
	stigmas.profession = Global.get_random_key(Global.dict.rarity.stigma)


func init_professions() -> void:
	var talent = Global.arr.profession.pick_random()
	var rank = Global.get_random_key(Global.dict.talent.rank)
	add_talent(talent, rank)


func init_learnabilities() -> void:
	var ranks = {}
	
	for talent in Global.arr.learnability:
		ranks[talent] = summary.god.rank
	
	var gift = 8
	
	while gift > 0:
		var talent = Global.get_random_key(Global.dict.rarity.learnability)
		
		while ranks[talent] == "s":
			talent = Global.get_random_key(Global.dict.rarity.learnability)
		
		var rank = ranks[talent]
		
		if roll_amplification("learnability", rank):
			var index = Global.arr.rank.find(rank) + 1
			ranks[talent] = Global.arr.rank[index]
		
		gift -= 1
	
	for talent in Global.arr.learnability:
		add_talent(talent, ranks[talent])


func roll_amplification(type_: String, rank_: String) -> bool:
	var limit = {}
	var degree = Global.arr.rank.size() + Global.dict.stigma.rank[stigmas[type_]]
	limit.total = pow(2, degree)
	degree = Global.arr.rank.size() - Global.arr.rank.find(rank_) - 1
	limit.current = pow(2, degree)
	
	Global.rng.randomize()
	var roll = Global.rng.randf_range(0, limit.total)
	#print([rank_, limit.total, limit.current, limit.total - limit.current, roll])
	
	return roll >= limit.total - limit.current


func add_talent(talent_: String, rank_: String) -> void:
	var input = {}
	input.pedigree = self
	input.designation = talent_
	input.rank = rank_#Global.get_random_key(Global.dict.talent.rank)

	var talent = Global.scene.talent.instantiate()
	var talents = null
	
	if Global.arr.learnability.has(talent_):
		talents = get("learnabilities")
	
	if Global.arr.profession.has(talent_):
		talents = get("professions")
	
	talents.add_child(talent)
	talent.set_attributes(input)
#endregion


func get_learnability_ranks() -> int:
	var ranks = 0
	
	for talent in learnabilities.get_children():
		var value = Global.arr.rank.find(talent.rank.subtype) + 1
		ranks += value
	
	return ranks


func get_learnability_appraisal() -> int:
	var appraisal = 0
	
	for talent in learnabilities.get_children():
		var rank = talent.rank.subtype
		var designation = talent.designation.subtype
		var value = (Global.num.talent.rarity - Global.dict.rarity.learnability[designation]) * (Global.arr.rank.find(rank) + 1)
		appraisal += value
	
	return appraisal
