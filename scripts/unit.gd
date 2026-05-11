extends Node2D
class_name Unit

#导出需要引用的资源库
@export var stats: UnitStats
@onready var visuals: Node2D = %Visuals
@onready var sprite: Sprite2D = %Sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var flash_timer: Timer = $FlashTimer


func _ready() -> void:
	#调用生命组件初始化方法
	health_component.setup(stats)

#定义受击发光材质方法
func set_flash_material() -> void:
	#使当前贴图变为全局中定义受击发光的贴图
	sprite.material = Global.FLASH_MATERIAL
	#倒计时两秒
	flash_timer.start(0.2)
#定义受击中方法，接收从hurtbox_component发出的信号
func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	#若现生命小于等于零，return
	if health_component.current_health <= 0:
		return
	#定义格挡，取资源中格挡机会词条代入全局中是否格挡成功方法判断成功与否
	var blocked : bool= Global.get_chance_success(stats.block_chance/100)
	#若成功，调用全局发出生成格挡文本信号，并return
	if blocked:
		Global.on_create_block_text.emit(self)
		return
	#设置受击闪光材质
	set_flash_material()
	#生命组件调用受击方法，参数为hitbox.damage==1.0
	health_component.take_damage(hitbox.damage)
	#调用全局发出生成伤害数字的信号
	Global.on_create_damage_text.emit(self,hitbox)
#flash_time倒计时结束后，sprite材质恢复为null	
func _on_flash_timer_timeout() -> void:
	sprite.material = null
