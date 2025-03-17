extends State
class_name StateTakeDamage

func init(_actor : Actor):
	super.init(_actor)
	actor.on_get_hit.connect(take_damage)

func take_damage(damage : int, _stagger_score : int, _knockback : int, _attack_dir : Vector2, _attacker : Actor):
	actor.base_health -= damage 
