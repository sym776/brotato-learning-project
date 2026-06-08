extends Panel
class_name UpgradePanel

const UPGRADE_CARD_SCENE = preload("uid://l56m7c7fhvsq")

@export var upgrade_list: Array[ItemUpgrade]

@onready var items_container: HBoxContainer = %ItemsContainer



func load_upgrades(current_wave: int) -> void:
	for child in items_container.get_children():
		child.queue_free()
		
	var config:	Dictionary = Global.UPGRADE_PROBILITY_CONFIG
	
	var selected_upgrade: Array = Global.select_item_for_offer(upgrade_list, current_wave, config )
		
	for random_upg: ItemUpgrade in selected_upgrade:
		var card_instance: = UPGRADE_CARD_SCENE.instantiate() as UpgradeCard
		items_container.add_child(card_instance)
		card_instance.item_data = random_upg
