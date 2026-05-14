extends Node2D
class_name Spawner

@export var spawn_area_size: Vector2 = Vector2(1000,500)
@export var wave_data:Array[WaveData]
@export var enemy_collection:Array[UnitStats]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimer

var wave_index: int = 1
var current_wave_data: WaveData
var spawned_enemies: Array[Enemy] = []

func find_wave_data() -> WaveData:
	for wave in wave_data:
		if wave and wave.is_valid_index(wave_index):
			return wave
	return null	

func start_wave() -> void:
	current_wave_data = find_wave_data()
	if not current_wave_data:
		printerr("No valid wave.")
		spawn_timer.stop()
		wave_timer.stop()
		return
		
	wave_timer.wait_time = current_wave_data.wave_time
	wave_timer.start()
	
	set_spawn_timer()
	
func set_spawn_timer() -> void:
	match current_wave_data.spawn_type:
		WaveData.SpawnType.FIXED:
			spawn_timer.wait_time = current_wave_data.fixed_spawn_time
			#未完
	
	
	
	
	
	
	
