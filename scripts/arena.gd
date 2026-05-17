extends Node2D
class_name Arena

@export var player: Player
@export var normal_color: Color #普通颜色
@export var blocked_color: Color #格挡颜色
@export var critical_color: Color #暴击颜色
@export var hp_color: Color #

@onready var wave_index_label: Label = %WaveIndexLabel
@onready var wave_time_label: Label = %WaveTimeLabel
@onready var spawner: Spawner = $Spawner


func _ready() -> void:
	Global.player = player #引入全局player
	Global.on_create_block_text.connect(_on_create_block_text)#接收全局创建格挡文本信号
	Global.on_create_damage_text.connect(_on_create_damage_text)#接收全局创建伤害文本信号

func _process(delta: float) -> void:
	wave_index_label.text = spawner.get_wave_text()
	wave_time_label.text = spawner.get_wave_timer_text()

#生成悬浮文本	
func create_floating_text(unit:Node2D) -> FloatingText:
	var instance := Global.FLOATING_TEXT_SCENE.instantiate() as FloatingText #实例化
	get_tree().root.add_child(instance)#在根节点下添加instance
	var random_angle: float = randf_range(0,TAU) #随机角度，（0，2Π）
	var spawn_pos : Vector2 =unit.global_position + Vector2.RIGHT.rotated(random_angle)* 35 #生成位置为该单位一周，半径为35px
	instance.global_position = spawn_pos#生成数字
	return instance #返回该实例

func _on_create_block_text(unit:Node2D)-> void:#收到on_create_block_text信号触发该方法
	var text: FloatingText = create_floating_text(unit)
	text.setup("Blocked!",blocked_color)
	
func _on_create_damage_text(unit:Node2D,hitbox:HitboxComponent)-> void:#收到on_create_damage_text信号触发该方法
	var text:FloatingText = create_floating_text(unit)
	var color:=critical_color if hitbox.critical else normal_color
	text.setup(str(hitbox.damage),color)
