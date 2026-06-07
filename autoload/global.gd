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

const UPGRADE_PROBILITY_CONFIG = {
	"rare" = {"start_wave": 2, "base_multi": 0.06},
	"epic" = {"start_wave": 4, "base_multi": 0.02},
	"legendary" = {"start_wave": 7, "base_multi": 0.002}
}

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

#计算升级等级出现概率
func calculate_tier_probability(current_wave: int, config: Dictionary) -> Array[float]:
	var common_chance: float = 0.0
	var rare_chance: float = 0.0
	var epic_chance: float = 0.0
	var legendary_chance: float = 0.0	
	
	if current_wave >= config.rare.start_wave:#从第2波开始计算稀有升级出现概率
		
		rare_chance = min(1 , (current_wave - 1) * config.rare.base_multi)
		
	if current_wave >= config.epic.start_wave:#从第4波开始计算史诗升级出现概率
		epic_chance = min(1 , (current_wave - 3) * config.epic.base_multi)
	
	if current_wave >= config.legendary.start_wave:#从第7波开始计算chuanshuo1传说升级出现概率
		legendary_chance = min(1 , (current_wave - 6) * config.legendary.base_multi)

#幸运因子
	var luck_factor: float = 1.0 + (Global.player.stats.luck / 100.0)
	rare_chance *= luck_factor
	epic_chance *= luck_factor
	legendary_chance *= luck_factor

#概率归一化
	var total_non_common_chances: float = rare_chance + epic_chance + legendary_chance
	if total_non_common_chances > 1.0:
		var scale_down: float = 1.0 / total_non_common_chances
		rare_chance *= scale_down
		epic_chance *= scale_down
		legendary_chance *= scale_down
		total_non_common_chances = 1.0

#普通升级出现概率
	common_chance = 1.0 - total_non_common_chances

	print("wave: %d, luck: %.1f => chances: C%.2f R%.2f E%.2f L%.2f" %
	[current_wave, player.stats.luck, common_chance, rare_chance, epic_chance, legendary_chance])
	
	return [
		max(0.0, common_chance),
		max(0.0, rare_chance),
		max(0.0, epic_chance),
		max(0.0, legendary_chance)
	]
