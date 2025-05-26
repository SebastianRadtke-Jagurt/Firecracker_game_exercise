extends CharacterBody2D
class_name Actor

@export var state_groups : Array[StateGroup]
var events : Dictionary
var sounds : Dictionary

signal on_get_hit_check
var get_hit_abort : bool = false
signal on_get_hit(damage : int, stagger : int, knockback : int, attack_dir : Vector2, attacker : Actor)
signal on_get_hit_deny
signal on_after_get_hit(damage : int)
signal on_death
signal on_hit(attacked : Actor)
signal on_sword_clash(clashed_actor: Actor)

#region Stats
@export_group("Base Stats", "base")
@export var base_health : int = 10
@export var base_movement_speed : float = 1

@export_group("Stat Mods", "mod")
@export var mod_movement_speed : float = 0
@export var mod_attack_damage : int = 0
#endregion

@export var anim_player : AnimationPlayer
@export var attack_audio_player : AudioStreamPlayer2D
@export var weapons : Weapons

@export var hitbox_layer : int
@export var hurtbox_mask : int

@export var current_state : State
var previous_state : State
var buffered_state : String

var air_drag : float = 0.1
var movement_input : Vector2
var movement_vector : Vector2 = Vector2.ZERO
var knockback_vector : Vector2 = Vector2.ZERO
var movement_speed : float : 
	get :
		return base_movement_speed + mod_movement_speed

@export var get_hit_cooldown_max : float = 0.2
var get_hit_cooldown : float = 0

func actor_phys_process(delta):
	if get_hit_cooldown > 0: get_hit_cooldown -= delta
	
	for state_group in state_groups:
		if state_group.current_state == null: continue
		state_group.current_state.check_inputs()
		state_group.current_state.execute(delta)
	
	process_movement()

func process_movement():
	var negation = Vector2(-1 if knockback_vector.x < 0 else 1, -1 if knockback_vector.y < 0 else 1)
	knockback_vector -= (negation * knockback_vector * knockback_vector * air_drag)
	if knockback_vector.length() < 0.25:
		knockback_vector = Vector2.ZERO
	movement_vector += knockback_vector
	move_and_collide(movement_vector * movement_speed)
	movement_vector = Vector2.ZERO

func set__can_aim(_can_aim : bool): weapons.current_weapon.can_aim = _can_aim

func play_animation(anim_name : String): 
	anim_player.play(anim_name)

func play_sound(sound_name : String):
	if sound_name != "":
		attack_audio_player.stream = GameManager.get_sound(sound_name)
		attack_audio_player.play()

func set__can_get_hit(can_get_hit: bool): 
	set_collision_layer_value(hitbox_layer, can_get_hit)

func set__can_get_deflected(_can_get_deflected : bool):
	self.can_clash_sword = _can_get_deflected

func set_active_transition(state_name, active):
	for state_group in state_groups:
		for state in state_group.states:
			for transition in state_group.states[state].transitions:
				if transition.state_name == state_name:
					transition.active = active

func buffer_state(state : String, state_group_idx : int):
	state_groups[state_group_idx].buffered_state = state

func rollback_state(state_group_idx : int):
	state_groups[state_group_idx].rollback_state()

func exit_state(state : String, state_group_idx : int): 
	state_groups[state_group_idx].exit_state(state)

func get_input(_input : String) -> bool:
	return false

func get_hit(damage : int, stagger : int, knockback : int, attack_dir : Vector2, attacker : Actor):
	if get_hit_cooldown > 0:
		return
	
	on_get_hit_check.emit()
	
	if get_hit_abort:
		get_hit_abort = false
		on_get_hit_deny.emit()
		return
	
	current_state.state_time = 0
	get_hit_cooldown = get_hit_cooldown_max
	
	if attacker != null: 
		attacker.on_hit.emit(self)
	
	on_get_hit.emit(damage, stagger, knockback, attack_dir, attacker)
	on_after_get_hit.emit(damage)
	
	if base_health <= 0:
		die()

func die():
	on_death.emit()
	var dp = GameManager.death_particles.instantiate()
	GameManager.game_parent.add_child(dp)
	dp.init(global_position)
	queue_free()
