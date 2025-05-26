extends Actor
class_name Player

var mouse_pos : Vector2 = Vector2.ZERO
@export var cam : Camera2D
@export var game : Game

signal exit_choice(weapon_idx : int)

func _ready():
	GameManager.player = self
	game.set_health_bar_max(base_health)
	on_after_get_hit.connect(update_health_bar)
	on_death.connect(game.on_lose)
	events = {
		"take_damage" : $Events/take_damage as EventTakeDamage,
		"take_knockback" : $Events/take_knockback as EventTakeKnockback,
	}
	for event in events:
		events[event].init(self)
	state_groups[0].states = {
		"idle" : $States/idle as StateIdleMovement,
		"moving" : $States/moving as StateMoving,
		"dashing" : $States/dashing as StateDashing,
		"staggered" : $States/staggered as StateStaggered,
		"attack_1" : $States/weapon_attack as StateWeaponAttack,
		"swap_weapon_check" : $States/swap_weapon_check as StateSwapWeaponCheck,
		"ultimate_swap_weapon" : $States/swap_weapon_ultimate as StateSwapWeaponUltimate
	}
	state_groups[1].states = {
		"swap_weapons" : $States2/swap_weapons as StateSwapWeapons,
		"nothing" : $States2/nothing as State
	}
	for state_group in state_groups:
		state_group.init(self)
		
	setup_states()
	restore_default_state()
	current_state.enter()

func setup_states():
	state_groups[0].states["idle"].register_transition("ui_accept", "dashing")
	state_groups[0].states["idle"].register_transition("attack_1", "attack_1")
	state_groups[0].states["moving"].register_transition("ui_accept", "dashing")
	state_groups[0].states["moving"].register_transition("attack_1", "attack_1")
	state_groups[0].states["dashing"].register_transition("ui_accept", "dashing")
	state_groups[0].states["dashing"].register_transition("attack_1", "attack_1")
	state_groups[0].states["attack_1"].register_transition("ui_accept", "dashing")
	
	state_groups[0].states["idle"].register_transition("swap_weapons", "swap_weapon_check")
	state_groups[0].states["moving"].register_transition("swap_weapons", "swap_weapon_check")
	state_groups[0].states["dashing"].register_transition("swap_weapons", "swap_weapon_check")
	state_groups[0].states["attack_1"].register_transition("swap_weapons", "swap_weapon_check")

func _physics_process(delta):
	movement_input = Input.get_vector("left", "right", "up", "down")
	weapons.current_weapon.aim_weapon(delta, mouse_pos, 10)
	actor_phys_process(delta)
	GameManager.player_position = global_position
	GameManager.player_weapon_rotation = weapons.current_weapon.rotation

func _input(event):
	if event is InputEventMouseMotion:
		mouse_pos = cam.get_global_mouse_position()

func get_input(input : String) -> bool:
	return Input.is_action_just_pressed(input)

func restore_default_state():
	set__can_aim(true)
	set__can_get_hit(true)
	weapons.current_weapon.set_active_hurtbox(false)
	state_groups[0].buffer_state("")
	state_groups[0].current_state = state_groups[0].states["idle"]
	state_groups[0].current_state.enter()
	state_groups[1].current_state = null

func update_health_bar(_damage : int):
	game.set_health_bar(base_health)
