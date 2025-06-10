extends Node2D
class_name Projectile

@export var hurtbox : Hurtbox

@export var speed : float
var lifetime_max : float
var lifetime_current : float = 0
var pierce_count = 0

signal on_hit

func shoot(direction : Vector2, attack : Attack, collision_mask : int, _speed = 1, _lifetime_max = 999, _pierce_count = 0):
	rotation = direction.angle()
	speed = _speed
	lifetime_max = _lifetime_max
	pierce_count = _pierce_count
	hurtbox.enable_hurtbox(true, collision_mask, attack, direction)
	get_tree().create_timer(_lifetime_max).timeout.connect(queue_free)

func _physics_process(_delta):
	var movement_vector = Vector2.RIGHT.rotated(rotation)
	global_position += movement_vector * speed

func _on_area_2d_body_entered(body):
	if body is Actor:
		on_hit.emit()
		if pierce_count <= 0:
			queue_free()
		else:
			pierce_count -= 1
	else:
		queue_free()
