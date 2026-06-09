extends Panel
class_name ShopCard

@onready var item_icon: TextureRect = $MarginContainer/Control/ItemIcon
@onready var item_name: Label = $MarginContainer/Control/ItemName
@onready var item_type: Label = $MarginContainer/Control/ItemType
@onready var item_description: RichTextLabel = $MarginContainer/Control/ItemDescription
@onready var coins_label: Label = %CoinsLabel
