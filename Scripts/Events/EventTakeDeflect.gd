extends Event
class_name EventTakeDeflect

var can_get_deflected : bool = false
var deflect_cooldown : float = 0
var deflect_cooldown_max = 0.2

func init(_actor : Actor):
	super.init(_actor)
	actor.on_get_hit.connect(on_get_hit)

func _physics_process(delta):
	if deflect_cooldown > 0: deflect_cooldown -= delta

func check_deflect() -> bool:
	if can_get_deflected && deflect_cooldown <= 0:
		return true
	return false

func on_get_hit(_damage, _stagger, _knockback, _attack_dir, _attacker):
	can_get_deflected = false

func set__can_get_deflected(can : bool):
