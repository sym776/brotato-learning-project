extends Resource
class_name ItemBase #武器基本属性

enum ItemType {
	WEAPON,
	UPGRADE,
	PASSIVE
}

@export var item_name:String #武器名字
@export var item_icon: Texture2D #武器图标
@export var item_tier: Global.UpgradeTier #武器等级
@export var item_type: ItemType #类型
@export var item_cost: int #升级花费


func get_description() -> String:
	return ""
 
