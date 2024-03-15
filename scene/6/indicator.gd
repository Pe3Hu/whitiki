extends MarginContainer


#region vars
@onready var value = $Value
@onready var bar = $ProgressBar

var core = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	core = input_.core
	type = input_.type
	
	init_basic_setting(input_)


func init_basic_setting(input_: Dictionary) -> void:
	custom_minimum_size = Global.vec.size.bar
	set_value("maximum", input_.max)
	reset()
	update_color()


func reset() -> void:
	set_value("current", bar.max_value)


func update_color() -> void:
	var keys = ["fill", "background"]
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.indicator[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)


func change_value(limit_: String, value_: float) -> void:
	value_ = round(value_)
	
	match limit_:
		"current":
			bar.value += value_
			
			if bar.value >= bar.max_value:
				bar.value = bar.max_value
			
			if bar.value < bar.min_value:
				bar.value = bar.min_value
			
			value.text = str(bar.value)
		"maximum":
			bar.max_value += value_


func set_value(limit_: String, value_: float) -> void:
	value_ = round(value_)
	
	match limit_:
		"current":
			bar.value = value_
			value.text = str(bar.value)
		"maximum":
			bar.max_value = value_
			var _value = min(bar.value, bar.max_value)
			set_value("current", _value)


func get_value(limit_: String) -> int:
	var _value = null
	
	match limit_:
		"current":
			_value = bar.value
		"maximum":
			_value = bar.max_value
	
	return _value


func get_percentage() -> int:
	return floor(bar.value * 100.0 / bar.max_value)
#endregion
