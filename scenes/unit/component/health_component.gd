extends Node
class_name  HealthComponent

signal on_unit_hit#单位受击信号
signal on_unit_died#单位死亡信号
signal on_health_changed(current: float,max: float)#血量变化信号

var max_health : float = 1.0
var current_health :float =1.0

#设置setup方法，调用角色属性资源库为现时生命值和最大生命值赋值
func setup(stats: UnitStats) -> void:
	max_health = stats.health
	current_health = max_health
	on_health_changed.emit(current_health, max_health)

#设置take_damage，受到攻击方法，若一开始生命值为零则return,c_health-value，后算出max_health。
func take_damage(value: float) -> void:
		if current_health <= 0:
			return
			
		current_health -= value
		current_health = max(current_health, 0)
		
		on_unit_hit.emit()
		#在health数值改变之后，向health_bar发出信号
		on_health_changed.emit(current_health,max_health)
		#若current_health小于等于0，发送信号并触发die()
		if current_health <= 0:
			current_health = 0
			on_unit_died.emit()
			die()
#设置heal方法，若现生命值已经低于零，return
func heal(amount: float) -> void:
	if current_health <= 0:
		return
	#现生命值更新
	current_health += amount
	current_health = min(current_health, max_health)
	on_health_changed.emit(current_health,max_health)
		
#设置死亡方法，死亡则当前节点从场景树删除
func die() -> void:
	owner.queue_free()


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	 
