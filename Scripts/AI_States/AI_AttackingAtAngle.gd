extends AI_State

@export var daring_to_attack_angle = 45

func enter():
	actor.buffer_state("idle")
	var angle_to_enemy = Vector2.UP.angle() + GameManager.player_position.direction_to(actor.global_position).angle()
	var angle_diff = rad_to_deg(angle_difference(GameManager.player_rotation, angle_to_enemy))
	if angle_diff * angle_diff > daring_to_attack_angle * daring_to_attack_angle && actor.attack_cooldown <= 0:
		actor.set_input("attacking", true)
	
	exit("")

func execute(_delta):
	pass
