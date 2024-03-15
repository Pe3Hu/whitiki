extends MarginContainer


#region vars
@onready var primary = $HBox/Primary
@onready var secondary = $HBox/Secondary 
@onready var lap = $HBox/Lap

var planet = null
var encounter = null
var shedule = null
var pause = false
#endregion


func set_attributes(input_: Dictionary) -> void:
	planet = input_.planet
	
	init_basic_setting()


func init_basic_setting() -> void:
	encounter = planet.encounter
	encounter.moon = self
	shedule = planet.shedule
	shedule.moon = self
	
	init_phases()


func init_phases() -> void:
	var input = {}
	input.proprietor = self
	input.type = "moon"
	input.subtype = Global.dict.phase.primary.back()
	primary.set_attributes(input)
	
	input.subtype = Global.dict.phase.secondary.back()
	secondary.set_attributes(input)
	
	input.subtype = "lap"
	input.value = 0
	lap.set_attributes(input)


#region phase
func skip_all_phases() -> void:
	for _i in Global.num.phase.n:
		follow_phase()


func follow_phase() -> void:
	if planet.loser == null and !pause:
		var phase = null
		
		if primary.subtype == "wolf":
			phase = Global.dict.phase.next[secondary.subtype]
			secondary.set_subtype(phase)
			
			if secondary.subtype == "eagle" and planet.shedule.challenges.get_child_count() == 0:
				phase = Global.dict.phase.next[primary.subtype]
				primary.set_subtype(phase)
				secondary.set_subtype("empty")
		else:
			phase = Global.dict.phase.next[primary.subtype]
			primary.set_subtype(phase)
			secondary.set_subtype("empty")
		
		if phase == primary.subtype and primary.subtype == Global.dict.phase.primary.front():
			lap.change_value(1)
		
		var func_name = phase + "_" + "phase"
		call(func_name)


func lion_phase() -> void:
	shedule.init_challenges()
	follow_phase()


func wolf_phase() -> void:
	follow_phase()


func bear_phase() -> void:
	for god in planet.gods:
		god.core.take_recovery()
	
	follow_phase()


func owl_phase() -> void:
	#planet.encounter.pool.reset()
	
	#pause = true
	
	if planet.gods.is_empty():
		planet.loser = false
	else:
		follow_phase()


func eagle_phase() -> void:
	encounter.challenge = shedule.challenges.get_child(0)
	encounter.challenge.visible = true
	encounter.challenge.pick_aspects()
	encounter.update_aspects()
	encounter.prepare_dices()
	encounter.roll_dices()


func deer_phase() -> void:
	encounter.reset()
	encounter.challenge.pick_aspects()
	encounter.update_aspects()
	encounter.prepare_dices()
	encounter.roll_dices()


func snake_phase() -> void:
	for god in planet.gods:
		god.core.absorb_losses()
	
	shedule.challenges.remove_child(encounter.challenge)
	encounter.reset()
	follow_phase()
#endregion
