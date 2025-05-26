extends State
class_name StateSwapWeaponCheck

func enter():
	if actor.weapons.current_weapon.charge_maxxed:
		actor.exit_state("ultimate_swap_weapon", 0)
	else:
		actor.exit_state("swap_weapons", 1)
		actor.exit_state("idle", 0)
