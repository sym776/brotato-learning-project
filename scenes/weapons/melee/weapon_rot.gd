extends Sprite2D

func weapon_rotation() -> void:
	rotation+= deg_to_rad(10)
	if rad_to_deg(rotation) == 360:
		rotation = deg_to_rad(10)
		
		 
	
