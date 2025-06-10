extends Node

var game_parent : Node2D
var game_menu : GameMenu

var player : Player
var player_position : Vector2 = Vector2.ZERO
var player_weapon_rotation : float = 0

func pause(is_paused : bool): game_menu.game.pause(is_paused)

#region Spawnables
@onready var grunt = load("res://Scenes/Enemy/grunt.tscn")
@onready var ranger = load("res://Scenes/Enemy/ranger.tscn")
@onready var veteran = load("res://Scenes/Enemy/veteran.tscn")
@onready var elite = load("res://Scenes/Enemy/elite.tscn")

@onready var arrow = load("res://Scenes/Weapons/arrow.tscn")
@onready var trap = load("res://Scenes/Weapons/trap.tscn")

@onready var death_particles = load("res://Scenes/death_particles.tscn")
@onready var slash_vfx = load("res://Scenes/slash_particle.tscn")
@onready var deflect_buff_particles = load("res://Scenes/deflect_buff_particles.tscn")
@onready var dash_refresh_particles = load("res://Scenes/dash_refresh_particles.tscn")

enum Spawnable {ARROW, TRAP, GRUNT, RANGER, VETERAN, ELITE}

@onready var spawnables = {
	"ARROW" : arrow,
	"TRAP" : trap,
	"GRUNT" : grunt,
	"RANGER" : ranger,
	"VETERAN" : veteran,
	"ELITE" : elite,
}

func Instantiate(spawnable_name : String) -> Node2D:
	var spawned = spawnables[spawnable_name].instantiate()
	return spawned

#endregion

#region Sounds

@onready var swing = load("res://Assets/Audio/freesounds/420668__sypherzent__basic-melee-swing-miss-whoosh.wav")
@onready var swing2 = load("res://Assets/Audio/freesounds/porkmuncher__swoosh_4.wav")
@onready var bow_release = load("res://Assets/Audio/freesounds/bow_release_matthewholdensound.wav")
@onready var player_hurt = load("res://Assets/Audio/Kenney_Audio/kenney_interface-sounds/Audio/error_005.ogg")
@onready var enemy_hurt = load("res://Assets/Audio/freesounds/hurt_c_03_cabled_mess.wav")
@onready var stab1 = load("res://Assets/Audio/freesounds/melee-attack-1-by-freesound-unfa.mp3")
@onready var stab2 = load("res://Assets/Audio/freesounds/melee-attack-2-by-freesound-unfa.mp3")
@onready var stab3 = load("res://Assets/Audio/freesounds/melee-attack-3-by-freesound-unfa.mp3")

@onready var sounds = {
	"swing" : swing,
	"swing2": swing2,
	"bow_release" : bow_release,
	"player_hurt" : player_hurt,
	"enemy_hurt" : enemy_hurt,
	"stab1" : stab1,
	"stab2" : stab2,
	"stab3" : stab3,
}

func get_sound(sound_name : String) -> AudioStream:
	if sounds.has(sound_name):
		return sounds[sound_name]
	
	return null

#endregion
