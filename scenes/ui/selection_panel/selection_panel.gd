extends Panel
class_name SelectionPanel

@export var players: Array[UnitStats]
@export var start_weapons: Array[ItemWeapon]

@onready var player_container: HBoxContainer = %PlayerContainer
@onready var weapon_container: HBoxContainer = %WeaponContainer

@onready var player_icon: TextureRect = %PlayerIcon
@onready var player_name: Label = %PlayerName
@onready var player_title: Label = %PlayerTitle
@onready var player_description: RichTextLabel = %PlayerDescription

func _ready() -> void:
	for child in player_container.get_children(): child.queue_free()
	for child in weapon_container.get_children(): child.queue_free()

	show_player_info(false) #隐藏玩家角色选择界面
	load_players() #加载可选择的玩家角色
	
func load_players() -> void:
	if players.is_empty():
		return
		
	for player: UnitStats in players:
		var card: SelectionCard = Global.SELECTION_CARD_SCENE.instantiate()
		card.pressed.connect(_on_player_selected.bind(player)) #bind传入当前player
		player_container.add_child(card)
		card.set_icon(player.icon)
		
		
func show_player_info(value: bool) -> void:
	player_icon.visible = value
	player_name.visible = value
	player_title.visible = value
	player_description.visible = value
	
func _on_player_selected(player: UnitStats) -> void:
	Global.main_player_selected = player
	show_player_info(true)
	
	player_icon.texture = player.icon
	player_name.text = player.name
	player_description.text = (
	"Health: [color=green]%s[/color]\n" +
	"Damage: [color=green]%s[/color]\n" +
	"Speed: [color=green]%s[/color]\n" +
	"Luck: [color=green]%s[/color]\n" +
	"Block Chance: [color=green]%s%%[/color]"
) % [
	player.health,
	player.damage,
	player.speed,
	player.luck,
	player.block_chance
]
	
	
	
	
	
	
	
	
	
	
