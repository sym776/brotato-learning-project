extends Panel
class_name ShopPanel

const SHOP_CARD_SCENE = preload("uid://bo326xyyxukqq")

signal _on_shop_next_wave

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
		card_instance._on_item_purchased.connect(_on_item_purchased)
		item_container.add_child(card_instance)
		card_instance.shop_item = shop_item #加载shopcard

func create_item_card() -> ItemCard:
	var item_card := Global.ITEM_CARD_SCENE.instantiate() as ItemCard
	item_card._on_item_card_selected.connect(_on_item_card_selected)
	return item_card

func _on_next_wave_button_pressed() -> void:
	_on_shop_next_wave.emit()

func _on_item_purchased(item: ItemBase) -> void: #当购买发生时的方法
	var item_card : ItemCard = create_item_card()
	
	if item.item_type == ItemBase.ItemType.WEAPON:#如果是武器类，则执行以下代码
		weapons_container.add_child(item_card)
		var weapon: ItemWeapon = item as ItemWeapon
		Global.player.add_weapon(weapon)
		Global.equipped_weapons.append(weapon)
		
	item_card.item = item

func _on_item_card_selected(card: ItemCard) -> void:
	pass
