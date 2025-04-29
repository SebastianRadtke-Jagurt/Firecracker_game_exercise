extends Node
class_name Attack

@export var anim_player : AnimationPlayer
@export var animation_name : String
@export var damage : int
@export var stagger : int
@export var knockback : int
var attack_time : float
@export var next_attack_delay : float
@export var displacement : float
@export var is_parryable : bool

func _ready():
	attack_time = anim_player.get_animation(animation_name).length

func play():
	anim_player.play(animation_name)
