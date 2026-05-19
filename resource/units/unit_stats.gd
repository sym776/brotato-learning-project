extends Resource
class_name UnitStats #单位基本属性

enum UnitType {
	PLAYER,
	ENEMY
}

@export var name:String
@export var type:UnitType
@export var icon: Texture2D
@export var health:int = 1
@export var health_increase_per_wave: float = 1.0
@export var damage : float = 1.0
@export var damage_increase_per_wave: float = 1.0
@export var speed: float = 300
@export var luck := 1.0
@export var block_chance := 0.0
@export var gold_drop : int = 1
@export var hp_regen: float = 0.0
@export var life_steal: float = 0.0
@export var harvesting: float = 0.0 
