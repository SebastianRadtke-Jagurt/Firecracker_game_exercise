extends CharacterBody2D
class_name Actor

var states : Dictionary
var events : Dictionary
var sounds : Dictionary

signal on_get_hit(damage : int, stagger : int, knockback : int, attack_dir : Vector2, attacker : Actor)
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
@export var hurtbox : Hurtbox
@export var attack_audio_player : AudioStreamPlayer2D
@export var weapon_root : Node2D
@export var weapon_offset : Node2D

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

var buffered_attack : Attack
var attack_cooldown = 0
@export var get_hit_cooldown_max : float = 0.2
var get_hit_cooldown : float = 0
var can_aim : bool = true
var can_clash_sword = false

func init():
	if hurtbox != null: hurtbox.init(self)

func actor_phys_process(delta):
	if get_hit_cooldown > 0: get_hit_cooldown -= delta
	if attack_cooldown > 0: attack_cooldown -= delta
	
	current_state.check_inputs()
	current_state.execute(delta)
	process_movement()

func process_movement():
	var negation = Vector2(-1 if knockback_vector.x < 0 else 1, -1 if knockback_vector.y < 0 else 1)
	knockback_vector -= (negation * knockback_vector * knockback_vector * air_drag)
	if knockback_vector.length() < 0.25:
		knockback_vector = Vector2.ZERO
	movement_vector += knockback_vector
	move_and_collide(movement_vector * movement_speed)
	movement_vector = Vector2.ZERO

func aim_weapon(delta, destination : Vector2, speed_multi : float):
	if !can_aim || weapon_root == null:
		return
	var offset = -PI * 0.5
	weapon_root.rotation = lerp_angle(weapon_root.rotation, get_angle_to(destination) + offset, delta * speed_multi) 

func set__can_aim(_can_aim : bool):
	self.can_aim = _can_aim

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

func buffer_state(state : String = ""):
	buffered_state = state

func rollback_state():
	if previous_state != null:
		current_state = previous_state

func exit_state(state : String = ""):
	if state == "" && buffered_state != "":
		previous_state = current_state
		current_state = states[buffered_state]
	elif states.has(state):
		previous_state = current_state
		current_state = states[state]
	else:
		printerr("INVALID STATE!")
		return
	
	current_state.enter()

func buffer_attack(attack : Attack):
	attack_cooldown = attack.attack_time + attack.next_attack_delay
	buffered_attack = attack.duplicate()
	buffered_attack.damage += mod_attack_damage

func enable_hurtbox(is_enabled : bool):
	if hurtbox == null:
		return
	
	hurtbox.enable_hurtbox(is_enabled, hurtbox_mask, buffered_attack, get_attack_rotation())

func get_input(_input : String) -> bool:
	return false

func get_hit(damage : int, stagger : int, knockback : int, attack_dir : Vector2, attacker : Actor):
	if get_hit_cooldown > 0:
		return
		
	current_state.state_time = 0
	attack_cooldown = 0
	get_hit_cooldown = get_hit_cooldown_max
	
	if attacker != null: attacker.on_hit.emit(self)
	
	on_get_hit.emit(damage, stagger, knockback, attack_dir, attacker)
	on_after_get_hit.emit(damage)
	
	if base_health <= 0:
		die()

func get_attack_rotation() -> Vector2:
	return Vector2.DOWN.rotated(weapon_root.rotation)

func reposition_weapon(delta):
	if !can_aim:
		return
	weapon_offset.rotation = lerp_angle(weapon_offset.rotation, 0, delta * 5)

func die():
	on_death.emit()
	var dp = GameManager.death_particles.instantiate()
	GameManager.game_parent.add_child(dp)
	dp.init(global_position)
	queue_free()
