extends State
class_name StateAttackSequence

@export var weapon : Weapon

var attacks : Array[Attack]
var attack_counter : int = 0
var attack_counter_max : int:
	get:
		return attacks.size()
var animation_name : String:
	get:
		return attacks[attack_counter].animation_name
var sequence_continuity_timer : float = 0
var sequence_continuity_timer_max : float = 0.75
var next_attack_delay : float = 0
var attack_dir : Vector2

func _ready():
	for child in get_children():
		if child is Attack: attacks.append(child as Attack)

func init(_actor : Actor):
	super.init(_actor)
	actor.on_after_get_hit.connect(on_after_get_hit)

func _physics_process(delta):
	sequence_fall_out(delta)

func enter():
	if state_time > 0 || weapon.attack_cooldown > 0:
		if actor is Enemy:
			actor.decide_AI()
			return
		else: 
			actor.rollback_state(state_group_idx)
			return
	
	actor.buffer_state("idle", state_group_idx)
	actor.set__can_get_hit(true)
	weapon.buffer_attack(attacks[attack_counter])
	attacks[attack_counter].play()
	attack_dir = weapon.get_attack_rotation()
	weapon.set__can_aim(false)

func execute(delta : float):
	self.state_time += delta
	actor.global_position += attack_dir * attacks[attack_counter].displacement
	
	if self.state_time > attacks[attack_counter].attack_time:
		sequence_continuity_timer = sequence_continuity_timer_max
		attack_counter = (attack_counter + 1) % attack_counter_max
		exit("")
		return

func check_inputs():
	for transition in transitions:
		if actor.get_input(transition.input_name):
			actor.buffer_state(transition.state_name, state_group_idx)
			return

func sequence_fall_out(delta):
	if sequence_continuity_timer > 0:
		sequence_continuity_timer -= delta
		await get_tree().physics_frame
		if sequence_continuity_timer <= 0:
			attack_counter = 0

func exit(exit_message : String = ""):
	weapon.set__can_aim(true)
	weapon.set_active_hurtbox(false)
	super.exit(exit_message)

# Band-aid!
# TODO: Investigate
# When getting hit right after starting an attack, 
# Attacking becomes impossible
func on_after_get_hit(_d):
	state_time = 0
