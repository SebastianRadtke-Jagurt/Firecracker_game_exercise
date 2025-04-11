extends Node
class_name Game

@onready var loading_scene = load("res://Scenes/game_loading_scene.tscn")
@onready var main_menu_scene = load("res://Scenes/main_menu_scene.tscn")
var next_scene : Node

@export var game_parent : Node2D
@export var health_bar : ProgressBar
@export var dead_screen : Control
@export var win_screen : Control

func _ready():
	GameManager.game_parent = game_parent

func restart(): load_scene(loading_scene)

func return_to_main_menu(): load_scene(main_menu_scene)

func load_scene(scene_to_load):
	next_scene = scene_to_load.instantiate()
	next_scene.ready.connect(retire)
	var tree : SceneTree = get_tree() as SceneTree
	var current_scene = tree.current_scene
	tree.root.add_child(next_scene)
	tree.root.remove_child(current_scene)
	tree.current_scene = next_scene

func retire():
	next_scene.ready.disconnect(retire)
	queue_free()

func set_health_bar_max(value : int):
	health_bar.max_value = value
	health_bar.value = value

func set_health_bar(value : int):
	health_bar.value = value
	print(value)

func pause(is_paused : bool):
	game_parent.get_tree().paused = is_paused

func on_lose():
	pause(true)
	dead_screen.visible = true

func on_win():
	pause(true)
	win_screen.visible = true
