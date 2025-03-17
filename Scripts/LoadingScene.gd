extends Node

@onready var game_scene = load("res://Scenes/game_scene.tscn")
var game : Node

func _ready():
	await get_tree().process_frame
	setup_game_scene()

func setup_game_scene():
	game = game_scene.instantiate()
	game.ready.connect(retire)
	var tree : SceneTree = get_tree() as SceneTree
	var current_scene = tree.current_scene
	tree.root.add_child(game)
	tree.root.remove_child(current_scene)
	tree.current_scene = game

func retire():
	game.ready.disconnect(retire)
	queue_free()
