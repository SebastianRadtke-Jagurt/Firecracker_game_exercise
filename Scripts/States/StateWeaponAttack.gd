extends State
class_name StateWeaponAttack

@export var attack_sequence_idx : int = 0

func enter():
	actor.weapons.current_weapon.enter_attack(attack_sequence_idx)

func execute(delta : float):
	actor.weapons.current_weapon.execute_attack(delta, attack_sequence_idx)

func check_inputs():
	for transition in transitions:
		if actor.get_input(transition.input_name) && transition.active:
			actor.buffer_state(transition.state_name, state_group_idx)
			return
