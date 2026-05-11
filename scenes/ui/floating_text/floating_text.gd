extends Node2D
class_name FloatingText

@onready var value_label: Label = $ValueLabel

#定义初始化函数，初始化漂浮字符标签的文本、颜色、缩放
func setup(value: String, color: Color) -> void:
	value_label.text = value
	modulate = color
	scale = Vector2.ZERO
	#初始化旋转，把随机的-10~10度转换为弧度
	rotation = deg_to_rad(randf_range(-10,10))
	#定义随机缩放
	var random_scale : float =randf_range(0.8,1.6)
	#创建平滑过渡动画
	var tween: Tween = create_tween()
	#动画播放方式设置为并行，设置缩放、位置播放
	tween.parallel().tween_property(self, "scale" ,random_scale * Vector2.ONE,0.5)
	tween.parallel().tween_property(self,"global_position",global_position + Vector2.UP*15,0.5)
	#播放后暂停0.5秒
	tween.tween_interval(0.5)
	#0.5秒后继续并行播放，让缩放、透明度归零
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, 0.4)
	tween.parallel().tween_property(self, "modulate:a", 0.0, 0.4)
	#等待tween播放完后，从场景树删除当前节点
	await tween.finished
	queue_free()
