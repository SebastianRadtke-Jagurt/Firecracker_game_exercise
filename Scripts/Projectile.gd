extends Node2D
class_name Projectile

@export var hurtbox : Hurtbox

@export var speed : float
var lifetime_max : float
var lifetime_current : float = 0

func shoot(direction : Vector2, attack : Attack, collision_mask : int, _speed = 1, _lifetime_max = 999 ):
	rotation = direction.angle()
	self.speed = _speed
	self.lifetime_max = _lifetime_max
	hurtbox.enable_hurtbox(true, collision_mask, attack, direction)

func _physics_process(_delta):
	var movement_vector = Vector2.RIGHT.rotated(rotation)
	global_position += movement_vector * speed

func _on_area_2d_body_entered(_body):
	queue_free()
