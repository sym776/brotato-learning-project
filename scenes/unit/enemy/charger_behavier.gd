extends Node2D
class_name ChargerBehavier

@export var enemy:Enemy
@export var cooldown_time: float = 3.0 
@export var charger_animation: AnimationPlayer

var current_cooldown: float = 0.0
var atk_position:Vector2
var is_charging = false

func _ready() -> void:
	current_cooldown = cooldown_time 

func _process(delta: float) -> void:
	if not enemy:
		return
	
	if is_charging:
		enemy.global_position = enemy.global_position.move_toward(atk_position,enemy.stats.speed * 5 * delta)
		if enemy.global_position.distance_to(atk_position) < 50:
			end_charge()#与player距离小于50
	else:
		if current_cooldown > 0:
			current_cooldown -= delta
		else:
			if is_instance_valid(Global.player):
				atk_position = Global.player.global_position
				start_to_charge()

func start_to_charge() -> void:
	enemy.can_move = false
	charger_animation.play(&"charging")
	await charger_animation.animation_finished
	is_charging = true
	
func end_charge() -> void:
	enemy.can_move = true
	current_cooldown = cooldown_time
	is_charging = false
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
