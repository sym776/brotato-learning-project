extends ItemBase
class_name ItemWeapon #武器具体定义

enum WeaponType{
	MELEE,
	RANGE
}

@export var type: WeaponType #武器类型。近程/远程
@export var scene: PackedScene # 预封装到的场景
@export var stats: WeaponStats # 武器具体属性，战斗参数等
@export var upgrade_to: ItemWeapon #下一步升级

func get_description() -> String:
	return "Damage: [color=green]%s[/color]\nCooldown: [color=green]%s[/color]\nRange: [color=green]%s[/color]\nCritical: [color=green]%s%%[/color]" % [stats.damage,stats.cooldown,stats.max_range,stats.crit_chance * 100] 
