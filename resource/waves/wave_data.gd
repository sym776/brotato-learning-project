extends Resource
class_name WaveData

enum SpawnType{
	RANDOM,
	FIXED
}

@export var from: int
@export var to: int #波次范围
@export var wave_time:= 20.0 #波次持续时间
@export var units:Array[WaveUnitData] #这一波有哪些怪 

@export var spawn_type:SpawnType = SpawnType.RANDOM #生成方式 随机或固定
@export var fixed_spawn_time:float = 1.0 #固定方式的时间间隔
@export var min_spawn_time:float = 1.0 #随机方式的最小时间   
@export var max_spawn_time:float = 2.0 #随机方式的最大时间

func get_random_unit_scene() -> PackedScene: #
	if units.is_empty():
		printerr("No Units.")
		return null
		
	var enemies: Array[PackedScene]
	var weights: Array[float]
	
	for unit in units:
		enemies.append(unit.unit_scene)
		weights.append(unit.weight)
	
	var rng:= RandomNumberGenerator.new()
	var random_unit: PackedScene = enemies[rng.rand_weighted(weights)]
	return random_unit

func is_valid_index(waveindex: int) -> bool:
	return true
