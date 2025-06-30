extends Node
class_name State

var state_time : float = 0
@export var state_time_max : float = 1
@export var state_group_idx : int = 0
var actor : Actor
var state_machine : ActorStateMachine
var transitions : Array[Transition]

signal on_exit

func init(_actor : Actor, _state_machine : ActorStateMachine):
	actor = _actor
	state_machine = _state_machine

func enter():
	pass

func execute(_delta : float):
	if self is State:
		printerr("Abstract State!")
		return
	pass

func check_inputs():
	for transition in transitions:
		if state_machine.get_input.call(transition.input_name) && transition.active:
			exit(transition.state_name)
			return

func exit(exit_message : String = ""):
	self.state_time = 0
	state_machine.exit_state(exit_message, state_group_idx)
	on_exit.emit()

func register_transition(input_name : String, state_name : String):
	transitions.append(Transition.new(input_name, state_name))

class Transition:
	var input_name : String
	var state_name : String
	var active : bool = true
	
	func _init(_input_name : String, _state_name : String):
		input_name = _input_name
		state_name = _state_name
