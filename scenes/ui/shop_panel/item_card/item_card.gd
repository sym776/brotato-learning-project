extends Button
class_name ItemCard

signal _on_item_card_selected(card: ItemCard)

@export var item: ItemBase: set = _set_item

@onready var item_icon: TextureRect = $ItemIcon

func _set_item(value: ItemBase) -> void:#设置ItemWeapon的值
	item = value
	item_icon.texture = value.item_icon
	var style: StyleBoxFlat = Global.get_tier_style(item.item_tier)
	add_theme_stylebox_override("normal", style)
	
func _on_pressed() -> void:
	SoundManager.play_sound(SoundManager.Sound.UI)
	
	if item.item_type == ItemBase.ItemType.WEAPON: #若物品类型为武器的话
		_on_item_card_selected.emit(self)
