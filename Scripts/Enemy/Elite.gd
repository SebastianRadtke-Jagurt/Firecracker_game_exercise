extends Enemy

func _ready():
	init()
	states = {
		"idle" : $States/idle as StateIdle,
		"moving" : $States/StateMoving as StateMoving,
		"attack_1" : $States/StateAttackSequence as StateAttackSequence,
		"attack_2" : $States/StateAttackSequence2 as StateAttackSequence,
		"staggered" : $States/staggered as StateStaggered,
		"take_damage" : $States/take_damage as StateTakeDamage,
		"take_knockback" : $States/take_knockback as StateTakeKnockback,
		"take_deflect" : $States/take_deflect as State,
	}
	for state in states:
		states[state].init(self)
	setup_states()
	
	ai_states = {
		"attacking" : $AI_States/Charge_Attack as State,
	}
	ai_inputs = {
		"attack_1" : false as bool,
		"attack_2" : false as bool,
	}
	for state in ai_states:
		ai_states[state].init(self)
	decide_AI()
	current_state.enter()

func setup_states():
	states["idle"].register_transition("attack_1", "attack_1")
	states["moving"].register_transition("attack_1", "attack_1")
	states["idle"].register_transition("attack_2", "attack_2")
	states["moving"].register_transition("attack_2", "attack_2")

func _physics_process(delta):
	actor_phys_process(delta)
 
func decide_AI():
	current_ai_state = ai_states["attacking"]
	current_ai_state.enter()
