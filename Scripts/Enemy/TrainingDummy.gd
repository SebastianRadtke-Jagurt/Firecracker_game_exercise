extends Actor

func _ready():
	events = {
		"take_damage" : $Events/take_damage as EventTakeDamage,
		"take_knockback" : $Events/take_knockback as EventTakeKnockback,
	}
	for event in events:
		events[event].init(self)
	state_machine.state_groups[0].states = {
		"idle" : $States/idle as StateIdleMovement,
		"staggered" : $States/staggered as StateStaggered,
	}
	for state_group in state_machine.state_groups:
		state_group.init(self, state_machine)
	state_machine.current_state.enter()

func _physics_process(delta):
	actor_phys_process(delta)
