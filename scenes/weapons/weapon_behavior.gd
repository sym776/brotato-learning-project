extends Node2D
class_name WeaponBehavior#行为基类

@export var weapon : Weapon

var critical : bool = false

func execute_attack() -> void:
	pass

#汇总伤害，计算是否有叠加暴击伤害	
func get_damage() -> float:
	var damage: float = weapon.data.stats.damage + Global.player.stats.damage
	var crit_chance: float = weapon.data.stats.crit_chance
	if Global.get_chance_success(crit_chance):
		critical = true
		damage = ceil(damage * weapon.data.stats.crit_damage)
	return damage

#计算是否触发life_steal
func apply_life_steal()-> void:
	var steal_chance: float = weapon.data.stats.life_steal + Global.player.stats.life_steal / 100
	var can_steal:float = Global.get_chance_success(steal_chance)
	if can_steal and is_instance_valid(Global.player):
		Global.player.health_component.heal(1.0)
		Global.on_create_heal_text.emit(Global.player,1.0)
