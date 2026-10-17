extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var gravity = 980.0
@export var jump_force = 300
@export var rotation_speed = 2
@export var max_speed = 400

func rotate_bird() -> void:
	if(velocity.y > 0 && rad_to_deg(90)):
		rotation += rotation_speed * deg_to_rad(1)

func jump() -> void:
	Global.game_state = Global.GameState.ONGOING
	velocity.y = - jump_force
	rotation = deg_to_rad(-30)
	animated_sprite_2d.play('flap')
	
func _physics_process(delta: float) -> void:
	if(
		Global.game_state < Global.GameState.TO_BE_OVER
		and Input.is_action_just_pressed('jump')
	):
		jump()
	if(
		Global.game_state >= Global.GameState.ONGOING
		and Global.game_state < Global.GameState.OVER
	):
		velocity.y += delta * gravity
		move_and_collide(delta * velocity)
		rotate_bird()
	
