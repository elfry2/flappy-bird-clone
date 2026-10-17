extends Node2D

@onready var score_label: Label = $"../UI/ScoreLabel"
@onready var pipe: Area2D = $Pipe
@onready var pipe_2: Area2D = $Pipe2

func on_pipe_body_entered(body: Node2D) -> void:
	if(body.name == "Bird"):
		Global.game_state = Global.GameState.TO_BE_OVER
		body.animated_sprite_2d.stop()

func _on_score_zone_body_entered(body: Node2D) -> void:
	Global.score += 1
	score_label.text = str(Global.score)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for pipe in [pipe, pipe_2]:
		pipe.body_entered.connect(on_pipe_body_entered)
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(position.x < (- get_viewport_rect().size.x)):
		queue_free()
	
	if(
		Global.game_state >= Global.GameState.ONGOING
		and Global.game_state < Global.GameState.TO_BE_OVER
	):
		position.x -= delta * Global.scroll_speed
