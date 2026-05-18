extends Unit
class_name Enemy

@export var flock_push :float= 20.0

@onready var vision_area: Area2D = $VisionArea
@onready var knockback_timer: Timer = $KnockbackTimer

var move_enemy_dir :Vector2 #移动方向（敌人）
var can_move:float = true #移动开关锁

var knockback_dir: Vector2
var knockback_power: float 


func _process(delta: float) -> void:
	if not can_move:#若不能移动，return
		return
	
	if not can_move_towards_player():#若不能靠近玩家，return
		return
		#位移
	position += (get_move_direction() + knockback_dir * knockback_power) * stats.speed * delta
	update_rotation()

#⭐⭐⭐⭐⭐群体避让（需要改进）
func get_move_direction() -> Vector2:
	if not is_instance_valid(Global.player):
		return Vector2.ZERO
	
	#direction:当前节点（敌人）指向玩家节点
	var direction:Vector2 = global_position.direction_to(Global.player.global_position)
	move_enemy_dir=direction
	#area：遍历在当前节点visionarea区域下的每个敌人属性或玩家属性
	for area:Node2D in vision_area.get_overlapping_areas():
		#若area不是当前节点并area在场景树中
		if area != self and area.is_inside_tree():
			#vector等于当前节点世界坐标减去area坐标，即由area坐标指向当前节点坐标的向量
			var vector: Vector2 = global_position - area.global_position
			#向量相加
			direction += flock_push	* vector.normalized() / vector.length()
	return direction

func destroy_enemies() -> void:
	can_move = false
	animation_player.play(&"die")
	await animation_player.animation_finished
	queue_free()
	
	
#更新朝向	
func update_rotation():
	if not is_instance_valid(Global.player):
		return
	if move_enemy_dir.x == 0:
		return
	if move_enemy_dir.x > 0:
		visuals.scale = Vector2(-0.5,0.5)
	else:
		visuals.scale = Vector2(0.5,0.5)

#当player存在，且距离player超过60像素距离时可以继续靠近	
func can_move_towards_player() -> bool:
	return is_instance_valid(Global.player)\
	and  global_position.distance_to\
	(Global.player.global_position) > 60

	
func reset_knockback() -> void:#重置
	knockback_power = 0.0
	knockback_dir = Vector2(0,0)
	
func apply_knockback(knockback_dir:Vector2, knockback_power:float) -> void:
	self.knockback_dir = knockback_dir
	self.knockback_power = knockback_power
	if knockback_timer.time_left > 0:#清空旧计时器，并重置计时器，将击退方向和力度设为0
		knockback_timer.stop()
		reset_knockback()
	knockback_timer.start()#启动计时器，计时器未启动时time_left==0
	
func _on_knockback_timer_timeout() -> void:
	reset_knockback()#重置


#重写父类受到攻击信号方法	
func _on_hurtbox_component_on_damaged(hitbox: HitboxComponent) -> void:
	super._on_hurtbox_component_on_damaged(hitbox)
	
	if hitbox.knockback_power > 0:
		var dir : Vector2 = hitbox.source.global_position.direction_to(global_position)
		apply_knockback(dir, hitbox.knockback_power)
	
	
	
	
	
	
	
	
	
