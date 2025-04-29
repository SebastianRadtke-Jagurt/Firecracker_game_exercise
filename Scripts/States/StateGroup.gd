extends Node
class_name StateGroup

var states : Dictionary

@export var current_state : State
var previous_state : State
var buffered_state : String

func init(actor : Actor):
	for state in states:
		states[state].init(actor)

func buffer_state(state : String = ""): buffered_state = state

func exit_state(state_name : String):
	if state_name == "" && buffered_state != "":
		previous_state = current_state
		current_state = states[buffered_state]
	elif states.has(state_name):
		previous_state = current_state
		current_state = states[state_name]
	else:
		printerr("INVALID STATE!")
		return
	current_state.enter()

func rollback_state():
	if previous_state != null:
		current_state = previous_state
