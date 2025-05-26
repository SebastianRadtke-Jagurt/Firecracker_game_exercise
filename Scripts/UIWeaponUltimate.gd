extends Node
class_name UIWeaponUltimate

@onready var weapon_texture : TextureRect = $TextureRect
@onready var charge_bar : ProgressBar = $ChargeBar

func update_bar(percantage : int):
	charge_bar.value = percantage

func update_texture(texture : Texture2D):
	weapon_texture.texture = texture
