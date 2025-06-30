extends Weapon
class_name Axe

@onready var ultimates_state_machine : ActorStateMachine = ActorStateMachine.new() 
@onready var u_slam_area : Area2D = $weapon_offset/weapon_parent/u_slam_Area2D

var current_swings_count : int = 0
var swings_count : int = 12

var saved_damage : int = 0
var ultimate_input : String = ""

func _ready():
	super._ready()
	ultimates_state_machine.new_state_group({
		"swing" : $ultimate_swinging as StateAttackSequence,
		"slam" : $ultimate_slam as StateAttackSequence,
		"nothing" : $nothing as State,
	})
	
	ultimates_state_machine.state_groups[0].states["swing"].register_transition("swing", "swing")
	ultimates_state_machine.state_groups[0].states["swing"].register_transition("slam", "slam")

func init(parent : Weapons, _actor : Actor):
	super.init(parent, _actor)
	ultimates_state_machine.get_input = func(input : String): return ultimate_input == input
	for state_group in ultimates_state_machine.state_groups:
		state_group.init(actor, ultimates_state_machine)

func swap_in():
	super.swap_in()
	actor.on_hit.connect(add_axe_charge)

func add_axe_charge(_a : Actor):
	add_charge(2)

func swap_out():
	actor.on_hit.disconnect(add_axe_charge)
	super.swap_out()

func ultimate_enter():
	saved_damage = 0
	current_swings_count = 0
	ultimates_state_machine.state_groups[0].current_state = ultimates_state_machine.state_groups[0].states["swing"]
	ultimates_state_machine.state_groups[0].current_state.enter()
	ultimate_input = "swing"
	actor.on_get_hit.connect(save_damage)
	u_slam_area.monitoring = true

func ultimate_execute(delta):
	ultimates_state_machine.phys_process(delta)

func ultimate_exit():
	actor.on_get_hit.disconnect(save_damage)
	u_slam_area.monitoring = false
	saved_damage = 0

func save_damage(_damage : int, _stagger : int, _knockback : int, _attack_dir : Vector2, _attacker : Actor):
	saved_damage = _damage

func swing_count_up():
	current_swings_count += 1
	global_rotation = actor.get_angle_to((actor as Player).mouse_pos) + (-PI * 0.5)
	ultimate_input = "swing" if current_swings_count < swings_count else "slam"

func slam():
	actor.health = min(actor.base_health, actor.health + saved_damage)
	for body in u_slam_area.get_overlapping_bodies():
		if body is Actor:
			var _attack_damage = damage * 3 + actor.mod_attack_damage + saved_damage
			var _attack_stagger = 5
			var _attack_knockback = 3
			var attack_dir = global_position.direction_to(body.global_position)
			body.get_hit(_attack_damage, _attack_stagger, _attack_knockback, attack_dir, actor)

func get_ultimate_time() -> float:
	return swings_count * anim_player.get_animation("u_swing").length + anim_player.get_animation("u_slam").length
