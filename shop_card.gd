extends Panel
class_name ShopCard

@export var shop_item: ItemBase:set = _set_shop_item


@onready var item_icon: TextureRect = $MarginContainer/Control/ItemIcon
@onready var item_name: Label = $MarginContainer/Control/ItemName
@onready var item_type: Label = $MarginContainer/Control/ItemType
@onready var item_description: RichTextLabel = $MarginContainer/Control/ItemDescription
@onready var coins_label: Label = %CoinsLabel

func _set_shop_item(value:ItemBase) -> void:
	shop_item = value
	item_icon.texture = value.item_icon
	item_name.text = value.item_name
	item_type.text = ItemBase.ItemType.keys()[value.item_type]
	#未完
	
