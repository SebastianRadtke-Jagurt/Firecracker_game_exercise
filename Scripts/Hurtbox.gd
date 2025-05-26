extends Area2D
class_name Hurtbox

var actor : Actor

var _attack_damage : int
var _attack_stagger : int
var _attack_knockback : int
var attack_dir : Vector2

func init(actor : Actor):
	self.actor = actor

func enable_hurtbox(is_enabled, _collision_mask, attack : Attack, _attack_dir : Vector2):
	if !is_enabled:
		collision_mask = 0
	else:
		set_collision_mask_value(_collision_mask, true)
		_attack_damage = attack.damage
		_attack_stagger = attack.stagger
		_attack_knockback = attack.knockback
		attack_dir = _attack_dir

func _on_body_entered(body):
	if body is Actor:
		body.get_hit(_attack_damage, _attack_stagger, _attack_knockback, attack_dir, actor)
	elif body is Hurtbox:
			actor.on_sword_clash.emit(body.actor)

func try_get_deflected() -> bool:
	return actor.try_get_deflected()
