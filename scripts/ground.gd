extends Area2D

@onready var restart_button: Button = $"../UI/RestartButton"

var screen_width

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_width = get_viewport_rect().size.x
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(position.x < (- screen_width)):
		position.x = 0
	if(Global.game_state < Global.GameState.TO_BE_OVER):
		position.x -= delta * Global.scroll_speed

func _on_body_entered(body: Node2D) -> void:
	if(body.name == "Bird"):
		Global.game_state = Global.GameState.OVER
		restart_button.visible = true
