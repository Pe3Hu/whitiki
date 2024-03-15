extends MarginContainer


#region vars
@onready var indicators = $Indicators
@onready var health = $Indicators/Health
@onready var endurance = $Indicators/Endurance

var god = null
var losses = {}
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_indicators()


func init_indicators() -> void:
	var input = {}
	input.core = self
	
	for type in Global.arr.indicator:
		losses[type] = []
		var indicator = get(type)
		input.type = type
		input.max = 0
		indicator.set_attributes(input)


func get_indicator(type_: String) -> Variant:
	for indicator in indicators.get_children():
		if indicator.name.to_lower() == type_:
			return indicator
	
	return null


func update_indicator(type_: String) -> void:
	var indicator = get_indicator(type_)
	var value = 0
	
	for root in Global.arr.root:
		var aspect = god.summary.get_aspect_based_on_root_and_branch(root, "volume")
		value += aspect.get_value() * Global.dict.multipliers[root][type_]
	
	indicator.set_value("maximum", value)
	indicator.reset()


func update_indicators() -> void:
	for type in Global.arr.indicator:
		update_indicator(type)
#endregion


func absorb_losses() -> void:
	for type in Global.arr.indicator:
		while !losses[type].is_empty():
			var loss = losses[type].pop_front()
			var indicator = get_indicator(type)
			indicator.change_value("current", loss)


func take_recovery() -> void:
	pass


func get_damage(damage_: int) -> void:
	var indicator = get("health")
	indicator.change_value(damage_)


func get_fatigue(fatigue_: int) -> void:
	var indicator = get("endurance")
	indicator.change_value(fatigue_)
