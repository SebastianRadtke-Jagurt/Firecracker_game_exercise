extends State
class_name StateSwapWeaponUltimate

var choosing : bool = false

func enter():
	(actor as Player).weapons.current_weapon.ultimate_enter()
	actor.buffer_state("idle", state_group_idx)
	state_time_max = (actor as Player).weapons.current_weapon.get_ultimate_time()

func execute(delta : float):
	(actor as Player).weapons.current_weapon.ultimate_execute(delta)
	
	state_time += delta
	if state_time >= state_time_max:
		exit("")

func exit(exit_message : String = ""):
	(actor as Player).weapons.current_weapon.ultimate_exit()
	
	actor.exit_choice.connect(on_choose, CONNECT_ONE_SHOT)
	GameManager.game_menu.weapon_choice.open_choice()
	await actor.exit_choice
	
	super.exit(exit_message)

func on_choose(next_weapon_idx : int):
	actor.weapons.swap_weapons_instant(next_weapon_idx)
