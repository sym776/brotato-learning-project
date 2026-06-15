extends Panel
class_name ShopPanel

const SHOP_CARD_SCENE = preload("uid://bo326xyyxukqq")

@export var shop_list: Array[ItemBase]

@onready var item_container: HBoxContainer = %ItemContainer
@onready var passives_container: GridContainer = %PassivesContainer
@onready var weapons_container: GridContainer = %WeaponsContainer

func _ready() -> void:
	for child in passives_container.get_children(): child.queue_free()
	for child in weapons_container.get_children(): child.queue_free()
	
func load_shop(current_wave: int) -> void:
	for child in item_container.get_children(): child.queue_free()
	
	var config: Dictionary = Global.SHOP_PROBILITY_CONFIG
	var selected_items: Array = Global.select_item_for_offer(shop_list, current_wave, config)
	for shop_item: ItemBase in selected_items:
		var card_instance:= SHOP_CARD_SCENE.instantiate() as ShopCard
		item_container.add_child(card_instance)
		card_instance.shop_item = shop_item
	
