extends Node
class_name ActorStateMachine

@export var state_groups : Array[StateGroup]

@export var current_state : State
var previous_state : State
var buffered_state : String

var get_input : Callable
var get_movement_vector : Callable

func new_state_group(states_dict : Dictionary):
	var new_ST : StateGroup = StateGroup.new()
	new_ST.states = states_dict.duplicate()
	state_groups.append(new_ST)

func buffer_state(state : String, state_group_idx : int):
	state_groups[state_group_idx].buffered_state = state

func rollback_state(state_group_idx : int):
	state_groups[state_group_idx].rollback_state()

func exit_state(state : String, state_group_idx : int): 
	state_groups[state_group_idx].exit_state(state)

func phys_process(delta):
	for state_group in state_groups:
		if state_group.current_state == null: continue
		state_group.current_state.check_inputs()
		state_group.current_state.execute(delta)

func set_active_transition(state_name, active):
	for state_group in state_groups:
		for state in state_group.states:
			for transition in state_group.states[state].transitions:
				if transition.state_name == state_name:
					transition.active = active
