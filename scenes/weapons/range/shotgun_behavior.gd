extends RangeBehavier
class_name ShotgunBahavier

@export var projectile_num = 5

@export var scatter_range: float = 45.0

func execute_attack() -> void:
	weapon.is_attacking = true
	
	create_shotgun_projectile()
	
	var tween: Tween = create_tween()
	var recoil_position:Vector2 = Vector2(weapon.atk_start_pos.x - weapon.data.stats.recoil, weapon.atk_start_pos.y)
	
	tween.tween_property(weapon.sprite, "position", recoil_position, weapon.data.stats.recoil_duration)
	var recoil_degree: float = -45.0
	tween.parallel().tween_property(weapon.sprite, "rotation_degrees", recoil_degree, weapon.data.stats.recoil_duration)
	
	tween.tween_property(weapon.sprite, "position", weapon.atk_start_pos, weapon.data.stats.back_duration)
	tween.parallel().tween_property(weapon.sprite, "rotation_degrees", 0, weapon.data.stats.back_duration)
	
	tween.finished.connect(func():
		weapon.is_attacking = false
		critical = false
		)

func create_one_projectile() -> void:
	var angle_offset:float = randf_range(-scatter_range, scatter_range)
	var instance := weapon.data.stats.projectile_scene.instantiate() as ProjectileBase 
	get_tree().root.add_child(instance)
	instance.global_position = muzzle.global_position
	var velocity: Vector2 = Vector2.RIGHT.rotated(weapon.rotation+deg_to_rad(angle_offset)) * weapon.data.stats.projectile_speed
	instance.set_projectiled(velocity, get_damage(), critical, weapon.data.stats.knockback, weapon.get_parent())


func create_shotgun_projectile() -> void:
	for i in projectile_num:
		create_one_projectile()

	
	
	
	
	
	
