class_name SlidingPlayerState extends PlayerMovementState

@export var TILT_AMOUNT: float = 0.9 
@export_range(1,6,0.1) var SLIDE_AIM_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = $"../../ShapeCast3D"

func enter(previous_state) -> void:
	SPEED = 6.0
	set_tilt(PLAYER._current_rotation)
	ANIMATION.get_animation("Sliding").track_set_key_value(4,0,PLAYER.velocity.length())
	ANIMATION.speed_scale = 1.0
	ANIMATION.play("Sliding",-1.0,SLIDE_AIM_SPEED)



func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION) #désactiver pour empecher le joueur de se déplacer tout en glissant
	PLAYER.update_velocity()
	
func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(TILT_AMOUNT * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z = 0.05
	ANIMATION.get_animation("Sliding").track_set_key_value(7,1,tilt)
	ANIMATION.get_animation("Sliding").track_set_key_value(7,2,tilt)
	
	#print(ANIMATION.get_animation("Sliding").track_get_path(5))
	#speed id =  5 and camera fov id = 7
	

func finish():
	transition.emit("CrouchingPlayerState")
