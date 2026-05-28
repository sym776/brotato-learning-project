extends Node2D
class_name ShootBehavier

@export var enemy: Area2D
@export var muzzle: Marker2D
@export var projectile_scene: PackedScene
@export var projectile_speed: float
@export

var atk_global_position:Vector2 = Vector2.ZERO
var current_cooldown:float = 0.0
var cooldown_time:float = 3.0
var is_shooting: bool = false
var velocity: Vector2

func _ready() -> void:
	current_cooldown = cooldown_time

func _process(delta: float) -> void:
	
	if Global.game_paused: return
	
	if not enemy:
		return
	if is_shooting:
		create_projectile(delta)
		end_shoot()
	else:
		if current_cooldown > 0:
			current_cooldown -= delta
		else:
			atk_global_position = Global.player.global_position
			if can_shoot():
				start_to_shoot()

func can_shoot() -> bool:
	return enemy.global_position.distance_to(atk_global_position) < 250		

func start_to_shoot() -> void:
	is_shooting = true
	enemy.can_move = false
	
func end_shoot() -> void:
	is_shooting = false
	enemy.can_move = true
	current_cooldown = cooldown_time
	
func create_projectile(delta:float) -> void:
	var direction: Vector2 = enemy.global_position.direction_to(atk_global_position)
	var instance:= projectile_scene.instantiate() as ProjectileBase
	get_tree().root.add_child(instance)
	instance.global_position = muzzle.global_position
	velocity = direction * projectile_speed
	instance.set_projectiled(velocity, enemy.stats.damage, false, false,get_parent())
	

	
	
	
	
	
	
	
	
	
	
	
