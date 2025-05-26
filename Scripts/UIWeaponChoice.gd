extends Control
class_name WeaponChoice

var choice_card_scene = preload("res://Scenes/UI_weapon_choice_card.tscn")
@onready var weapon_buttons_container : Control = $MarginContainer/HBoxContainer

var player_weapons : Weapons:
	get: return GameManager.player.weapons
var weapon_choice_idxs : Array[int]

func open_choice():
	#If player has only 1 weapon, simulate choosing their only weapon.
	if GameManager.player.weapons.weapons.size() <= 1:
		on_choose(0)
		return
	
	#Else fetch player's weapons to choose from, excluding currently holding one.
	var weapons_to_choose_idxs : Array[int]
	for i in player_weapons.weapons.size():
		weapons_to_choose_idxs.append(i)
	weapons_to_choose_idxs.erase(player_weapons.weapons.find(player_weapons.current_weapon))
	
	#Choose up to 3 at random and put their images in choice buttons
	for i in min(player_weapons.weapons.size(), 3):
		var r = randi_range(0, weapons_to_choose_idxs.size())
		weapon_choice_idxs.append(weapons_to_choose_idxs[r])
		weapons_to_choose_idxs.remove_at(r)
		create_weapon_choice(weapon_choice_idxs[i], player_weapons.weapons[weapon_choice_idxs[i]].weapon_texture)

func create_weapon_choice(weapon_idx : int, weapon_texture : Texture2D):
	var new_weapon_choice : TextureButton = choice_card_scene.instantiate() as TextureButton
	new_weapon_choice.pressed.connect(on_choose.bind(weapon_idx))
	new_weapon_choice.texture.texture_normal = weapon_texture

func on_choose(weapon_idx : int):
	for weapon_button in weapon_buttons_container.get_children():
		weapon_button.queue_free()
	GameManager.player.exit_choice.emit(weapon_idx)
