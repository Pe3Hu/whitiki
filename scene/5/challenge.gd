extends MarginContainer


#region vars
@onready var challengers = $Challengers

var shedule = null
var offensive = null
var defensive = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	shedule = input_.shedule
	offensive = input_.offensive
	defensive = input_.defensive
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_challenges()


func init_challenges() -> void:
	for role in Global.arr.role:
		var input = {}
		input.challenge = self
		input.god = get(role)
		
		var challenger = Global.scene.challenger.instantiate()
		challengers.add_child(challenger)
		challenger.set_attributes(input)
#endregion


func pick_aspects() -> void:
	var phase = shedule.moon.secondary.subtype
	
	for role in Global.arr.role:
		var god = get(role)
		god.summary.pick_best_aspect_based_on_role_and_phase(role, phase)


func get_challenger_based_on_god(god_: MarginContainer) -> Variant:
	for challenger in challengers.get_children():
		if challenger.god == god_:
			return challenger
	
	return null
