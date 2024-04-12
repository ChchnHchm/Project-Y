class_name JumpPlayerState extends PlayerMovementState

@export var JUMP_VELOCITY : float = 4.5
@export var DOUBLE_JUMP_VELOCITY : float = 4.5
@export_range(0.5,1.0,0.01) var INPUT_MULTIPLAYER : float = 0.85 

var DOUBLE_JUMP : bool = false

func enter(previous_state) -> void:
	PLAYER.velocity.y += JUMP_VELOCITY
	ANIMATION.play("JumpStart")
	#ANIMATION.pause()
	
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLAYER,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	if Input.is_action_just_pressed("Jump") and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		PLAYER.velocity.y += DOUBLE_JUMP_VELOCITY
	#if Input.is_action_just_released("jump"):
		#if PLAYER.velocity.y > 0:
			#PLAYER.velocity.y = PLAYER.velocity.y / 2.0
			
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if PLAYER.is_on_floor():
		ANIMATION.play("JumpEnd")
		transition.emit("IdlePlayerState")
func exit() -> void:
	DOUBLE_JUMP = false
