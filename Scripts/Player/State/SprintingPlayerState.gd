class_name SprintingPlayerState extends PlayerMovementState


@export var TOP_ANIMATION_SPEED : float = 1.6


func enter(previous_state) -> void:
	SPEED = 7.0
	if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":
		await ANIMATION.animation_finished
		ANIMATION.play("Sprinting",0.5,1.0)
		#PLAYER._speed = SPEED
	else:
		ANIMATION.play("Sprinting",0.5,1.0)
		#PLAYER._speed = SPEED
	
func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("Sprint") or PLAYER.velocity.length() == 0:
		transition.emit("IdlePlayerState")

	if Input.is_action_just_pressed("Crouch") and PLAYER.velocity.length() > 6:
		transition.emit("SlidingPlayerState")

	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpPlayerState")
	
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")



func set_animation_speed(spd):
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0 )
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIMATION_SPEED, alpha )
