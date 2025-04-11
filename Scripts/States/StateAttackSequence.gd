extends State
class_name StateAttackSequence

var attacks : Array[Attack]
var attack_counter : int = 0
var attack_counter_max : int:
	get:
		return attacks.size()
var sequence_continuity_timer : float = 0
var sequence_continuity_timer_max : float = 0.75
var next_attack_delay : float = 0
var attack_dir : Vector2

func _ready():
	for child in get_children():
		if child is Attack: attacks.append(child as Attack)

func _physics_process(delta):
	sequence_fall_out(delta)

func enter():
	if state_time > 0 || actor.attack_cooldown > 0:
		if actor is Enemy:
			actor.decide_AI()
			return
		else: 
			actor.rollback_state()
			return
	
	actor.buffer_state("idle")
	actor.set__can_get_hit(true)
	actor.buffer_attack(attacks[attack_counter])
	actor.play_animation(attacks[attack_counter].animation_name)
	attack_dir = actor.get_attack_rotation()
	actor.set__can_aim(false)

func execute(delta : float):
	state_time += delta
	actor.global_position += attack_dir * attacks[attack_counter].displacement
	
	if state_time > attacks[attack_counter].attack_time:
		sequence_continuity_timer = sequence_continuity_timer_max
		attack_counter = (attack_counter + 1) % attack_counter_max
		exit("")
		return

func check_inputs():
	for transition in transitions:
		if actor.get_input(transition.input_name):
			actor.buffer_state(transition.state_name)
			return

func sequence_fall_out(delta):
	if sequence_continuity_timer > 0:
		sequence_continuity_timer -= delta
		await get_tree().physics_frame
		if sequence_continuity_timer <= 0:
			attack_counter = 0

func exit(exit_message : String = ""):
	actor.set__can_aim(true)
	actor.enable_hurtbox(false)
	super.exit(exit_message)
