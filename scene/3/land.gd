extends MarginContainer


#region vars
@onready var bg = $BG
@onready var tokens = $VBox/Tokens

var island = null
var grid = null
var terrain = null
var protector = null
var bay = null
var ruin = null
var cave = null
var shore = null
var goal = true
var center = Vector2()
var neighbors = {}
#endregion


func set_attributes(input_: Dictionary) -> void:
	for key in input_:
		set(key, input_[key])
	
	init_basic_setting()


func init_basic_setting() -> void:
	shore = true
	
	if terrain != null:
		set_style()
	
	center = Global.vec.size.land * (grid * 1.25 + Vector2.ONE * 0.5)


func set_style() -> void:
	var style = StyleBoxFlat.new()
	bg.set("theme_override_styles/panel", style)
	style.bg_color = Global.color.terrain[terrain]
	
	custom_minimum_size = Global.vec.size.land
	style.corner_radius_top_left = Global.num.land.r / 2
	style.corner_radius_top_right = Global.num.land.r / 2
	style.corner_radius_bottom_left = Global.num.land.r / 2
	style.corner_radius_bottom_right = Global.num.land.r / 2


func check_against_criterion(criterion_: String) -> bool:
	var flag = false
	var type = null
	
	if Global.arr.token.has(criterion_):
		type = "token"
	
	if Global.arr.terrain.has(criterion_):
		type = "terrain"
	
	#print([type, criterion_])
	match type:
		"token":
			flag = get(criterion_)
		"terrain":
			flag = criterion_ == terrain
	
	
	return flag

