extends State
class_name StateSwapWeapon

func init(_actor : Actor):
	super.init(_actor)
	self.actor.set__can_get_hit(true)
	self.actor.play_animation("weapon_swap")

func enter():
	if actor.weapons.current_weapon.charge_maxxed:
		#Ultimate
		pass
	else:
		#Weapon swap - simultaneous
		pass

func execute(delta):
	state_time += delta
	if state_time >= state_time_max:
		exit("")
		return

func check_inputs():
	for transition in transitions:
		if actor.get_input(transition.input_name):
			actor.buffer_state(transition.state_name, state_group_idx)
			return
