extends State
class_name StateStaggered

@export var stagger_threshold : float = 1
var stagger_buildup : float = 0
var stagger_cooldown : float = 0
@export var stagger_cooldown_max : float = 1
@export var on_stagger_attack_cd : float = 0

func init(_actor : Actor):
	super.init(_actor)
	actor.on_get_hit.connect(get_staggered)

func get_staggered(_damage : int, stagger : int, _knockback : int, _attack_dir : Vector2, _attacker : Actor):
	if stagger_cooldown > 0:
		return
	
	stagger_buildup += stagger
	if stagger_buildup > stagger_threshold:
		actor.current_state.exit("staggered")
		stagger_buildup = 0
		if on_stagger_attack_cd > 0: actor.weapons.current_weapon.attack_cooldown += on_stagger_attack_cd
		actor.weapons.current_weapon.cancel_anim()
		stagger_cooldown = stagger_cooldown_max

func _physics_process(delta):
	if stagger_buildup > 0:
		stagger_buildup -= delta
	if stagger_cooldown > 0:
		stagger_cooldown -= delta

func enter():
	self.actor.set__can_get_hit(true)
	self.actor.play_animation("staggered")
	actor.weapons.current_weapon.set_active_hurtbox(false)
	actor.weapons.current_weapon.set__can_aim(false)

func execute(delta):
	state_time += delta
	if state_time > state_time_max:
		exit("idle")
	
	if(actor.get_input("ui_accept")):
		actor.buffer_state("dashing", state_group_idx)
		return
 
func exit(exit_message : String = ""):
	actor.play_animation("RESET")
	actor.set__can_aim(true)
	await get_tree().physics_frame
	super.exit(exit_message)
