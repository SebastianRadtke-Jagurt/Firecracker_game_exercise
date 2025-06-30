extends State
class_name StateSwapWeaponCheck

func enter():
	if actor.weapons.current_weapon.charge_maxxed:
		state_machine.exit_state("ultimate_swap_weapon", 0)
	else:
		state_machine.exit_state("swap_weapons", 1)
		state_machine.exit_state("idle", 0)
