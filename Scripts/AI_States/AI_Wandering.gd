extends AI_State

var destination : Vector2 = Vector2.ZERO
var vector : Vector2 = Vector2.ZERO
var approach_distance_min : int
var approach_distance_max : int

func init(_actor : Actor, _state_machine : ActorStateMachine):
	super.init(_actor, _state_machine)
	approach_distance_min = (actor as Enemy).approach_distance_min
	approach_distance_max = (actor as Enemy).approach_distance_max

func enter():
	vector = GameManager.player_position.direction_to(actor.global_position)
	vector = vector.rotated(deg_to_rad(randi_range(-45, 45)))
	destination = GameManager.player_position + (vector * randi_range(approach_distance_min, approach_distance_max))

func execute(delta):
	state_time += delta
	actor.weapons.current_weapon.aim_weapon(delta, GameManager.player_position, 3)
	var dir = actor.global_position.direction_to(destination)
	actor.movement_input = dir * actor.movement_speed
	if actor.global_position.distance_to(destination) <= 1 \
	|| state_time > state_time_max:
		exit("")
		return

