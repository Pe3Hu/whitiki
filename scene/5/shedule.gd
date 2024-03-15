extends MarginContainer


#region vars
@onready var challenges = $Challenges

var planet = null
var moon = null
var gods = []
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.shedule


func roll_gods_order() -> void:
	gods = []
	gods.append_array(planet.gods)
	gods.shuffle()
#endregion


func init_challenges() -> void:
	roll_gods_order()
	
	for offensive in gods:
		var defensive = offensive.pick_opponent()
		add_challenge(offensive, defensive)


func add_challenge(offensive_: MarginContainer, defensive_: MarginContainer) -> void:
	var input = {}
	input.shedule = self
	input.offensive = offensive_
	input.defensive = defensive_

	var challenge = Global.scene.challenge.instantiate()
	challenges.add_child(challenge)
	challenge.set_attributes(input)
	challenge.visible = false
