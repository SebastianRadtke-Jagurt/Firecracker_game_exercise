extends Actor

func _ready():
	hurtbox = $sword_root/sword_offset/sword_parent/hurtbox_Area2D
	events = {
		"take_damage" : $Events/take_damage as EventTakeDamage,
		"take_knockback" : $Events/take_knockback as EventTakeKnockback,
	}
	for event in events:
		events[event].init(self)
	states = {
		"idle" : $States/idle as StateIdle,
		"staggered" : $States/staggered as StateStaggered,
	}
	for state in states:
		states[state].init(self)
	current_state.enter()

func _physics_process(delta):
	actor_phys_process(delta)
