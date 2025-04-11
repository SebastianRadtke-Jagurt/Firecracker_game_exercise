extends Enemy

func _ready():
	init()
	events = {
		"take_damage" : $Events/take_damage as EventTakeDamage,
		"take_knockback" : $Events/take_knockback as EventTakeKnockback,
		"take_deflect" : $Events/take_deflect as EventTakeDeflect,
	}
	for event in events:
		events[event].init(self)
	states = {
		"idle" : $States/idle as StateIdle,
		"moving" : $States/StateMoving as StateMoving,
		"attack_1" : $States/StateAttackSequence as StateAttackSequence,
		"staggered" : $States/staggered as StateStaggered,
	}
	for state in states:
		states[state].init(self)
	setup_states()
	
	ai_states = {
		"position" : $AI_States/PositionBehind as State
	}
	ai_inputs = {
		"attacking" : false as bool
	}
	for state in ai_states:
		ai_states[state].init(self)
	decide_AI()
	current_state.enter()

func setup_states():
	states["idle"].register_transition("attacking", "attack_1")
	states["moving"].register_transition("attacking", "attack_1")

func _physics_process(delta):
	actor_phys_process(delta)
 
func decide_AI():
	current_ai_state = ai_states["position"]
	current_ai_state.enter()
