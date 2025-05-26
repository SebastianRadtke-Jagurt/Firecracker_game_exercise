extends State
class_name StateDashing

var dashing_vector : Vector2
@export var dashing_speed : float = 2
var dashing_cooldown : float
@export var dashing_cooldown_max : float = 1

func enter():
	actor.buffer_state("idle", state_group_idx)
	if dashing_cooldown > 0:
		exit("")
		return
	actor.set__can_get_hit(false)
	actor.play_animation("dashing")
	dashing_vector = actor.movement_input
	
	var dash_particles = GameManager.dash_refresh_particles.instantiate()
	actor.add_child(dash_particles)
	dash_particles.init(actor.global_position)

func execute(delta):
	actor.global_position += dashing_vector * dashing_speed
	state_time += delta
	if state_time >= state_time_max:
		exit("")
		return

func check_inputs():
	for transition in transitions:
		if actor.get_input(transition.input_name) && transition.active:
			actor.buffer_state(transition.state_name, state_group_idx)
			return

func cooldown():
	dashing_cooldown = dashing_cooldown_max
	while dashing_cooldown > 0:
		dashing_cooldown -= get_physics_process_delta_time()
		await get_tree().physics_frame

func exit(exit_message : String = ""):
	cooldown()
	super.exit(exit_message)
