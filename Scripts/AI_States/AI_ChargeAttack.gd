extends AI_State

@export var approached_min = 50
@export var approached_max = 70
@export var attacking_angle = 15

func execute(delta):
	actor.weapons.current_weapon.aim_weapon(delta, GameManager.player_position, 3)
	var angle_to_player = actor.global_position.direction_to(GameManager.player_position).angle()
	var aiming_angle = Vector2.DOWN.angle() + actor.weapons.current_weapon.offset.global_rotation
	var aim_to_player = rad_to_deg(angle_difference(angle_to_player, aiming_angle))
	var dist_to_player = actor.global_position.distance_to(GameManager.player_position)
	
	#Always attack if player is too close
	if actor.weapons.current_weapon.attack_cooldown <= 0 && aim_to_player * aim_to_player < attacking_angle * attacking_angle:
		if dist_to_player < approached_min:
			actor.set_input("attack_1", true)
		# Position to charge attack
		elif dist_to_player < approached_max:
			actor.set_input("attack_2", true)
	else:
		actor.weapons.current_weapon.aim_weapon(delta, GameManager.player_position, 3)
	
		var dir = actor.global_position.direction_to(GameManager.player_position)
		var movement_destination = GameManager.player_position - dir * (actor.approach_distance_min + actor.approach_distance_max) / 2
		actor.movement_input = actor.global_position.direction_to(movement_destination) * actor.movement_speed
