extends ItemBase
class_name ItemPassive

@export var add_value: float
@export var add_stats: String
@export var remove_value: float
@export var remove_stats: String

func get_description() -> String:
	var lines: Array[String] = []
	
	if add_value != 0:
		lines.append("[color=green]+%s %s[/color]" % [add_value, add_stats])
	
	if remove_value != 0:
		lines.append("[color=red]-%s %s[/color]" % [remove_value, remove_stats])
	
	return "\n".join(lines)
	
func	 apply_passive() -> void:
	if add_value != 0:
		Global.player.stats[add_stats] += add_value #[] 的意思是：用变量里的名字去访问某个属性/数据 
	if remove_value != 0:
		Global.player.stats[remove_stats] -= remove_value
