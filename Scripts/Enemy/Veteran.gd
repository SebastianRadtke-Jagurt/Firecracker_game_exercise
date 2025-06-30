extends Enemy

func _ready():
	events = {
		"take_damage" : $Events/take_damage as EventTakeDamage,
		"take_knockback" : $Events/take_knockback as EventTakeKnockback,
		"take_deflect" : $Events/take_deflect as EventTakeDeflect,
	}
	for event in events:
		events[event].init(self)
	state_machine.new_state_group({
		"idle" : $States/idle as StateIdleMovement,
		"moving" : $States/StateMoving as StateMoving,
		"attack_1" : $States/StateWeaponAttack as StateWeaponAttack,
		"staggered" : $States/staggered as StateStaggered,
	})
	for state_group in state_machine.state_groups:
		state_group.init(self, state_machine)
	setup_states()
	
	ai_states = {
		"position" : $AI_States/PositionBehind as State
	}
	ai_inputs = {
		"attack_1" : false as bool
	}
	for state in ai_states:
		ai_states[state].init(self, state_machine)
	weapons.init()
	decide_AI()
	state_machine.state_groups[0].current_state = state_machine.state_groups[0].states["idle"]
	state_machine.state_groups[0].current_state.enter()
	super._ready()

func setup_states():
	state_machine.state_groups[0].states["idle"].register_transition("attack_1", "attack_1")
	state_machine.state_groups[0].states["moving"].register_transition("attack_1", "attack_1")

func _physics_process(delta):
	actor_phys_process(delta)
 
func decide_AI():
	current_ai_state = ai_states["position"]
	current_ai_state.enter()
