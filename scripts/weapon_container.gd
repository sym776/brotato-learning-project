extends Node2D
class_name WeaponContainer

@onready var one: Node2D = $One
@onready var two: Node2D = $Two
@onready var three: Node2D = $Three
@onready var four: Node2D = $Four
@onready var five: Node2D = $Five
@onready var six: Node2D = $Six


#更新武器方法，输入weapons数组
func update_weapons_position(weapons: Array[Weapon])->void:
	var count: int = weapons.size()
	var reference_node: Node2D #参考节点
	match count: #分支匹配
		1: reference_node = one
		2: reference_node = two
		3: reference_node = three
		4: reference_node = four
		5: reference_node = five
		6: reference_node = six
	
	var markers: Array[Node] = reference_node.get_children()#将参考节点的所有子节点存入数组
	if markers.size() != count:#若数组元素（标记点数量）和子节点数目不匹配则return
		return
	
	for i in count: #遍历weapons将预标记的点位位置赋值给其元素
		weapons[i].global_position = markers[i].global_position
	
	
	
	
	
