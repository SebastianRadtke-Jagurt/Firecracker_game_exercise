extends Actor
class_name Player

var mouse_pos : Vector2 = Vector2.ZERO
@export var cam : Camera2D
@export var game : Game

func _ready():
	init()
	game.set_health_bar_max(base_health)
	on_after_get_hit.connect(update_health_bar)
	on_death.connect(game.on_lose)
	
	states = {
		"idle" : $States/idle as StateIdle,
		"moving" : $States/moving as StateMoving,
		"dashing" : $States/dashing as StateDashing,
		"staggered" : $States/staggered as StateStaggered,
		"attack_1" : $States/attack_seq_1 as StateAttackSequence,
		"take_damage" : $States/take_damage as StateTakeDamage,
		"take_knockback" : $States/take_knockback as StateTakeKnockback,
	}
	for state in states:
		states[state].init(self)
	setup_states()
	restore_default_state()
	current_state.enter()

func setup_states():
	states["idle"].register_transition("ui_accept", "dashing")
	states["idle"].register_transition("attack_1", "attack_1")
	#states["idle"].register_transition("attack_2", "attack_2")
	states["moving"].register_transition("ui_accept", "dashing")
	states["moving"].register_transition("attack_1", "attack_1")
	#states["moving"].register_transition("attack_2", "attack_2")
	states["dashing"].register_transition("ui_accept", "dashing")
	states["dashing"].register_transition("attack_1", "attack_1")
	#states["dashing"].register_transition("attack_2", "attack_2")
	states["attack_1"].register_transition("ui_accept", "dashing")

func _physics_process(delta):
	movement_input = Input.get_vector("left", "right", "up", "down")
	aim_weapon(delta, mouse_pos, 10)
	actor_phys_process(delta)
	GameManager.player_position = global_position
	GameManager.player_rotation = weapon_root.rotation

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = cam.get_global_mouse_position()

func get_input(input : String) -> bool:
	return Input.is_action_just_pressed(input)

func restore_default_state():
	set__can_aim(true)
	set__can_get_hit(true)
	enable_hurtbox(false)
	buffer_state("")
	current_state = states["idle"]
	current_state.enter()

func update_health_bar(_damage : int):
	game.set_health_bar(base_health)
