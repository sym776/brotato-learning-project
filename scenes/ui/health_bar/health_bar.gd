extends Control
class_name HealthBar

@export var back_color: Color
@export var fill_color: Color

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var health_amount: Label = $HealthAmount

func _ready() -> void:
	#复制progress_bar的backgroud
	var back_style: StyleBox =progress_bar.get_theme_stylebox("background").duplicate()
	back_style.bg_color = back_color
	#复制progress_bar的fill
	var fill_style: StyleBox =progress_bar.get_theme_stylebox("fill").duplicate()
	fill_style.bg_color = fill_color
	#更改颜色后单独覆盖主题里的background，下同
	progress_bar.add_theme_stylebox_override("background",back_style)
	progress_bar.add_theme_stylebox_override("fill",fill_style)

#滚动条progress_bar以及文本label更新方法
func update_bar(value : float,health:float) -> void:
	progress_bar.value = value	
	health_amount.text = str(health)

#接收由health_component发出的health_changed信号，将value百分化后输入updata_bar()进行更新
func _on_health_component_on_health_changed(current: float, max: float) -> void:
	var value = current / max
	update_bar(value, current)
