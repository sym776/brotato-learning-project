extends Panel
class_name UpgradeCard

@export var item_data: ItemUpgrade:set = _set_data

@onready var icon: TextureRect = %Icon
@onready var item_name: Label = %Name
@onready var description: Label = %Description

func _set_data(value: ItemUpgrade) -> void:
	item_data = value
