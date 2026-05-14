extends Node2D
class_name Weapon

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_behavior: WeaponBehavior = $WeaponBehavior

var data: ItemWeapon #定义武器基本属性
var is_attacking: bool = false # 攻击状态锁
var atk_start_pos: Vector2 # weapon节点攻击时的位置
var targets: Array[Enemy] # 所有攻击目标（数组）
var closest_target: Enemy # 最靠近的攻击目标
var weapon_spread: float # 武器散射/偏移角度


func _ready() -> void:
	# 将精灵贴图位置赋值给开始攻击的位置
	atk_start_pos = sprite.position

func _process(delta: float) -> void:
	#如果攻击状态锁未开启，且攻击目标数组大于0，调用更新最近攻击目标方法，否则最近攻击目标为空
	if not is_attacking:
		if targets.size() > 0:
			updata_closest_target()
		else:
			closest_target = null
	
	rotate_to_target()#调用武器旋转方式方法
	
	update_visual()
	
	if can_use_weapon():#若攻击锁为true，则使用武器
		use_weapon()
	
#初始化武器配置
func setup_weapon(data: ItemWeapon) -> void:
	self.data = data
	var range_shape:= collision.shape.duplicate(true) as CircleShape2D
	collision.shape = range_shape
	collision.shape.radius = data.stats.max_range

#能否使用武器
func can_use_weapon() -> bool:
	return cooldown_timer.is_stopped() and closest_target#若冷却时间结束及最近目标存在

#使用武器方法
func use_weapon()-> void:
	calculate_spread()#调用计算偏移方法
	weapon_behavior.execute_attack()#应用攻击方法
	cooldown_timer.wait_time = data.stats.cooldown #攻击冷却时间
	cooldown_timer.start() #冷却计时开始
	
func update_visual() -> void:
	if abs(rotation) > PI/2:
		scale.y = -1
	else:
		scale.y = 1

#武器旋转姿态方法
func rotate_to_target() -> void:
	if is_attacking:#若是攻击状态
		rotation = get_custom_rotation_to_target()#启用自定义攻击姿态（攻击）
	else:
		rotation = get_rotation_to_target()#启用普通姿态（瞄准）

#自定义攻击姿态方法（攻击）
func get_custom_rotation_to_target() -> float:
	if not closest_target or not is_instance_valid(closest_target):#若没有最近目标或最近目标无效
		return rotation #维持原状
	#武器位置指向最近目标的角度
	var rot : float = global_position.direction_to(closest_target.global_position).angle()
	return rot + weapon_spread #武器位置角度加上偏转角度

#攻击姿态方法（瞄准）
func get_rotation_to_target() -> float:
	if targets.size() == 0: #若目标为0
		return get_idle_rotation() #切换至普通姿态
	var rot : float = global_position.direction_to(closest_target.global_position).angle()
	#武器位置指向最近目标的角度
	return rot
	
#普通姿态方法
func get_idle_rotation() -> float:
	if Global.player.is_facing_right():#向右则不变，否则旋转180度
		return 0
	else:
		return PI

#计算偏移
func calculate_spread() -> void:
	weapon_spread += randf_range(-1 + data.stats.accuracy,1 - data.stats.accuracy)#在此范围区间内偏移
	rotation += weapon_spread #旋转加上偏移角度
#更新最近目标
func updata_closest_target() -> void: 
	closest_target = get_closest_target()

#获得最近目标
func get_closest_target() -> Node2D:
	if targets.size() == 0:#若目标数组元素为0，跳过
		return
	
	var closest_enemy: Node2D = targets[0] #令第一个元素为最近目标
	#设置最近路径为武器坐标到该目标的距离
	var closest_distance : float = global_position.distance_to(closest_enemy.global_position) 	
	#遍历第二个及往后所有目标，挨个对比距离，若有距离小于最短长度的，则替换前一个为最近目标
	for i in range(1, targets.size()):
		var target : Enemy = targets[i]
		var distance : float =global_position.distance_to(target.global_position)
	
		if distance < closest_distance:
			closest_enemy = target
			closest_distance = distance
	return closest_enemy

#进入武器area信号
func _on_range_area_area_entered(area: Area2D) -> void:
	targets.push_back(area)#加入target数组
#退出area
func _on_range_area_area_exited(area: Area2D) -> void:
	targets.erase(area)#从数组清除该目标元素
	if targets.size() == 0:#若数组长度为零
		closest_target = null#则最近目标为null
