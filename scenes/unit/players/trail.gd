extends Line2D
class_name Trail

@export var player:Player

#定义拖尾点数量（长度）
@export var trail_length: int = 20
@export var trail_duration :float = 1.0
@onready var trail_timer: Timer = %TrailTimer

#定义点数组
var points_array: Array[Vector2]
#定义开关锁
var is_active: bool = false

func _process(delta: float) -> void:
	#若锁为false，return
	if not is_active:
		return
	#数组中加入player的全局坐标
	points_array.append(player.global_position)
	#若数组长度长于预设拖尾长度，则移除第一个（最旧的）元素
	if points_array.size() > trail_length:
		points_array.pop_front()
	#lind2d按照数组中元素先后顺序绘制节点
	points = points_array

func start_trail() -> void:
	#开关锁设置
	is_active = true
	#清除之前所有折线中的绘制点
	clear_points()
	#清除点数组
	points_array.clear()
	#拖尾计时器开始倒计时，时间为trail_duration
	trail_timer.start(trail_duration)

#拖尾计时器超时
func _on_trail_timer_timeout() -> void:
	#开关锁为false
	is_active = false
	#清除所有折线中所有点
	clear_points()
	#清除数组元素
	points_array.clear()
	
