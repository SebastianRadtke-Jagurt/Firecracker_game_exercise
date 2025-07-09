extends WeaponAttackSequence
class_name PlayerWeaponAttackSequence

func enter():
	if state_time > 0 || weapon.attack_cooldown > 0:
		if actor is Enemy:
			actor.decide_AI()
			return
		else: 
			state_machine.rollback_state(state_group_idx)
			return
	
	actor.front_enemy_detection = true
	state_machine.buffer_state(state_name_to_buffer, state_group_idx)
	actor.set__can_get_hit(true)
	weapon.buffer_attack(attacks[attack_counter])
	attacks[attack_counter].play()
	attack_dir = weapon.get_attack_rotation()

func execute(delta : float):
	state_time += delta
	# Position lock on to the enemy
	if attacks[attack_counter].enemy_pos_locking_dist != 0 && actor.front_enemy != null:
		var lock_point = actor.front_enemy.global_position + actor.front_enemy.global_position.direction_to(actor.global_position) * attacks[attack_counter].enemy_pos_locking_dist
		actor.global_position += actor.global_position.direction_to(lock_point) * attacks[attack_counter].displacement * min(actor.global_position.distance_to(lock_point), 1)
	else:
		actor.global_position += attack_dir * attacks[attack_counter].displacement
	
	if state_time > attacks[attack_counter].attack_time:
		sequence_continuity_timer = sequence_continuity_timer_max
		attack_counter = (attack_counter + 1) % attack_counter_max
		exit("")
		return

func exit(exit_message : String = ""):
	actor.front_enemy_detection = false
	weapon.set__can_aim(true)
	weapon.set_active_hurtbox(false)
	on_exit.emit()
	state_time = 0
	state_machine.exit_state(exit_message, state_group_idx)
	on_exit.emit()
