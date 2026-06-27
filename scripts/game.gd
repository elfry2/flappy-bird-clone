extends Node2D

@onready var ground: Area2D = $Ground
@onready var bird: CharacterBody2D = $Bird
@onready var game_over_ui: VBoxContainer = $UI/VBoxContainer/MarginContainer2/GameOverUIContainer
@onready var score_ui: Label = $UI/VBoxContainer/MarginContainer/HBoxContainer/ScoreLabel
@onready var retry_button: Button = $UI/VBoxContainer/MarginContainer2/GameOverUIContainer/MarginContainer/HBoxContainer2/RetryButton

const SCROLL_DIRECTION : int = -1
const SCROLL_SPEED : int = 150
const GRAVITY : int = 980
const BIRD_VELOCITY : int = -300
const BIRD_ROTATION_SPEED = 2
const PIPE_PAIR_SCENE = preload('res://scenes/pipe_pair.tscn')

var screen_size
var is_started : bool = false
var is_scrolling_allowed : bool = true
var is_falling_allowed : bool = false
var is_spawning_allowed : bool = false
var is_flap_allowed = true
var pipe_pairs = []
var score : int = 0

func _scroll_ground(delta):
	var screen_width : int = screen_size.x
	var sprite_width : int = ground.sprite1.texture.get_width()
	var initial_position : float = screen_width / 2
	var scroll_limit : float = ground.sprite1.texture.get_width()
	if(ground.position.x < (initial_position - scroll_limit)):
		ground.position.x = initial_position
	ground.position.x += int(is_scrolling_allowed) * delta * SCROLL_DIRECTION * SCROLL_SPEED

func _if_flap_action_then_flap(delta) -> void:
	if is_flap_allowed and Input.is_action_just_pressed("flap"):
		print("Flap!")
		is_spawning_allowed = true
		is_falling_allowed = true
		bird.flap()
		bird.velocity.y = BIRD_VELOCITY
	if not is_falling_allowed:
		return
	bird.velocity.y += delta * GRAVITY
	bird.move_and_collide(int(is_falling_allowed) * delta * bird.velocity)
	if bird.sprite.rotation < deg_to_rad(90):
		bird.sprite.rotation += deg_to_rad(BIRD_ROTATION_SPEED)

func _on_ground_body_entered(body: Node2D) -> void:
	if not body.name == "Bird":
		return
	is_scrolling_allowed = false
	is_falling_allowed = false
	is_flap_allowed = false
	game_over_ui.visible = true
	retry_button.grab_focus()

func _on_sky_boundary_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		is_flap_allowed = false
		is_scrolling_allowed = false
	print("Hit!")

func _on_pipe_hit() -> void:
	_on_sky_boundary_body_entered(bird)

func _increment_score_and_update_ui():
	score += 1
	score_ui.text = str(score)
	print("Scored! Current score: " + str(score))

func _on_score_area_body_entered():
	_increment_score_and_update_ui()

func _spawn_pipe_pair():
	if not is_spawning_allowed:
		return
	print("Spawn!")
	var pipe_pair = PIPE_PAIR_SCENE.instantiate()
	var half_screen_height = screen_size.y / 2
	var ground_sprite_height = ground.sprite1.texture.get_size().y
	var random_offset = randi_range(-half_screen_height, half_screen_height - ground_sprite_height)
	#var pipe_sprite_width =  pipe_pair.pipe1.sprite.texture.get_size().x # error: not yet instantiated
	const PIPE_SPRITE_WIDTH : int = 52
	pipe_pair.position.y = screen_size.y / 2 + random_offset
	#pipe_pair.position.x = screen_size.x + sprite_width
	pipe_pair.position.x = screen_size.x + PIPE_SPRITE_WIDTH
	pipe_pair.scored.connect(_on_score_area_body_entered)
	pipe_pair.hita.connect(_on_pipe_hit)
	pipe_pairs.append(pipe_pair)
	add_child(pipe_pair)

func _on_pipe_pair_timer_timeout() -> void:
	_spawn_pipe_pair()

func _scroll_pipe_pairs(delta):
	if not is_scrolling_allowed:
		return
	for index in pipe_pairs.size():
		var sprite_width = pipe_pairs[index].pipe1.sprite.texture.get_size().x
		if pipe_pairs[index].position.x < (0 - sprite_width):
			pipe_pairs[index].queue_free()
			pipe_pairs.remove_at(index)
			return
		pipe_pairs[index].position.x += delta * SCROLL_DIRECTION * SCROLL_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_scroll_ground(delta)
	_scroll_pipe_pairs(delta)
	_if_flap_action_then_flap(delta)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport().get_visible_rect().size

func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()
