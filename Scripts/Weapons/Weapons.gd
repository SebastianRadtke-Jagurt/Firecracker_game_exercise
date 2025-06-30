extends Node
class_name Weapons

@export var actor : Actor

@export var current_weapon : Weapon
@export var weapons : Array[Weapon]

func _ready():
	if !weapons[0].is_node_ready(): 
		await weapons[0].ready
	call_deferred("equip_weapon", 0)

func init():
	for weapon in weapons:
		weapon.init(self, actor)

func play_sound(sound_name : String) : actor.play_sound(sound_name)

func equip_weapon(weapon_idx : int):
	current_weapon = weapons[weapon_idx]
	current_weapon.swap_in()

func get_attack_rotation() -> Vector2:
	return Vector2.DOWN.rotated(current_weapon.rotation)

func swap_weapons(next_weapon_idx : int):
	actor.state_machine.set_active_transition("attack_1", false)
	current_weapon.anim_player.play("swap_out")
	current_weapon.swap_out()
	await get_tree().create_timer(current_weapon.anim_player.get_animation("swap_out").length).timeout
	
	current_weapon = weapons[next_weapon_idx]
	
	current_weapon.anim_player.play("swap_in")
	current_weapon.swap_in()
	await get_tree().create_timer(current_weapon.anim_player.get_animation("swap_in").length).timeout
	actor.state_machine.set_active_transition("attack_1", true)

func swap_weapons_instant(next_weapon_idx : int):
	current_weapon.swap_out()
	current_weapon = weapons[next_weapon_idx]
	current_weapon.swap_in()
