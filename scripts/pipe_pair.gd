extends Area2D

signal hita
signal scored # so it can be detected from the game script without waiting for the Node to be instantiated.

@onready var pipe1: Area2D = $Pipe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_score_area_body_entered(body: Node2D) -> void:
	scored.emit()

func _on_pipe_body_entered(body: Node2D) -> void:
	hita.emit()

func _on_pipe_2_body_entered(body: Node2D) -> void:
	hita.emit()
