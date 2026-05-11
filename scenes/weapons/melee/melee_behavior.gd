extends WeaponBehavior#继承与行为基类
class_name MeleeBehavior#近战武器行为逻辑

@export var hitbox:HitboxComponent

#执行攻击
func execute_attack() -> void:
	weapon.is_attacking = true
	
	var tween: Tween = create_tween()#创建动画
	#击退位置
	var recoil_pos : Vector2 = Vector2(weapon.atk_start_pos.x-weapon.data.stats.recoil,weapon.atk_start_pos.y-weapon.data.stats.recoil)
	#往后蓄力
	tween.tween_property(weapon.sprite , "position" , recoil_pos , weapon.data.stats.recoil_duration)
	#开启碰撞盒，设置碰撞盒
	hitbox.enable()
	hitbox.setup(get_damage() , critical , weapon.data.stats.knockback , weapon.get_parent())
	
	#定义攻击半径，sprite的相对坐标，配合weapon.gd中的攻击偏移方法
	var attack_pos:Vector2 = Vector2(weapon.atk_start_pos.x + weapon.data.stats.max_range, weapon.atk_start_pos.y)
	#sprite到达攻击位置
	tween.tween_property(weapon.sprite, "position", attack_pos, weapon.data.stats.attack_duration)
	if weapon.data.stats.is_rotated:
		tween.parallel().tween_property(weapon.sprite,"rotation_degrees" , 360, weapon.data.stats.attack_duration )
	tween.tween_callback(func():
		hitbox.disable()
		weapon.is_attacking = false
		critical = false)
	#sprite退回攻击开始的位置
	tween.tween_property(weapon.sprite, "position", weapon.atk_start_pos, weapon.data.stats.back_duration)
	if weapon.data.stats.is_rotated:
		tween.parallel().tween_property(weapon.sprite,"rotation_degrees" , 0, weapon.data.stats.attack_duration )
	
	#动画完毕后，执行匿名函数
	#tween.finished.connect(func():
		#hitbox.disable()
		#weapon.is_attacking = false
		#critical = false)
	
