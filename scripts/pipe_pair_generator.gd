extends Node2D

@onready var game: Node2D = $".."

@export var top_boundary = 100
@export var bottom_boundary = 200

var pipe_pair_scene
var boundaries
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	pipe_pair_scene = preload("res://scenes/pipe_pair.tscn")
	boundaries = {
		'min': top_boundary,
		'max': get_viewport_rect().size.y - bottom_boundary
	}

func _on_timer_timeout() -> void:
	if Global.game_state != Global.GameState.ONGOING:
		return
	var pipe_pair = pipe_pair_scene.instantiate()
	pipe_pair.position.x = screen_size.x
	pipe_pair.position.y = randi_range(boundaries['min'], boundaries['max'])
	game.add_child(pipe_pair)
 
