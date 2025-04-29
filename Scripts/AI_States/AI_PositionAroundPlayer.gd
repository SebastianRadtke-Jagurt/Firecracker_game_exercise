extends AI_State

@export var angle_offset = 180
@export var angle_window = 45
@export var approached_min = 50
@export var approached_max = 70

func execute(delta):
	actor.weapons.current_weapon.aim_weapon(delta, GameManager.player_position, 3)
	var player_fwd = Vector2.DOWN.rotated(GameManager.player_weapon_rotation)
	var target_pos = GameManager.player_position - (player_fwd * (approached_min + approached_max)/2)
	var angle_diff = rad_to_deg(angle_difference(GameManager.player_weapon_rotation, actor.weapons.current_weapon.offset.global_rotation))
	var to_target = actor.global_position.direction_to(target_pos)
	var dist_to_player = actor.global_position.distance_to(GameManager.player_position)
	var angle_rotating = rad_to_deg(angle_difference(GameManager.player_weapon_rotation, actor.global_rotation))
	#Always attack if player is too close
	if dist_to_player < approached_min && actor.weapons.current_weapon.attack_cooldown <= 0:
		actor.set_input("attack_1", true)
	#When at correct distance, attack from behind
	elif dist_to_player < approached_max:
		if angle_diff * angle_diff < angle_window * angle_window && actor.weapons.current_weapon.attack_cooldown <= 0:
			actor.set_input("attack_1", true)
		# if not behind, circle player to be behind
		else: 
			to_target = to_target.rotated(deg_to_rad(clampf(angle_rotating, -90, 90)))
	
	actor.movement_input = to_target * actor.movement_speed
