extends Area2D
class_name HurtboxComponent
#定义信号：收到伤害时
signal on_damaged(hitbox:HitboxComponent)

#hitbox碰撞层进入检测区域，广播进入的hitbox
func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		on_damaged.emit(area)
