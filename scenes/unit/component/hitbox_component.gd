extends Area2D
class_name  HitboxComponent

signal on_hit_hurtbox(hurtbox: HurtboxComponent)#与受击盒碰撞信号

var damage :float =1.0
var critical : bool = false
var knockback_power :float = 0.0
var source : Node2D

#开启hitbox的碰撞检测
func enable()-> void:
	set_deferred("monitoring",true)
	set_deferred("monitorable",true)
#关闭hitbox的碰撞检测
func disable() -> void:
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)

#设置基本属性
func setup(damage: float,critical:bool,knockback:float,source:Node2D)->void:
	self.damage = damage#总伤害
	self.critical = critical#是否暴击
	self.knockback_power = knockback#击退值
	self.source = source#攻击来源
	

#当hurtbox进入检测范围时，广播该hurtbox
func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		SoundManager.play_sound(SoundManager.Sound.ENEMY_HIT)
		on_hit_hurtbox.emit(area)
		
