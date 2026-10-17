extends Node2D

class_name Global

enum GameState {READY, ONGOING, TO_BE_OVER, OVER}

static var score: int
static var game_state: GameState
static var scroll_speed: float

func _ready():
	score = 0
	game_state = GameState.READY
	scroll_speed = 150
