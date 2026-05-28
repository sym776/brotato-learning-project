extends Node
#定义信号：创建一个格挡数字
signal on_create_block_text(unit: Node2D)
#定义信号：创建一个伤害数字
signal on_create_damage_text(unit: Node2D, hitbox: HitboxComponent)

signal on_create_heal_text(unit: Node2D, heal: float)

signal on_upgrade_selected #升级选择信号

#定义受击发光材质常量，预加载
const FLASH_MATERIAL = preload("uid://bsox2vug0w1ya")
#预加载float_text.tscn模板
const FLOATING_TEXT_SCENE = preload("uid://dam2weobfqirr")

enum UpgradeTier{
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

var player:Player

var game_paused:bool = false

#定义判断概率（格挡\暴击）是否成功的方法
func get_chance_success(chance: float) -> bool:
	var random: float = randf_range(0,1.0)
	if chance > random:
		return true
	return false
