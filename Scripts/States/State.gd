extends Node
class_name State

var state_time : float = 0
@export var state_time_max : float = 1
var actor : Actor

var transitions : Array[Transition]

func init(_actor : Actor):
	self.actor = _actor

func enter():
	pass

func execute(_delta : float):
	if self is State:
		printerr("Abstract State!")
		return
	pass

func check_inputs():
	for transition in transitions:
		if actor.get_input(transition.input_name):
			exit(transition.state_name)
			return

func exit(exit_message : String = ""):
	state_time = 0
	actor.exit_state(exit_message)

func register_transition(input_name : String, state_name : String):
	transitions.append(Transition.new(input_name, state_name))

class Transition:
	var input_name : String
	var state_name : String
	
	func _init(_input_name : String, _state_name : String):
		input_name = _input_name
		state_name = _state_name
