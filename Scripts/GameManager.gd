extends Node

var game_parent : Node2D

#region Spawnables
@onready var arrow = load("res://Scenes/arrow.tscn")
@onready var grunt = load("res://Scenes/Enemy/grunt.tscn")
@onready var ranger = load("res://Scenes/Enemy/ranger.tscn")
@onready var veteran = load("res://Scenes/Enemy/veteran.tscn")
@onready var elite = load("res://Scenes/Enemy/elite.tscn")

@onready var death_particles = load("res://Scenes/death_particles.tscn")
@onready var slash = load("res://Scenes/slash_particle.tscn")
@onready var deflect_buff_particles = load("res://Scenes/deflect_buff_particles.tscn")
@onready var dash_refresh_particles = load("res://Scenes/dash_refresh_particles.tscn")

enum Spawnable {ARROW, GRUNT, RANGER, VETERAN, ELITE}

var player_position : Vector2 = Vector2.ZERO
var player_rotation : float = 0

@onready var spawnables = {
	"ARROW" : arrow,
	"GRUNT" : grunt,
	"RANGER" : ranger,
	"VETERAN" : veteran,
	"ELITE" : elite,
}

func Instantiate(enemy_to_spawn : String) -> Node2D:
	var spawned = spawnables[enemy_to_spawn].instantiate()
	return spawned

#endregion

#region Sounds

@onready var swing = load("res://Assets/freesounds/420668__sypherzent__basic-melee-swing-miss-whoosh.wav")
@onready var swing2 = load("res://Assets/freesounds/porkmuncher__swoosh_4.wav")
@onready var bow_release = load("res://Assets/freesounds/bow_release_matthewholdensound.wav")
@onready var player_hurt = load("res://Assets/Kenney_Audio/kenney_interface-sounds/Audio/error_005.ogg")
@onready var enemy_hurt = load("res://Assets/freesounds/hurt_c_03_cabled_mess.wav")

@onready var sounds = {
	"swing" : swing,
	"swing2": swing2,
	"bow_release" : bow_release,
	"player_hurt" : player_hurt,
	"enemy_hurt" : enemy_hurt,
}

func get_sound(sound_name : String) -> AudioStream:
	if sounds.has(sound_name):
		return sounds[sound_name]
	
	return null

#endregion
