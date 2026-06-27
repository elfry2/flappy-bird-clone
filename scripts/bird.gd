extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func flap() -> void:
	sprite.play("flap")
	sprite.rotation = deg_to_rad(-30)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
