extends Weapon

@export var offset2 : Node2D
@export var hurtbox2 : Hurtbox
@onready var zone : Area2D = $Zone
@onready var zone2 : Area2D = $Zone2

var max_dashes : int = 3
var dashes : int = 0
var dashing_speed : float = 12

var dashing_time = 0
var max_dashing_time : float = 0.1
var dashing_vector : Vector2

var zone_base_radius : Vector2
var zone_radius = 128

var is_dashing : bool = false

var marked_enemies : Array[Actor]

var actor_anim_speed_scale : float

func _ready():
	zone_base_radius = zone.scale

func set_active_hurtbox(active : bool):
	hurtbox.enable_hurtbox(active, actor.hurtbox_mask, buffered_attack, get_attack_rotation())

func set_active_hurtbox2(active : bool):
	hurtbox2.enable_hurtbox(active, actor.hurtbox_mask, buffered_attack, get_attack_rotation())

func swap_in():
	super.swap_in()
	actor.on_hit.connect(add_dagger_charge)
	add_charge(0)

func add_dagger_charge(_actor : Actor): add_charge(1)

func swap_out():
	super.swap_out()
	actor.on_hit.disconnect(add_dagger_charge)

func ultimate_enter():
	super.ultimate_enter()
	dashes = 0
	add_charge(0)
	zone.monitoring = true
	zone.scale = zone_base_radius * Vector2(zone_radius/10 ,zone_radius/10)
	marked_enemies.clear()
	actor.get_hit_cooldown = get_ultimate_time()
	actor_anim_speed_scale = actor.anim_player.speed_scale
	actor.anim_player.speed_scale = actor.anim_player.get_animation("dashing").length / max_dashing_time

func ultimate_execute(delta : float):
	if is_dashing == false:
		if dashes <= max_dashes:
			dashes += 1
			var bodies = zone.get_overlapping_bodies()
			# Find nearest enemy to dash through
			if bodies.size() > 0:
				var nearest : Node2D = bodies.pop_front()
				if bodies.size() > 0:
					for body in zone.get_overlapping_bodies():
						if actor.global_position.distance_to(body.global_position) < actor.global_position.distance_to(nearest.global_position):
							nearest = body
				dashing_vector = actor.global_position.direction_to(nearest.global_position)
			# Or dash in direction of the mouse
			else:
				dashing_vector = actor.global_position.direction_to((actor as Player).mouse_pos)
			actor.play_animation("dashing")
			play_sound("stab" + str(randi_range(1, 3)))
			is_dashing = true
			zone2.monitoring = true
	else:
		if dashing_time < max_dashing_time:
			dashing_time += delta 
			actor.global_position += dashing_vector * dashing_speed
			if dashing_time >= max_dashing_time:
				is_dashing = false
				dashing_time = 0
				zone2.monitoring = false
				detonate_mark()

func ultimate_exit():
	dashes = 0
	actor.anim_player.speed_scale = actor_anim_speed_scale
	actor.anim_player.stop()
	zone.monitoring = false
	actor.play_animation("RESET")

func get_ultimate_time() -> float:
	return max_dashing_time * max_dashes + 0.1

func mark_for_damage(body : Node2D):
	marked_enemies.append(body as Actor)
	print("Marking - ", body.name)

func detonate_mark():
	for enemy in marked_enemies:
		enemy.get_hit(damage + actor.mod_attack_damage, 5, 1, Vector2.ZERO, actor)
		print("Detonating mark - ", enemy.name)
	marked_enemies.clear()
