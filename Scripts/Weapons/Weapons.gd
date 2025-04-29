extends Node
class_name Weapons

@export var actor : Actor

@export var current_weapon : Weapon
@export var weapons : Array[Weapon]

func _ready():
	for weapon in weapons:
		weapon.init(self, actor)
	equip_weapon(0)

func play_sound(sound_name : String) : actor.play_sound(sound_name)

func equip_weapon(weapon_idx : int):
	current_weapon = weapons[weapon_idx]

func get_attack_rotation() -> Vector2:
	return Vector2.DOWN.rotated(current_weapon.rotation)
