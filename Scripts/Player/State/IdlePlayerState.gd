class_name IdlePlayerState extends PlayerMovementState


func enter(previous_state) -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":
		await ANIMATION.animation_finished
		ANIMATION.pause()
	else:
		ANIMATION.pause()
	

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	Weapon.SwayWeapon(delta, true)
	
	if Input.is_action_just_pressed("Crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
	
	if PLAYER.velocity.length() > 0.0 and PLAYER.is_on_floor(): 
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpPlayerState")
		
	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")

