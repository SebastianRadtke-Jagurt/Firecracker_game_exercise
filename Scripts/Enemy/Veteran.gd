extends Enemy

func _ready():
	init()
	states = {
		"idle" : $States/idle as StateIdle,
		"moving" : $States/StateMoving as StateMoving,
		"attack_1" : $States/StateAttackSequence as StateAttackSequence,
		"staggered" : $States/staggered as StateStaggered,
		"take_damage" : $States/take_damage as StateTakeDamage,
		"take_knockback" : $States/take_knockback as StateTakeKnockback,
		"take_deflect" : $States/take_deflect as State,
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
