extends WeaponBehavior
class_name SwordBehavior

@export var hitbox:HitboxComponent

var wind_up_rotation: float = -90.0 #挥刀前摇
var slash_rotation: float = 90.0 #挥刀旋转
var initial_rotation: float = 0.0 # 收刀旋转



func execute_attack() -> void:
	weapon.is_attacking = true
	
	var tween:Tween = create_tween()
	var recoil_position: Vector2 = Vector2(weapon.atk_start_pos.x-weapon.data.stats.recoil,weapon.atk_start_pos.y)
	tween.tween_property(weapon.sprite, "position", recoil_position, weapon.data.stats.recoil_duration)
	tween.parallel().tween_property(weapon.sprite, "rotation_degrees", wind_up_rotation , weapon.data.stats.recoil_duration)
	
	hitbox.enable()
	hitbox.setup(get_damage(), critical, weapon.data.stats.knockback, weapon.get_parent())
	
	var attack_position:Vector2 = Vector2(weapon.atk_start_pos.x + 10,weapon.atk_start_pos.y)
	
	tween.tween_property(weapon.sprite, "position", attack_position, weapon.data.stats.attack_duration)
	tween.parallel().tween_property(weapon.sprite, "rotation_degrees", slash_rotation, weapon.data.stats.attack_duration)
	tween.tween_callback(func()->void:
		hitbox.disable()
		weapon.is_attacking = false
		critical = false)
	tween.tween_property(weapon.sprite, "position", weapon.atk_start_pos, weapon.data.stats.back_duration)
	tween.parallel().tween_property(weapon.sprite, "rotation_degrees", initial_rotation, weapon.data.stats.back_duration)
	
	#tween.finished.connect(func()->void:
		#hitbox.disable()
		#weapon.is_attacking = false
		#critical = false)
	
	
	
	
	
	
	
	
