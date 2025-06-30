extends Weapon
class_name Sword

@onready var zone : Area2D = $Zone

var can_clash_sword = false

var counter_hit_count : int = 5
var current_counter_hit_count : int = 0
var damage_multiplier : float = 5

var zone_base_radius : Vector2
var zone_radius = 128

var counter_time : float = 5.0

var current_time : float = 0
var stage : int = 0

func _ready():
	zone_base_radius = zone.scale

func ultimate_enter():
	super.ultimate_enter()
	#Enter a counter state
	# 1. Create circular zone (graphic) 
	stage = 0
	add_charge(0)
	current_time = counter_time
	zone.visible = true
	zone.monitoring = true
	zone.scale = zone_base_radius * Vector2(zone_radius/10 ,zone_radius/10)
	# 1.1? Decal/vfx on enemies inside the zone
	# 2. When hit create circular physics cast for enemies and
	#    any enemies in the cast are dealt 5x sword damage
	actor.on_get_hit_check.connect(check_counter)
	actor.on_get_hit_deny.connect(cast_counter.bind(damage))

func ultimate_execute(delta : float):
	if current_time > 0:
		if stage == 0:
			if(actor.movement_input != Vector2.ZERO):
				actor.movement_vector += actor.movement_input * 0.2
		else:
			pass
	
	current_time -= delta
	if current_time <= 0:
		stage += 1
		if stage == 1:
			anim_player.play("ultimate")
			actor.get_hit_cooldown += attack_time
			if current_counter_hit_count == 0:
				cast_counter(damage * 5)
				current_counter_hit_count = counter_hit_count + 1
				await get_tree().create_timer(attack_time).timeout
				ultimate_exit()

func ultimate_exit():
	zone.visible = false
	zone.monitoring = false
	actor.state_machine.set_active_transition("attack_1", true)
	actor.state_machine.set_active_transition("dashing", true)
	if actor.on_get_hit_check.is_connected(check_counter):
		actor.on_get_hit_check.disconnect(check_counter)
	if actor.on_get_hit_deny.is_connected(cast_counter):
		actor.on_get_hit_deny.disconnect(cast_counter)

func check_counter():
	actor.get_hit_abort = true

func cast_counter(counter_damage : int):
	current_counter_hit_count += 1
	for body in zone.get_overlapping_bodies():
		if body is Actor:
			var _attack_damage = (actor.mod_attack_damage + counter_damage) * damage_multiplier
			var _attack_stagger = 1
			var _attack_knockback = 1
			var attack_dir = Vector2.ZERO
			body.get_hit(_attack_damage, _attack_stagger, _attack_knockback, attack_dir, actor)
	# 3. After this happens 5 times the effect expires and player changes their weapon
	if current_counter_hit_count >= 5:
		ultimate_exit()

func swap_in():
	super.swap_in()
	actor.on_hit.connect(add_sword_charge)
	actor.on_weapon_clash.connect(add_sword_charge2)
	add_charge(0)

func add_sword_charge(_actor : Actor): add_charge(1)
func add_sword_charge2(_actor : Actor): add_charge(2)

func swap_out():
	actor.on_hit.disconnect(add_sword_charge)
	actor.on_weapon_clash.disconnect(add_sword_charge2)
	super.swap_out()

func get_ultimate_time() -> float:
	return counter_time + attack_time
