extends MarginContainer


#region vars
@onready var offensiveAspect = $HBox/Offensive/Aspect
@onready var offensivePool = $HBox/Offensive/Pool
@onready var defensivePool = $HBox/Defensive/Pool
@onready var defensiveAspect = $HBox/Defensive/Aspect

var planet = null
var moon = null
var challenge = null
var pools = []
#endregion


#region vars
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.encounter
	
	init_pools()
	init_aspects()


func init_pools() -> void:
	var input = {}
	input.encounter = self
	
	for role in Global.arr.role:
		input.role = role
		var pool = get(role+"Pool")
		pool.set_attributes(input)


func init_aspects() -> void:
	var input = {}
	input.proprietor = self
	input.type = "will"
	input.subtype = "volume"
	
	for role in Global.arr.role:
		var aspect = get(role+"Aspect")
		aspect.set_attributes(input)
		aspect.visible = false
#endregion


func update_aspects() -> void:
	for role in Global.arr.role:
		var aspect = get(role+"Aspect")
		aspect.replicate(challenge[role].summary.aspect)
		
		var god = challenge.get(role)
		god.summary.channel.add_aspect(aspect)


func prepare_dices() -> void:
	for role in Global.arr.role:
		var dices = 1
		var god = challenge[role]
		var challenger = challenge.get_challenger_based_on_god(god)
		
		if challenger.accuracy.subtype != "standard":
			dices += 1
		
		var faces = challenge[role].summary.aspect.get_value()
		var pool = get(role+"Pool")
		pool.init_dices(dices, faces)


func roll_dices() -> void:
	for role in Global.arr.role:
		var pool = get(role+"Pool")
		pools.append(pool)
		
	for role in Global.arr.role:
		var pool = get(role+"Pool")
		pool.roll_dices()


func pool_stopped(pool_: MarginContainer) -> void:
	pools.erase(pool_)
	
	if pools.is_empty():
		update_equilibrium()


func update_equilibrium() -> void:
	var dices = {}
	
	for role in Global.arr.role:
		var god = challenge.get(role)
		dices[god] = []
	
	for role in Global.arr.role:
		var pool = get(role+"Pool")
		
		for dice in pool.dices.get_children():
			var data = {}
			data.dice = dice
			data.value = dice.get_current_facet_value()
			data.god = challenge.get(role)
			dices[data.god].append(data)
	
	var majors = []
	
	for god in dices:
		var challenger = challenge.get_challenger_based_on_god(god)
		
		if challenger.accuracy.subtype == "hindrance":
			dices[god].sort_custom(func(a, b): return a.value < b.value)
		else:
			dices[god].sort_custom(func(a, b): return a.value > b.value)
		
		var data = dices[god].front()
		majors.append(data)
	
	majors.sort_custom(func(a, b): return a.value > b.value)
	
	for role in Global.arr.role:
		var god = challenge.get(role)
		var challenger = challenge.get_challenger_based_on_god(god)
		challenger.accuracy.set_subtype("standard")
	
	if majors.front().value > majors.back().value:
		var data = majors.front()
		data.dice.set_as_major()
		
		match moon.secondary.subtype:
			"eagle":
				var challenger = challenge.get_challenger_based_on_god(data.god)
				challenger.accuracy.set_subtype("advantage")
			"deer":
				if challenge.get("offensive") == data.god:
					var damage = majors.front().value - majors.back().value
					var god = challenge.get("defensive")
					god.core.losses.health.append(-damage)
	
	moon.follow_phase()
	#for data in datas:
		#if data.value == datas.front().value:
			#majors.append(data.dice)
		#else:
			#break
	#
	#for dice in majors:
		#var god = get(dice.pool.role)
		#
		#if !dices.has(god):
			#dices.append(god)
	#
	#if dices.size() == 1:
		#var dice = majors.front()
		#dice.set_as_major()
		#var god = get(dice.pool.role)


func reset() -> void:
	for role in Global.arr.role:
		var pool = get(role+"Pool")
		pool.reset()
		
		var aspect = get(role+"Aspect")
		aspect.visible = false
