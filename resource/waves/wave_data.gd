extends Resource
class_name WaveData

enum SpawnType{
	RANDOM,
	FIXED
}

@export var from: int
@export var to: int
@export var wave_time:= 20.0
@export var units:Array[WaveUnitData]

@export var spawn_type:SpawnType= SpawnType.RANDOM
@export var fixed_spawn_time:float = 1.0
@export var min_spawn_time:float = 1.0
@export var max_spawn_time:float = 1.0
