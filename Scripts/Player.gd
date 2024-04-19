extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _mouse_input : bool = false #indicate if the mouse is moving or not
var _rotation_input : float # valeur de la position de la souris sur l'axe des X
var _tilt_input : float # valeur de la position de la souris sur l'axe des Y
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
var _current_rotation: float
@export var CAMERA_CONTROLLER : Camera3D # type camera3D car référence le NODE camera3D
@export var MOUSE_SENSITIVITY : float = 0.5
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0) # représente le mouvement verticale maximum de la caméra vers le  bas 
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0) # représente le mouvement verticale maximum de la caméra vers le  haut 

func _unhandled_input(event): # la function se lance des qu'on bougera la souris 
# we first verify if the event is mouse moving and if the mouse is in capture mode
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = - event.relative.y * MOUSE_SENSITIVITY
	#print(Vector2(_rotation_input,_tilt_input)) # on peut voir les coordonnées des mouvement horizontales et verticale en directe
	
func _update_camera(delta): # sera appeler a chaque frame
	_current_rotation = _rotation_input
	
	# Rotates camera using euler rotation
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT) #Clamps value and returns a value not less than min and not more than max.
	_mouse_rotation.y += _rotation_input * delta

	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
		# ne pas oublier d'assigner le noeud camera au characterBody3D dans l'inspector sinon CAMERA_CONTROLLER sera nil 
	CAMERA_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)	# on met a jour la camera
	CAMERA_CONTROLLER.rotation.z = 0 # on remet a 0 pour éviter que la caméra tourne 
	
	
	global_transform.basis = Basis.from_euler(_player_rotation) #va faire bouger le joeur dans la direction de la caméra 
	
	
	_rotation_input = 0 
	_tilt_input = 0

#get mouse input
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _physics_process(delta):
	_update_camera(delta)
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
