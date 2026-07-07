extends Panel
class_name ShopPanel

const SHOP_CARD_SCENE = preload("uid://bo326xyyxukqq")

signal _on_shop_next_wave

@export var shop_list: Array[ItemBase]

@onready var item_container: HBoxContainer = %ItemContainer
@onready var passives_container: GridContainer = %PassivesContainer
@onready var weapons_container: GridContainer = %WeaponsContainer

@onready var combine: Button = %Combine
@onready var sell: Button = %Sell


var context_card: ItemCard

func _ready() -> void:
	for child in passives_container.get_children(): child.queue_free()
	for child in weapons_container.get_children(): child.queue_free()
	
func load_shop(current_wave: int) -> void:#加载shop
	#清除item_container的所有子节点
	for child in item_container.get_children(): child.queue_free()
	#品质概率
	var config: Dictionary = Global.SHOP_PROBILITY_CONFIG
	#被选择item的Array
	var selected_items: Array = Global.select_item_for_offer(shop_list, current_wave, config)
	for shop_item: ItemBase in selected_items:#遍历Array
		var card_instance:= SHOP_CARD_SCENE.instantiate() as ShopCard#shop_card场景实例化
		card_instance._on_item_purchased.connect(_on_item_purchased)#连接购买发生时信号
		item_container.add_child(card_instance) #在item_container下添加ShopCard类型作为子节点
		card_instance.shop_item = shop_item #加载shopcard

func _on_next_wave_button_pressed() -> void:
	_on_shop_next_wave.emit()

func _on_item_purchased(item: ItemBase) -> void: #当购买发生时的方法
	var item_card : ItemCard = create_item_card() #生成物品卡
	
	if item.item_type == ItemBase.ItemType.WEAPON: #如果是武器类，则执行以下代码
		weapons_container.add_child(item_card) #作为子节点加入weapon_container
		var weapon: ItemWeapon = item as ItemWeapon #把shop_card的weapon信息赋值给weapon变量
		Global.player.add_weapon(weapon) #添加武器
		Global.equipped_weapons.append(weapon)
	
	elif item.item_type == ItemBase.ItemType.PASSIVE:
		passives_container.add_child(item_card)
		var passive: ItemPassive = item as ItemPassive
		passive.apply_passive()
		
	item_card.item = item #赋值

func create_item_card() -> ItemCard:
	var item_card := Global.ITEM_CARD_SCENE.instantiate() as ItemCard #实例化item_card
	item_card._on_item_card_selected.connect(_on_item_card_selected)#连接item_card被选择的信号
	#并判断是否能够combine 
	return item_card

func create_item_weapon(weapon: ItemWeapon) -> void:
	var card:= create_item_card()
	weapons_container.add_child(card) 
	card.item = weapon
	
	
func _on_item_card_selected(card: ItemCard) -> void:#当itemcard被点击选中时
	context_card = card #上下文card，赋值item_card信息
	var can_merge: bool = false
	if card.item.item_type == ItemBase.ItemType.WEAPON:
		var count: int = 0
		for weapon: ItemWeapon in Global.equipped_weapons:
			if weapon.item_name == card.item.item_name:
				count += 1
		
		if count >= 2:#当武器大于2时，can_merge为true
			can_merge = true
	
	combine.disabled = not can_merge

func _on_combine_pressed() -> void:#点击combine按钮时
	if not context_card:
		return
		
	var clicked_weapon: = context_card.item as ItemWeapon
	if not clicked_weapon.upgrade_to:
		return
	
	#从玩家当前拥有的武器列表里，找出和当前点击武器同名的武器，然后取前2个，准备移除。
	var weapons_to_remove: Array[Weapon] = Global.player.current_weapons.filter(func(w: Weapon):
		return w.data.item_name == clicked_weapon.item_name).slice(0,2)
	var cards_to_remove: Array = weapons_container.get_children().filter(func(c: ItemCard):
		return c.item.item_name == clicked_weapon.item_name).slice(0,2)

	if weapons_to_remove.size() < 2 or cards_to_remove.size() < 2:
		return
		
	#Delete weapons 删除武器
	for weapon: Weapon in weapons_to_remove:
		Global.player.current_weapons.erase(weapon)
		Global.equipped_weapons.erase(weapon.data)
		weapon.queue_free()
	
	#Delete itemcards 删除物品卡（小卡）
	for card: ItemCard in cards_to_remove:
		card.queue_free()
	
	#Create new weapon 把删除的两个武器替换成新武器
	var upgraded_weapon: ItemWeapon = load(clicked_weapon.upgrade_to.resource_path)
	Global.player.add_weapon(upgraded_weapon)
	Global.equipped_weapons.append(upgraded_weapon)
	
	#Create new itemcard 创建新的物品卡
	var new_card: ItemCard = create_item_card()
	weapons_container.add_child(new_card)
	new_card.item = upgraded_weapon
	
	context_card = null

func _on_sell_pressed() -> void:
	if not context_card:
		return
	
	var clicked_weapon:ItemWeapon = context_card.item as ItemWeapon
	var coins: int = clicked_weapon.item_cost * 0.75
	
	var weapon_to_remove: Weapon = Global.player.current_weapons.filter(func(w: Weapon):
		return w.data.item_name == context_card.item.item_name ).front()
	
	if weapon_to_remove:
		Global.player.current_weapons.erase(weapon_to_remove)
		Global.equipped_weapons.erase(weapon_to_remove.data)
		weapon_to_remove.queue_free() #把引用的Weapon节点从节点树中删除
		
		#从ItemCard中删除该武器
		context_card.queue_free()
		context_card = null
		
		Global.coin += coins
