extends Node2D
class_name Trap

@export var hurtbox : Hurtbox
@export var throw_curve : Curve

var lifetime_max : float
var lifetime_current : float = 0
var destination : Vector2

signal on_hit

func throw(_destination : Vector2, _on_hit : Callable, collision_mask : int, _lifetime_max = 10):
	destination = _destination
	lifetime_max = _lifetime_max
	on_hit.connect(_on_hit, CONNECT_ONE_SHOT)
	hurtbox.enable_hurtbox(true, collision_mask, Attack.new(), Vector2.ZERO)
	get_tree().create_timer(_lifetime_max).timeout.connect(queue_free)
	
	var og_pos = global_position
	var w = 0.0
	while global_position.distance_to(destination) > 0.05:
		global_position = lerp(og_pos, destination, w)
		global_position += Vector2(0, throw_curve.sample(w) * 10)
		w += get_physics_process_delta_time()
		await get_tree().physics_frame
	$Area2D.monitoring = true

func _on_area_2d_body_entered(body):
	if body is Actor:
		on_hit.emit()
	
	queue_free()
