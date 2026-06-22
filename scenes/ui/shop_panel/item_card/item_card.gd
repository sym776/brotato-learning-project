extends Button
class_name ItemCard

signal _on_item_card_selected(card: ItemCard)

@export var item: ItemBase: set = _set_item

@onready var item_icon: TextureRect = $ItemIcon

func _set_item(value: ItemBase) -> void:#设置TtemWeapon的值，目的是得到icon
	item = value
	item_icon.texture = value.item_icon
	
	var style: StyleBoxFlat = Global.get_tier_style(item.item_tier)


func _on_pressed() -> void:
	if item.item_type == ItemBase.ItemType.WEAPON:
		_on_item_card_selected.emit()
