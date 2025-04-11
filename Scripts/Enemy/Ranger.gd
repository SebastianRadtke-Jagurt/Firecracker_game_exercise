extends Enemy

func _ready():
	init()
	events = {
		"take_damage" : $Events/take_damage as EventTakeDamage,
		"take_knockback" : $Events/take_knockback as EventTakeKnockback,
	}
	for event in events:
		events[event].init(self)
	states = {
		"idle" : $States/idle as StateIdle,
		"moving" : $States/StateMoving as StateMoving,
		"staggered" : $States/staggered as StateStaggered,
		"attack_1" : $States/StateAttackSequence as StateAttackSequence,
	}
	for state in states:
		states[state].init(self)
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
	attack_cooldown = 1
	current_state.enter()

func setup_states():
	states["idle"].register_transition("attacking", "attack_1")
	states["moving"].register_transition("attacking", "attack_1")

func _physics_process(delta):
	actor_phys_process(delta)
 
func decide_AI():
	if has_approached(GameManager.player_position):
		buffered_ai_state = "wandering"
		current_ai_state = ai_states["attacking"]
	else:
		current_ai_state = ai_states["approach"]
	current_ai_state.enter()

func shoot():
	var new_arrow = GameManager.arrow.instantiate()
	GameManager.game_parent.add_child(new_arrow)
	(new_arrow as Projectile).global_position = weapon_offset.global_position
	(new_arrow as Projectile).shoot(Vector2.DOWN.rotated(weapon_offset.global_rotation), \
								buffered_attack, \
								hurtbox_mask,
								3)
