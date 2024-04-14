class_name CrouchingPlayerState extends PlayerMovementState

@export_range(1,6,0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = $"../../ShapeCast3D"   # va vérifier les collisions lorsque l'on se relève 

var RELEASED : bool = false

func enter(previous_state) -> void:
	SPEED = 3.0
	WeaponBobSpeed  = 2.0
	WeaponBobHorizontal = 1.5
	WeaponBobVertical = 0.7
	ANIMATION.speed_scale = 1.0
	if previous_state.name != "SlidingPlayerState":
		ANIMATION.play("Crouching",-1.0,CROUCH_SPEED)
	elif previous_state.name == "SlidingPlayerState":
		ANIMATION.current_animation = "Crouching"
		ANIMATION.seek(1.0,true)
	

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED,ACCELERATION,DECELERATION)
	PLAYER.update_velocity()
	Weapon.SwayWeapon(delta, false)
	Weapon.WeaponBobing(delta,WeaponBobSpeed,WeaponBobHorizontal,WeaponBobVertical)
	if Input.is_action_just_released("Crouch"):
		uncrouch()
	if Input.is_action_just_pressed("Jump") and PLAYER.is_on_floor():
		transition.emit("JumpPlayerState")

func exit() -> void:
	RELEASED = false

func uncrouch():
	if !CROUCH_SHAPECAST.is_colliding():
		ANIMATION.play("Crouching",-1.0,-CROUCH_SPEED,true)
		await ANIMATION.animation_finished
		if PLAYER.velocity.length() == 0:
			transition.emit("IdlePlayerState")
		else:
			transition.emit("WalkingPlayerState")
	elif CROUCH_SHAPECAST.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
