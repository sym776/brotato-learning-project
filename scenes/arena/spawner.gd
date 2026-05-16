extends Node2D
class_name Spawner

@export var spawn_area_size: Vector2 = Vector2(1000,500)
@export var wave_data:Array[WaveData]
@export var enemy_collection:Array[UnitStats]

@onready var spawn_timer: Timer = $SpawnTimer
@onready var wave_timer: Timer = $WaveTimerw

var wave_index: int = 1
var current_wave_data: WaveData
var spawned_enemies: Array[Enemy] = []

func _ready() -> void:
	start_wave()

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
	
func set_spawn_timer() -> void: #根据类型更新 刷怪计时器
	match current_wave_data.spawn_type:
		WaveData.SpawnType.FIXED:
			spawn_timer.wait_time = current_wave_data.fixed_spawn_time
		WaveData.SpawnType.RANDOM:
			spawn_timer.wait_time = randf_range(current_wave_data.min_spawn_time, current_wave_data.max_spawn_time)
	
	if spawn_timer.is_stopped():
		spawn_timer.start()
		
func spawn_enemy() -> void:
	var enemy_scene:= current_wave_data.get_random_unit_scene() as PackedScene
	if enemy_scene:
		var enemy_instance:= enemy_scene.instantiate() as Enemy
		enemy_instance.global_position = Vector2.ZERO
		get_parent().add_child(enemy_instance)
		spawned_enemies.append(enemy_instance)
	
	set_spawn_timer()

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
	
	
	
