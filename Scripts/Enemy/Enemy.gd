extends Actor
class_name Enemy

var current_ai_state : State
var ai_states : Dictionary
var buffered_ai_state : String
var ai_inputs : Dictionary

@export var approach_distance_min : int = 60
@export var approach_distance_max : int = 70

func has_approached(destination) -> bool:
	return global_position.distance_to(destination) < approach_distance_max \
		&& global_position.distance_to(destination) > approach_distance_min

func decide_AI():
	pass

func exit_ai_state(ai_state : String = ""):
	if ai_state == "":
		if buffered_ai_state == "":
			decide_AI()
		else:
			current_ai_state = ai_states[buffered_ai_state]
			buffered_ai_state = ""
	elif ai_states.has(ai_state):
		current_ai_state = ai_states[ai_state]
	else:
		printerr("INVALID STATE!")
		return
	
	current_ai_state.enter()

func actor_phys_process(delta):
	current_ai_state.execute(delta)
	super.actor_phys_process(delta)
	
	if !(state_machine.current_state is StateAttackSequence):
		weapons.current_weapon.reposition_weapon(delta)
		
	for input in ai_inputs:
		ai_inputs[input] = false

func get_input(input : String = "") -> bool:
	if ai_inputs.has(input):
		return ai_inputs[input]
	return false

func set_input(input : String, value : bool) -> bool:
	if ai_inputs.has(input):
		ai_inputs[input] = value
		return true
	printerr("COUDLN'T FIND INPUT ON AN ACTOR")
	return false
