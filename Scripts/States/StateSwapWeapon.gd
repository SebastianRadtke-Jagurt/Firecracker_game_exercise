extends State
class_name StateSwapWeapons

var current_weapon : Weapon :
	get:
		return actor.weapons.current_weapon

func enter():
	# 1. Open UI to choose next weapon
	actor.exit_choice.connect(on_choose, CONNECT_ONE_SHOT)
	GameManager.game_menu.weapon_choice.open_choice()

func execute(delta):
	# 1. Wait until player chooses next weapon in the ui
	await actor.exit_choice
	
	state_time += delta
	if state_time >= state_time_max:
		exit("nothing")

func check_inputs():
	for transition in transitions:
		if state_machine.get_input.call(transition.input_name) && transition.active:
			state_machine.buffer_state(transition.state_name, state_group_idx)
			return

func on_choose(next_weapon_idx : int):
	var half_state_time = actor.weapons.current_weapon.anim_player.get_animation("swap_out").length
	state_time_max = half_state_time + actor.weapons.weapons[next_weapon_idx].anim_player.get_animation("swap_in").length
	actor.weapons.swap_weapons(next_weapon_idx)
