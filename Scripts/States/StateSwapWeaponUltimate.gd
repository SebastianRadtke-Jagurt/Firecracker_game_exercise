extends State
class_name StateSwapWeaponUltimate

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
	super.exit(exit_message)
