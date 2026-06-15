extends Panel
class_name ShopCard

signal _on_item_purchase(item: ItemBase)

@export var shop_item: ItemBase:set = _set_shop_item

@onready var item_icon: TextureRect = $MarginContainer/Control/ItemIcon
@onready var item_name: Label = $MarginContainer/Control/ItemName
@onready var item_type: Label = $MarginContainer/Control/ItemType
@onready var item_description: RichTextLabel = $MarginContainer/Control/ItemDescription
@onready var coins_label: Label = %CoinsLabel

func _set_shop_item(value:ItemBase) -> void:
	shop_item = value
	if value == null:
		return

	item_icon.texture = value.item_icon
	item_name.text = value.item_name
	item_type.text = ItemBase.ItemType.keys()[value.item_type]#value.item_type值为int类型
	item_description.text = value.get_description()
	coins_label.text = str(value.item_cost)#unfinished
	
	var style:StyleBoxFlat = Global.get_tier_style(value.item_tier)
	add_theme_stylebox_override("panel", style)


func _on_buy_button_pressed() -> void:
	if Global.coin >= shop_item.item_cost:
		Global.coin -= shop_item.item_cost
		_on_item_purchase.emit(shop_item)
		queue_free()
