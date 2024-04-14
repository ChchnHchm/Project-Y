class_name WalkingPlayerState extends PlayerMovementState


@export var TOP_ANIMATION_SPEED : float = 2.2

func enter(previous_state) -> void:
	if ANIMATION.is_playing() and ANIMATION.current_animation == "JumpEnd":
		await ANIMATION.animation_finished
		ANIMATION.play("Walking",-1.0,1.0)
		#PLAYER.CurrentSpeed = SPEED
	else:
		ANIMATION.play("Walking",-1.0,1.0)
		#PLAYER.CurrentSpeed = SPEED
	#

func exit() -> void:
	ANIMATION.speed_scale = 1.0

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	Weapon.SwayWeapon(delta, false)
	Weapon.WeaponBobing(delta,WeaponBobSpeed,WeaponBobHorizontal,WeaponBobVertical)
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_pressed("Sprint") and PLAYER.is_on_floor():
		transition.emit("SprintingPlayerState")
		

	if Input.is_action_just_pressed("Crouch") and PLAYER.is_on_floor():
		transition.emit("CrouchingPlayerState")
		
	if PLAYER.velocity.length() == 0.0: 
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpPlayerState")

	if PLAYER.velocity.y < -3.0 and !PLAYER.is_on_floor():
		transition.emit("FallingPlayerState")

func set_animation_speed(spd):
	var alpha = remap(spd,0.0, SPEED,0.0,1.0)
	ANIMATION.speed_scale = lerp(0.0,TOP_ANIMATION_SPEED,alpha )

