extends Actor

func _ready():
	hurtbox = $sword_root/sword_offset/sword_parent/hurtbox_Area2D
	states = {
		"idle" : $States/idle as StateIdle,
		"staggered" : $States/staggered as StateStaggered,
		"take_damage" : $States/take_damage as StateTakeDamage,
		"take_knockback" : $States/take_knockback as StateTakeKnockback
	}
	for state in states:
		states[state].init(self)
	current_state.enter()

func _physics_process(delta):
	actor_phys_process(delta)
