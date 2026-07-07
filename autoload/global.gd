extends Node
#定义信号：创建一个格挡数字
signal on_create_block_text(unit: Node2D)
#定义信号：创建一个伤害数字
signal on_create_damage_text(unit: Node2D, hitbox: HitboxComponent)

signal on_create_heal_text(unit: Node2D, heal: float)

signal on_upgrade_selected #升级选择信号

signal on_enemy_died(enemy: Enemy) #敌人死亡信号

#定义受击发光材质常量，预加载
const FLASH_MATERIAL = preload("uid://bsox2vug0w1ya")
#预加载float_text.tscn模板
const FLOATING_TEXT_SCENE = preload("uid://dam2weobfqirr")
const COIN_SCENE = preload("uid://jagdd43dkppx")
const ITEM_CARD_SCENE = preload("uid://cq0v7vji3nrvq")
const SELECTION_CARD_SCENE = preload("uid://b45s460ns0ayv")

const COMMON_STYLE = preload("uid://jj680qjt1gsk")
const RARE_STYLE = preload("uid://j0xfyaq8pm16")
const EPIC_STYLE = preload("uid://dh2fxrrya5ids")
const LEGENDARY_STYLE = preload("uid://d0xj23i5a6m81")


const UPGRADE_PROBILITY_CONFIG = {
	"rare" = {"start_wave": 2, "base_multi": 0.06},
	"epic" = {"start_wave": 4, "base_multi": 0.02},
	"legendary" = {"start_wave": 7, "base_multi": 0.008}
}

enum UpgradeTier{
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

const SHOP_PROBILITY_CONFIG = {
	"rare" = {"start_wave": 2, "base_multi": 0.1},
	"epic" = {"start_wave": 4, "base_multi": 0.06},
	"legendary" = {"start_wave": 7, "base_multi": 0.01}
}

const TIER_COLORS: Dictionary[UpgradeTier, Color] = {
	UpgradeTier.RARE: Color(0.0,0.557,0.741),
	UpgradeTier.EPIC: Color(0.478,0.251,0.71),
	UpgradeTier.LEGENDARY: Color(0.906,0.212,0.212)
}

var available_players: Dictionary[String, PackedScene] = {
	"Joe": preload("uid://bffr0m6eep45f"),
	"Crazy": preload("uid://7uf6uu6g6wjr"),
	"Bunny": preload("uid://rraowbswlmvg"),
	"Knight": preload("uid://bgb6l3jj3hiah"),
	"Pirate": preload("uid://26kx4rgj1iu3")
}

var player:Player

var coin: int = 500

var game_paused:bool = false

var main_player_selected: UnitStats
var main_weapon_selected: ItemWeapon

var equipped_weapons: Array[ItemWeapon]

func get_harvesting_coins() -> void:
	coin += player.stats.harvesting

#定义判断概率（格挡\暴击）是否成功的方法
func get_chance_success(chance: float) -> bool:
	var random: float = randf_range(0,1.0)
	if chance > random:
		return true
	return false

func get_selected_player() -> Player:
	var player_scene:= available_players[main_player_selected.name]
	var player_instance:= player_scene.instantiate()
	player = player_instance
	return player

func get_tier_style(tier: UpgradeTier) -> StyleBoxFlat:
	match tier:
		UpgradeTier.COMMON:
			return COMMON_STYLE
		UpgradeTier.RARE:
			return RARE_STYLE
		UpgradeTier.EPIC:
			return EPIC_STYLE
		_:
			return LEGENDARY_STYLE		

#计算upgradecard中各等级出现概率
func calculate_tier_probability(current_wave: int, config: Dictionary) -> Array[float]:
	var common_chance: float = 0.0
	var rare_chance: float = 0.0
	var epic_chance: float = 0.0
	var legendary_chance: float = 0.0	
	
	if current_wave >= config.rare.start_wave:#从第2波开始计算稀有升级出现概率
		
		rare_chance = min(1 , (current_wave - 1) * config.rare.base_multi)
		
	if current_wave >= config.epic.start_wave:#从第4波开始计算史诗升级出现概率
		epic_chance = min(1 , (current_wave - 3) * config.epic.base_multi)
	
	if current_wave >= config.legendary.start_wave:#从第7波开始计算传说升级出现概率
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

func select_item_for_offer(item_pool: Array, current_wave:int, config:Dictionary) -> Array:#选出提供选择的升级项
	
	#计算各个等级出现的概率
	var tier_chances : Array[float] = calculate_tier_probability(current_wave, config)
	#举例[legendary: 1%, epic: 4%, rare: 20%, common: 75%]
	var legendary_limit: float = tier_chances[3]#1%
	var epic_limit: float = legendary_limit + tier_chances[2]#5%
	var rare_limit: float = epic_limit + tier_chances[1]#25%

	var offerred_items: Array = [] #数组，存放4个shopcard & upgradecard的等级index
	while offerred_items.size() < 4:
		var roll: float = randf() #随机结果
		var chosen_tier_index :int = 0 #当前card的等级index
		if roll < legendary_limit:
			chosen_tier_index = 3
		elif  roll < epic_limit:
			chosen_tier_index = 2
		elif roll < rare_limit:
			chosen_tier_index = 1

		var potential_items:Array =[]#定义备选池
		var current_search_tier_index: int = chosen_tier_index
		while potential_items.is_empty() and current_search_tier_index >=0:#只要为空并且等级大于等于common就执行
			#往备选池中传入item_pool筛选后的与当前card等级index相同的升级项
			potential_items = item_pool.filter(func(item:ItemBase): return item.item_tier == current_search_tier_index)
			
			if potential_items.is_empty():#只要为空就等级下降一级
				current_search_tier_index -= 1
			else:
				break
		
		if not potential_items.is_empty():#若备选池中不为空
			var selected_item = potential_items.pick_random() #从备选池里随机选出一个升级项
			
			if not offerred_items.has(selected_item):#若数组中无该升级项，则添加进数组
				offerred_items.append(selected_item)
	
	return offerred_items
