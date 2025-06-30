extends Weapon
class_name Bow

@onready var ultimate_attack_sequence :StateAttackSequence = $UltimateAttackSeqence
@onready var bow_ultimate_buff_applier : BuffApplier = $Bow_Ultimate_Buff_Applier
@onready var bow_trap_debuff_applier = $Bow_Trap_Debuff_Applier

var buff_duration : float = 0
var buff_duration_max : float = 5
var is_attacking : bool = false

var is_flipping = false
var flip_out_time = 0
var rotation_time : float = 0.2
var quarter_flip_count = 0
var max_quarter_flip_count : float = 8
var is_mid_flip = false
var rot : float
var rotated : float

var landing_time : float = .5

var trapping_time = 0
var trap_count = 12
var thrown_traps_count = 0
var trap_throw_radius = 100
var traps_positions : Array[Vector2]

var trap_explosion_radius = 13

func shoot():
	var new_arrow : Projectile = GameManager.arrow.instantiate()
	GameManager.game_parent.add_child(new_arrow)
	new_arrow.on_hit.connect(add_charge.bind(1), CONNECT_ONE_SHOT)
	new_arrow.global_position = offset.global_position
	new_arrow.shoot(Vector2.DOWN.rotated(offset.global_rotation), \
								buffered_attack, \
								actor.hurtbox_mask,
								3)

func shoot_multi(count : int):
	for i in count:
		var new_arrow = GameManager.arrow.instantiate()
		var rot_offset = ceilf(i / 2.0) * deg_to_rad(20) * (-1 if i % 2 == 0 else 1)
		GameManager.game_parent.add_child(new_arrow)
		new_arrow.on_hit.connect(add_charge.bind(1), CONNECT_ONE_SHOT)
		new_arrow.global_position = offset.global_position
		new_arrow.shoot(Vector2.DOWN.rotated(offset.global_rotation + rot_offset), \
									buffered_attack, \
									actor.hurtbox_mask,
									3)

func set_active_hurtbox(_active : bool):
	pass

func ultimate_enter():
	super.ultimate_enter()
	# Apply ultimate buff
	bow_ultimate_buff_applier.apply()

func ultimate_execute(delta : float):
	if !is_attacking:
		if(actor.movement_input != Vector2.ZERO):
			actor.movement_vector += actor.movement_input
		
		buff_duration += delta
		if buff_duration >= buff_duration_max || actor.get_input("attack_1"):
			actor.play_animation("RESET")
			is_attacking = true
			ultimate_attack_sequence.enter()
			bow_ultimate_buff_applier.expire(null)
			
			for i in trap_count:
				var theta = randf() * 2 * PI
				traps_positions.append(Vector2(cos(theta), sin(theta)) * sqrt(randf()) * trap_throw_radius)
	
	if is_flipping && quarter_flip_count <= max_quarter_flip_count:
		trapping_time += delta
		var trapping_countdown = rotation_time * max_quarter_flip_count / trap_count * thrown_traps_count / 4
		if trapping_time - trapping_countdown >= 0:
			# Throw trap
			thrown_traps_count += 1
			if traps_positions.size() > 0:
				var dest : Vector2 = actor.global_position + traps_positions.pop_front()
				var trap : Trap = GameManager.trap.instantiate()
				GameManager.game_parent.add_child(trap)
				trap.global_position = actor.global_position
				trap.throw(dest, on_trap_hit.bind(trap), actor.hurtbox_mask, 10)
		
		if !is_mid_flip:
			quarter_flip_count += 1
			is_mid_flip = true
			flip_out_time = 0
			rot = actor.graphics_parent.rotation
			rotated = actor.graphics_parent.rotation + deg_to_rad(90)
		
		if is_mid_flip:
			actor.graphics_parent.rotation = lerp_angle(rot, rotated, flip_out_time / rotation_time * 4)
			flip_out_time += delta
			if flip_out_time / rotation_time * 4 > 1:
				is_mid_flip = false

func shoot_big():
	var new_arrow : Projectile = GameManager.arrow.instantiate()
	GameManager.game_parent.add_child(new_arrow)
	new_arrow.scale = Vector2.ONE * 5
	new_arrow.global_position = offset.global_position
	new_arrow.shoot(Vector2.DOWN.rotated(offset.global_rotation), \
								buffered_attack, \
								actor.hurtbox_mask,
								5,999 ,999)

func flip_out():
	is_flipping = true
	quarter_flip_count = 0
	flip_out_time = 0

func ultimate_exit():
	buff_duration = 0
	is_flipping = false
	is_mid_flip = false
	is_attacking = false
	traps_positions.clear()

func get_ultimate_time() -> float:
	return 1 + 2 * rotation_time + landing_time

func on_trap_hit(trap : Trap):
	# Trap detects enemies in the area and applies a debuff to them
	var phys_cast = ShapeCast2D.new()
	trap.add_child(phys_cast)
	phys_cast.collision_mask = actor.hurtbox_mask
	phys_cast.global_position = trap.global_position
	phys_cast.shape = CircleShape2D.new()
	(phys_cast.shape as CircleShape2D).radius = trap_throw_radius
	phys_cast.force_shapecast_update()
	for result in phys_cast.collision_result:
		var collider = result.collider as Actor
		collider.get_hit(2, 0, 0, Vector2.ZERO, null)
		bow_trap_debuff_applier.apply_to(collider)
