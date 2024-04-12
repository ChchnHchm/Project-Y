extends CenterContainer

@export var RETICLE_LINES : Array[Line2D]
@export var PLAYER_CONTROLLER : CharacterBody3D
@export var RETICLE_SPEED : float = 0.25
@export var RETICLE_DIStance : float = 2.0
@export var DOT_RADIUS : float = 1.0
@export var DOT_COLOR: Color = Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle(Vector2(0,0), DOT_RADIUS, DOT_COLOR) 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta):
	adjust_reticle_lines()

func adjust_reticle_lines():
	var velocity = PLAYER_CONTROLLER.get_real_velocity()
	var origin = Vector3(0,0,0)
	var pos = Vector2(0,0)
	var speed = origin.distance_to(velocity)

	RETICLE_LINES[0].position = lerp(RETICLE_LINES[0].position, pos + Vector2(0,-speed *RETICLE_DIStance ), RETICLE_SPEED ) # TOP
	RETICLE_LINES[1].position = lerp(RETICLE_LINES[1].position, pos + Vector2(speed *RETICLE_DIStance,0 ), RETICLE_SPEED ) # Right
	RETICLE_LINES[2].position = lerp(RETICLE_LINES[2].position, pos + Vector2(0,speed *RETICLE_DIStance ), RETICLE_SPEED ) # Bottom
	RETICLE_LINES[3].position = lerp(RETICLE_LINES[3].position, pos + Vector2(-speed *RETICLE_DIStance,0 ), RETICLE_SPEED ) # Left
