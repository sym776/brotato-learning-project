extends HBoxContainer
class_name CoinBag

@onready var coin_num: Label = %CoinNum

func _process(delta: float) -> void:
	coin_num.text = str(Global.coin)
