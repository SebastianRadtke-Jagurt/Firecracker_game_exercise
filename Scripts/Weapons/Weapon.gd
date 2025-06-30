extends Node2D
class_name Weapon

@export var offset : Node2D
@export var hurtbox : Hurtbox
@export var anim_player : AnimationPlayer
@export var attack_sequences : Array[StateAttackSequence]
@export var starting_attack_cd : float = 1

@export var damage : int  = 1
@export var weapon_texture : Texture2D

var weapons_parent : Weapons
var actor : Actor

var buffered_attack : Attack

var attack_cooldown = 0
var attack_time : float = 0.25
var can_aim : bool = true

var charge : float = 0
@export var charge_max = 10
var charge_maxxed : bool:
	get:
		return charge >= charge_max

signal on_init(_actor : Actor)
signal on_init_state_machine(_actor : Actor, _state_machine : ActorStateMachine)
signal on_swap_in
signal on_swap_out

func init(parent : Weapons, _actor : Actor):
	weapons_parent = parent
	actor = _actor
	on_init.emit(actor)
	on_init_state_machine.emit(actor, actor.state_machine)

func _ready():
	attack_cooldown = starting_attack_cd

func _physics_process(delta):
	if attack_cooldown > 0: attack_cooldown -= delta

func play_sound(sound_name : String): weapons_parent.play_sound(sound_name)

func enter_attack(attack_sequence_idx : int): 
	attack_sequences[attack_sequence_idx].enter()

func execute_attack(delta, attack_sequence_idx : int): 
	attack_sequences[attack_sequence_idx].execute(delta)

func set_active_hurtbox(active : bool):
	hurtbox.enable_hurtbox(active, actor.hurtbox_mask, buffered_attack, get_attack_rotation())

func get_attack_rotation() -> Vector2:
	return Vector2.DOWN.rotated(global_rotation)

func buffer_attack(attack : Attack):
	attack_cooldown = attack.attack_time + attack.next_attack_delay
	buffered_attack = attack.duplicate()
	buffered_attack.damage += actor.mod_attack_damage

func reposition_weapon(delta):
	if !can_aim:
		return
	offset.rotation = lerp_angle(offset.rotation, 0, delta * 5)

func aim_weapon(delta, destination : Vector2, speed_multi : float):
	if !can_aim:
		return
	var rot_offset = -PI * 0.5
	rotation = lerp_angle(rotation, actor.get_angle_to(destination) + rot_offset, delta * speed_multi)

func set__can_aim(can : bool):
	can_aim = can

func cancel_anim():
	anim_player.stop()

func add_charge(value : float):
	charge += value
	# Update UI of weapon charge
	GameManager.game_menu.weapon_ultimate.update_bar(charge / charge_max * 100)

func swap_in():
	visible = true
	GameManager.game_menu.weapon_ultimate.update_texture(weapon_texture)
	on_swap_in.emit()

func swap_out():
	visible = false
	on_swap_out.emit()

func ultimate_enter():
	charge = 0

func ultimate_execute(_delta : float):
	pass

func ultimate_exit():
	pass

func get_ultimate_time() -> float:
	return attack_time
