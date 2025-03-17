extends AI_State

func execute(delta):
	actor.aim_weapon(delta, GameManager.player_position, 3)
	
	var dir = actor.global_position.direction_to(GameManager.player_position)
	var movement_destination = GameManager.player_position - dir * (actor.approach_distance_min + actor.approach_distance_max) / 2
	actor.movement_input = actor.global_position.direction_to(movement_destination) * actor.movement_speed
	
	if actor.global_position.distance_to(movement_destination) < 5:
		exit("")
		return
