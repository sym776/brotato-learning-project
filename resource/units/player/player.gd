extends Unit
class_name Player
#导出冲刺属性值:持续时间、速度倍数、冲刺持续时间
@export var dash_duration: float = 1
@export var dash_speed_multi: float = 1.5
@export var dash_cooldown: float = 5
#获取已有节点引用，冲刺计时、冲刺冷却计时、碰撞形状、拖尾
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown_timer: Timer = $DashCooldownTimer
@onready var hp_regen_timer: Timer = $HPRegenTimer


@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var trail: Trail = %Trail
@onready var weapon_container: WeaponContainer = $WeaponContainer


#现用武器数组
var current_weapons: Array[Weapon] = []

#定义移动方向
var move_dir:Vector2
#定义冲刺状态锁
var is_dashing:bool = false
#冲刺是否可用
var dash_available: bool = true

func _ready() -> void:
	#加载unit父类的ready()
	super._ready()
	animation_player.play(&"idle")
	#dash_time冲刺计时器计时持续时间等于dash_duration
	dash_timer.wait_time = dash_duration
	#冲刺冷却计时器持续时间等于dash_cooldown
	dash_cooldown_timer.wait_time = dash_cooldown
	
	#item_punch_1.tres
	#add_weapon(preload("uid://d3uwpo0qp78s1"))
	
	#item_axe_1.tres
	#add_weapon(preload("uid://d1p4a2kxtrkbw"))
	
	#item_sword_1.tres
	#add_weapon(preload("uid://crr38mnw5k8pj"))
	
	#item_pistol_1.tres
	#add_weapon(preload("uid://lumdtum6ldkm"))
	
	#item_lazer_1.tres
	#add_weapon(preload("uid://6mkyu0sdbfre"))
	
	#item_shotgun_1.tres
	#add_weapon(preload("uid://ciuqxrem3maqc"))
	

func _process(delta: float) -> void:
	
	if Global.game_paused: 
		animation_player.stop()
		return
	
	#设置移动方向
	move_dir = Input.get_vector("move_left","move_right","move_up","move_down")
	#设置速度为移动方向 * 资源中的速度
	var current_velocity:Vector2 = move_dir * stats.speed
	#若冲刺状态锁 = ture，当前速度 * 冲刺倍数
	if is_dashing:
		current_velocity *= dash_speed_multi
	#因为不是Charactorbody2d，所以要用position确定最终位移
	position += current_velocity * delta
	#限制当前节点位置坐标不超过地图边界
	position.x = clamp(position.x, -1000,1000)
	position.y = clamp(position.y, -500,500)
	#若能冲刺
	if can_dash():
		#冲刺冷却计时器开启
		dash_cooldown_timer.start()
		#调用方法
		start_dash()
	#更新动画和角色朝向
	update_animations()
	update_rotation()

#增加武器
func add_weapon(data:ItemWeapon) -> void:
	var weapon:= data.scene.instantiate() as Weapon
	add_child(weapon)
	
	weapon.setup_weapon(data)
	current_weapons.append(weapon)
	weapon_container.update_weapons_position(current_weapons)

#更新动画方法
func update_animations()-> void :
	#若方向向量取模大于零
	if move_dir.length() > 0:
		animation_player.play(&"move")
	else:
		animation_player.play(&"idle")	
#更新角色朝向
func update_rotation() -> void:
	if move_dir.x == 0:
		return
	if move_dir.x > 0:
		visuals.scale = Vector2(-0.5,0.5)
	else:
		visuals.scale = Vector2(0.5,0.5)
#开始冲刺方法
func start_dash() -> void:
	#正在冲刺，true
	is_dashing = true
	#冲刺持续计时开启
	dash_timer.start()
	#透明度为0.5
	visuals.modulate.a = 0.5
	#开启拖尾
	trail.start_trail()
	#碰撞消失
	collision.set_deferred("disabled",true)

#能否冲刺方法
func can_dash() -> bool:
	return not is_dashing and\
	dash_cooldown_timer.is_stopped() and\
	Input.is_action_just_pressed("dash") and\
	move_dir!=Vector2.ZERO
#是否面向右边
func is_facing_right()-> bool:
	return visuals.scale.x == -0.5

func update_player_new_wave() -> void:
	stats.health += stats.health_increase_per_wave
	health_component.setup(stats)

#冲刺持续时间timeout
func _on_dash_timer_timeout() -> void:
	is_dashing = false
	visuals.modulate.a = 1.0
	move_dir = Vector2.ZERO
	collision.set_deferred("disabled",false)


func _on_hp_regen_timer_timeout() -> void:
	if health_component.current_health <= 0:
		return
		
	if health_component.current_health < stats.health:
		var heal_value: float = stats.hp_regen
		health_component.heal(heal_value)
		Global.on_create_heal_text.emit(self,heal_value)
		
		
		
		
		
