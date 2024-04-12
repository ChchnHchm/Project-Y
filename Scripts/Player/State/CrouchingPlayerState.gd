class_name CrouchingPlayerState extends PlayerMovementState

@export_range(1,6,0.1) var CROUCH_SPEED : float = 4.0

@onready var CROUCH_SHAPECAST : ShapeCast3D = $"../../ShapeCast3D"   # va vérifier les collisions lorsque l'on se relève 

var RELEASED : bool = false

func enter(previous_state) -> void:
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



	#if event.is_action_pressed("crouch") and is_on_floor() and TOGGLE_CROUCH : # dans le  cas du toggle crouch
		#toggle_crouch()
	#if event.is_action_pressed("crouch") and !is_crouching and is_on_floor() and !TOGGLE_CROUCH: # cas du hold crouch
		#crouching(true)
	#if event.is_action_released("crouch")  and !TOGGLE_CROUCH: #on relache le crouch 
		#if !CROUCH_SHAPECAST.is_colliding(): # si il n'ya pas de collision on peut se relever
			#crouching(false)
		#else:
			#uncrouch_When_Free()#on va relacher le crouch seulement quand il n'y aura plus de collisions 
#func uncrouch_When_Free():
	#if !CROUCH_SHAPECAST.is_colliding(): # si il n'ya pas de collision on peut se relever
		#crouching(false)
	#else: 
		#await get_tree().create_timer(0.1).timeout
		#uncrouch_When_Free()
		#
		
#func crouching(state: bool):
	#match state:
		#true:
			#ANIMATIONPLAYER.play("crouch", 0, CROUCH_SPEED)
			#SetMovementSpeed("crouching")
		#false:
			#ANIMATIONPLAYER.play("crouch", 0, -CROUCH_SPEED,true)# on fait la meme chose que pour s'accroupir sauf qu'avec le - l'animation se fera a l'envers et true pour l'animation commence par la fin
			#SetMovementSpeed("default")
#
#func toggle_crouch(): #se lancera des que le joueur appuie sur la  touche s'ascroupir
	#if is_crouching and !CROUCH_SHAPECAST.is_colliding() : # si le joeur appui sur crouch alors que l'on est deja crouch on se releve et seuleemnt si il n'y a pas de collision avec d'autre objets
		#crouching(false) 
	#elif  !is_crouching and is_on_floor() :
		#crouching(true)
	#
