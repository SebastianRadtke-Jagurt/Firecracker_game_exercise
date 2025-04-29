extends State
class_name StateWeaponAttack

@export var attack_sequence_idx : int = 0

func enter():
	actor.weapons.current_weapon.enter_attack(attack_sequence_idx)

func execute(delta : float):
	actor.weapons.current_weapon.execute_attack(delta, attack_sequence_idx)

func check_inputs():
	actor.weapons.current_weapon.check_inputs(attack_sequence_idx)
