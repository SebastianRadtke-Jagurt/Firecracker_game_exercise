extends Enemy

func _ready():
	events = {
		"take_damage" : $Events/take_damage as EventTakeDamage,
		"take_knockback" : $Events/take_knockback as EventTakeKnockback,
	}
	for event in events:
		events[event].init(self)
	state_groups[0].states = {
		"idle" : $States/idle as StateIdleMovement,
		"moving" : $States/StateMoving as StateMoving,
		"staggered" : $States/staggered as StateStaggered,
		"attack_1" : $States/StateWeaponAttack as StateWeaponAttack,
	}
	for state_group in state_groups:
		state_group.init(self)
	setup_states()
	
	ai_states = {
		"wandering" : $AI_States/Wandering as State,
		"approach" : $AI_States/Approach as State,
		"attacking" : $AI_States/Attacking as State,
	}
	ai_inputs = {
		"attacking" : false as bool
	}
	for state in ai_states:
		ai_states[state].init(self)
	decide_AI()
	current_state.enter()

func setup_states():
	state_groups[0].states["idle"].register_transition("attacking", "attack_1")
	state_groups[0].states["moving"].register_transition("attacking", "attack_1")

func _physics_process(delta):
	actor_phys_process(delta)
 
func decide_AI():
	if has_approached(GameManager.player_position):
		buffered_ai_state = "wandering"
		current_ai_state = ai_states["attacking"]
	else:
		current_ai_state = ai_states["approach"]
	current_ai_state.enter()
