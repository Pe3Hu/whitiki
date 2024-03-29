extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.token = ["bay", "ruin", "cave", "shore", "goal"]
	arr.terrain = ["forest", "swamp", "steppe", "hill", "mountain", "pond"]
	arr.invasion = []
	arr.tax = []
	
	arr.root = ["strength", "dexterity", "intellect", "will"]
	arr.branch = ["volume", "replenishment", "tension", "resistance", "onslaught", "reaction", "inspection"]
	arr.indicator = ["health", "endurance"]
	arr.role = ["offense", "defense"]
	arr.side = ["left", "right"]
	arr.learnability = ["insight", "discipline", "overcome", "inheritance"]
	arr.rank = ["f", "e", "d", "c", "b", "a", "s"]
	arr.profession = ["armourer", "gunsmith", "jeweler", "witch", "alchemist", "perfumer", "engraver", "keeper", "tattooist"]
	arr.stage = ["first", "second", "third"]
	arr.synchronization = ["low", "medium", "high"]
	arr.extreme = ["min", "max"]
	
	arr.phase = {
		"lead fraction": [
			"purchase market slot",
			"strategic choice"
			],
		"strategic choice": [
			"faction potential assessment"
		],
		"regional conquest": [
			"regional withdrawal",
			"troop assembly",
			"initial disembarkation",
			"expansion",
			"last spurt",
			"coin receipt"
		],
		"fraction decay": [
			"troop retreat",
			"fraction auxiliary",
			"coin receipt"
		],
		"coin receipt": [
			"tax collection",
			"enmity bonus",
			"pass crown"
		],
	}


func init_num() -> void:
	num.index = {}
	
	num.land = {}
	num.land.r = 50
	
	num.region = {}
	num.region.n = 3
	
	num.area = {}
	num.area.n = pow(num.region.n, 2)
	num.area.col = num.area.n
	num.area.row = num.area.n
	
	num.aspect = {}
	num.aspect.min = 1
	num.aspect.avg = 10
	num.aspect.max = 5
	num.aspect.total = arr.root.size() * arr.branch.size() * num.aspect.avg
	num.aspect.gap = 4
	
	num.predisposition = {}
	num.predisposition.min = 0
	num.predisposition.avg = 5
	num.predisposition.max = 10
	
	num.channel = {}
	num.channel.n = 3
	
	num.talent = {}
	num.talent.rarity = 5


func init_dict() -> void:
	init_neighbor()
	init_multipliers()
	init_phase()
	init_markers()
	init_aspects()
	
	init_land()
	init_nucleus()
	init_skill()
	init_talent()
	init_craft()


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal2 = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	dict.neighbor.hybrid2 = []
	
	for _i in dict.neighbor.linear2.size():
		dict.neighbor.hybrid2.append(dict.neighbor.linear2[_i])
		dict.neighbor.hybrid2.append(dict.neighbor.diagonal2[_i])


func init_multipliers() -> void:
	dict.multipliers = {}
	dict.multipliers["strength"] = {}
	dict.multipliers["strength"]["health"] = 8
	dict.multipliers["strength"]["endurance"] = 2
	dict.multipliers["dexterity"] = {}
	dict.multipliers["dexterity"]["health"] = 7
	dict.multipliers["dexterity"]["endurance"] = 3
	dict.multipliers["intellect"] = {}
	dict.multipliers["intellect"]["health"] = 1
	dict.multipliers["intellect"]["endurance"] = 9
	dict.multipliers["will"] = {}
	dict.multipliers["will"]["health"] = 4
	dict.multipliers["will"]["endurance"] = 6


func init_phase() -> void:
	dict.phase = {}
	dict.phase.primary = ["lion", "wolf", "bear", "owl"]
	dict.phase.secondary = ["eagle", "deer", "snake"]
	
	dict.phase.next = {}
	var keys = ["primary", "secondary"]
	
	for key in keys:
		var n = dict.phase[key].size()
		
		for _i in n:
			var current = dict.phase[key][_i]
			var _j = (_i + 1) % n
			var next = dict.phase[key][_j]
			dict.phase.next[current] = next
	
	dict.phase.next["empty"] = "eagle"


func init_markers() -> void:
	dict.marker = {}
	dict.marker.locked = []
	dict.marker.unlocked = []
	
	for _i in 4:
		dict.marker.unlocked.append(_i)


func init_aspects() -> void:
	dict.aspect = {}
	dict.aspect.title = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/whitiki_branch.json"
	var array = load_data(path)
	
	for branch in array:
		
		for key in branch:
			if !exceptions.has(key):
				var data = {}
				data.branch = branch.title
				data.root = key
				dict.aspect.title[branch[key]] = data
	
	dict.aspect.role = {}
	dict.aspect.role["eagle"] = {}
	dict.aspect.role["eagle"]["offense"] = "onslaught"
	dict.aspect.role["eagle"]["defense"] = "reaction"
	dict.aspect.role["deer"] = {}
	dict.aspect.role["deer"]["offense"] = "tension"
	dict.aspect.role["deer"]["defense"] = "resistance"
	
	dict.aspect.weight = {}
	dict.aspect.weight["volume"] = 12
	dict.aspect.weight["replenishment"] = 9
	dict.aspect.weight["tension"] = 16
	dict.aspect.weight["resistance"] = 8
	dict.aspect.weight["onslaught"] = 12
	dict.aspect.weight["reaction"] = 6
	dict.aspect.weight["inspection"] = 7
	
	for branch in arr.branch:
		dict.aspect.weight[branch] = round(dict.aspect.weight[branch] * 100 / (num.aspect.avg * arr.branch.size()))#* num.aspect.total / 100.0)


func init_land() -> void:
	dict.island = {}
	dict.island.title = {}
	dict.land = {}
	dict.land.index = {}
	var path = "res://asset/json/whitiki_land.json"
	var array = load_data(path)
	
	for land in array:
		var island_title = int(land.island)
		
		if !dict.island.title.has(island_title):
			dict.island.title[island_title] = {}
			dict.island.title[island_title].size = Vector2()
			dict.island.title[island_title].lands = {}
		
		var data = {}
		data.grid = Vector2()
		
		for key in land:
			var words = key.split(" ")
			
			if typeof(land[key]) == TYPE_FLOAT:
				land[key] = int(land[key])
			
			if words.has("grid"):
				data.grid[words[1]] = land[key]
				
				if dict.island.title[island_title].size[words[1]] < land[key]:
					dict.island.title[island_title].size[words[1]] = land[key]
			else:
				var value = land[key]
				
				match value:
					"no":
						value = false
					"yes":
						value = true
				
				data[key] = value
		
		data.erase("index")
		dict.island.title[island_title].lands[data.grid] = data
		dict.island.title[island_title].lands[data.grid].erase("grid")
	
	for title in dict.island.title:
		dict.island.title[title].size += Vector2.ONE
	
	dict.crossroads = {}
	dict.crossroads[0] = []
	dict.crossroads[0].append([Vector2(1, 0), Vector2(0, 1)])
	dict.crossroads[0].append([Vector2(1, 1), Vector2(0, 2)])
	dict.crossroads[0].append([Vector2(2, 2), Vector2(1, 3)])
	dict.crossroads[1] = []
	dict.crossroads[1].append([Vector2(1, 0), Vector2(0, 1)])
	dict.crossroads[1].append([Vector2(2, 0), Vector2(1, 1)])
	dict.crossroads[1].append([Vector2(2, 1), Vector2(1, 2)])
	dict.crossroads[1].append([Vector2(3, 1), Vector2(2, 2)])
	dict.crossroads[2] = []
	dict.crossroads[2].append([Vector2(2, 0), Vector2(1, 1)])
	dict.crossroads[2].append([Vector2(2, 0), Vector2(3, 1)])
	dict.crossroads[2].append([Vector2(1, 1), Vector2(2, 2)])
	dict.crossroads[2].append([Vector2(2, 1), Vector2(1, 2)])
	dict.crossroads[2].append([Vector2(0, 2), Vector2(1, 1)])
	#dict.crossroads[2].append([Vector2(1, 1), Vector2(2, 2)])
	#dict.crossroads[1].append([Vector2(2, 0), Vector2(1, 1)])
	#dict.crossroads[2].append([Vector2(3, 0), Vector2(2, 1)])
	#dict.crossroads[2].append([Vector2(1, 1), Vector2(2, 2)])
	#dict.crossroads[2].append([Vector2(2, 1), Vector2(3, 2)])
	dict.crossroads[3] = []
	dict.crossroads[3].append([Vector2(1, 0), Vector2(0, 1)])
	dict.crossroads[3].append([Vector2(2, 1), Vector2(1, 2)])


func init_nucleus() -> void:
	dict.nucleus = {}
	dict.nucleus.title = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/whitiki_nucleus.json"
	var array = load_data(path)
	
	for nucleus in array:
		var data = {}
		
		for key in nucleus:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if !data.has(words[1]):
					data[words[1]] = {}
				
				data[words[1]][words[0]] = nucleus[key]
			
		dict.nucleus.title[nucleus.title] = data


func init_skill() -> void:
	dict.skill = {}
	dict.skill.role = {}
	var exceptions = ["role", "type"]
	
	var path = "res://asset/json/whitiki_skill.json"
	var array = load_data(path)
	
	for skill in array:
		var data = {}
		
		for key in skill:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if words.size() > 1:
					if !data.has(words[1]):
						data[words[1]] = {}
				
					data[words[1]][words[0]] = skill[key]
				else:
					data[key] = skill[key]
		
		if !dict.skill.role.has(skill.role):
			dict.skill.role[skill.role] = {}
		
		if !dict.skill.role[skill.role].has(skill.type):
			dict.skill.role[skill.role][skill.type] = []
		
		dict.skill.role[skill.role][skill.type].append(data)
	
	dict.skill.branch = {}
	dict.skill.branch["offense"] = "tension"
	dict.skill.branch["defense"] = "resistance"


func init_talent() -> void:
	dict.talent = {}
	dict.talent.rank = {}
	
	var path = "res://asset/json/whitiki_talent.json"
	var array = load_data(path)
	
	for talent in array:
		dict.talent.rank[talent.title.to_lower()] = talent.value
	
	
	dict.rarity = {}
	dict.rarity.learnability = {}
	
	for talent in arr.learnability:
		dict.rarity.learnability[talent] = arr.learnability.find(talent) + 1
	
	dict.rarity.stigma = {}
	dict.rarity.stigma["blessed"] = 1
	dict.rarity.stigma["forgotten"] = 9
	dict.rarity.stigma["cursed"] = 4
	
	dict.stigma = {}
	dict.stigma.rank = {}
	dict.stigma.rank["blessed"] = -1
	dict.stigma.rank["forgotten"] = 0
	dict.stigma.rank["cursed"] = 1
	
	dict.proffesion = {}
	dict.proffesion["blacksmith"] = ["armourer", "gunsmith", "jeweler"]
	dict.proffesion["medic"] = ["witch", "alchemist", "perfumer"]
	dict.proffesion["enhancer"] = ["engraver", "keeper", "tattooist"]


func init_craft() -> void:
	dict.craft = {}
	dict.craft.title = {}
	dict.craft.specialization = {}
	var exceptions = ["title"]
	
	var path = "res://asset/json/whitiki_craft.json"
	var array = load_data(path)
	
	for craft in array:
		var data = {}
		data.stages = {}
		
		for key in craft:
			if !exceptions.has(key):
				var words = key.split(" ")
				
				if words.size() > 1 and words[1] == "stage":
					if !data.stages.has(words[0]):
						data.stages[words[0]] = []
				
					data.stages[words[0]].append(craft[key])
				else:
					data[key] = craft[key]
		
		if !dict.craft.title.has(craft.title):
			dict.craft.title[craft.title] = {}
		
		if !dict.craft.specialization.has(craft.specialization):
			dict.craft.specialization[craft.specialization] = []
		
		dict.craft.title[craft.title] = data
		dict.craft.specialization[craft.specialization].append(craft.title)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.icon = load("res://scene/0/icon.tscn")
	
	scene.pantheon = load("res://scene/1/pantheon.tscn")
	scene.god = load("res://scene/1/god.tscn")
	
	scene.ocean = load("res://scene/2/ocean.tscn")
	scene.sea = load("res://scene/2/sea.tscn")
	
	scene.island = load("res://scene/3/island.tscn")
	scene.land = load("res://scene/3/land.tscn")
	scene.boundary = load("res://scene/3/boundary.tscn")
	
	scene.dice = load("res://scene/4/dice.tscn")
	scene.facet = load("res://scene/4/facet.tscn")
	
	scene.challenge = load("res://scene/5/challenge.tscn")
	scene.challenger = load("res://scene/5/challenger.tscn")
	
	scene.aspect = load("res://scene/6/aspect.tscn")
	
	scene.talent = load("res://scene/7/talent.tscn")
	scene.craft = load("res://scene/7/craft.tscn")
	
	scene.pack = load("res://scene/8/pack.tscn")
	scene.skill = load("res://scene/8/skill.tscn")
	scene.action = load("res://scene/8/action.tscn")


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.number = Vector2(vec.size.sixteen)
	vec.size.token = Vector2(48, 48)
	vec.size.area = Vector2(vec.size.token) * 1.5
	
	vec.size.land = Vector2(num.land.r, num.land.r)
	
	vec.size.bar = Vector2(128, 16)
	vec.size.facet = Vector2(vec.size.token)
	vec.size.shedule = Vector2(vec.size.token.x * 4, vec.size.token.y)
	vec.size.encounter = Vector2(vec.size.token.x * 6, vec.size.token.y)
	vec.size.channel = Vector2(vec.size.token.x * num.channel.n - 1, vec.size.token.y)
	vec.size.talent = Vector2(vec.size.token)
	vec.size.stage = Vector2(vec.size.token) * 0.75
	vec.size.action = Vector2(vec.size.token) * 1.5
	vec.size.extreme = Vector2(vec.size.action) * 0.5
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.terrain = {}
	color.terrain["forest"] = Color.from_hsv(120.0 / h, 0.8, 0.9)
	color.terrain["swamp"] = Color.from_hsv(30.0 / h, 0.8, 0.9)
	color.terrain["steppe"] = Color.from_hsv(60.0 / h, 0.8, 0.9)
	color.terrain["hill"] = Color.from_hsv(80.0 / h, 0.8, 0.9)
	color.terrain["mountain"] = Color.from_hsv(180.0 / h, 0.2, 0.9)
	color.terrain["pond"] = Color.from_hsv(210.0 / h, 0.8, 0.9)
	
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(30 / h, 0.9, 0.7)
	color.indicator.health.background = Color.from_hsv(30 / h, 0.5, 0.9)
	color.indicator.endurance = {}
	color.indicator.endurance.fill = Color.from_hsv(270 / h, 0.9, 0.7)
	color.indicator.endurance.background = Color.from_hsv(270 / h, 0.5, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
