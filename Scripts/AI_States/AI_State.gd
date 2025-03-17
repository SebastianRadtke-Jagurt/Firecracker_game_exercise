extends State
class_name AI_State

func exit(next_ai_state : String = ""):
	state_time = 0
	actor.exit_ai_state(next_ai_state)
