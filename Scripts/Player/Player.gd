class_name Player extends CharacterBody3D

@export var ANIMATIONPLAYER : AnimationPlayer

var CurrentSpeed = 5.0
const JUMP_VELOCITY = 4.5


#########"#################################   MOUSE CONFIG   #######################################################################
@export var TILT_LOWER_LIMIT := deg_to_rad(-90.0) # représente le mouvement verticale maximum de la caméra vers le  bas 
@export var TILT_UPPER_LIMIT := deg_to_rad(90.0) # représente le mouvement verticale maximum de la caméra vers le  haut 
@export var CAMERA_CONTROLLER : Camera3D # type camera3D car référence le NODE camera3D
@export var mouseSensitivity : float = 0.4

var _rotation_input : float # valeur de la position de la souris sur l'axe des X
var _tilt_input : float # valeur de la position de la souris sur l'axe des Y
var _mouse_rotation : Vector3
var _player_rotation : Vector3
var _camera_rotation : Vector3
var _current_rotation: float
var _mouse_input : bool = false #indicate if the mouse is moving or not
#################################################################################################################################
@export var CROUCH_SHAPECAST : Node3D # va vérifier les collisions lorsque l'on se relève 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event.is_action_pressed("Exit"):
		get_tree().quit()

func _ready():
	#get mouse input
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
# on ajoute une exception au checking des collision, le checking doit se faire avec tout les objet sauf sois meme donc le player
	#CROUCH_SHAPECAST.add_exception($".")


func _unhandled_input(event): # la function se lance des qu'on bougera la souris 
# we first verify if the event is mouse moving and if the mouse is in capture mode
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x * mouseSensitivity
		_tilt_input = - event.relative.y * mouseSensitivity
	#print(Vector2(_rotation_input,_tilt_input)) # on peut voir les coordonnées des mouvement horizontales et verticale en directe

func _physics_process(delta):
	_update_camera(delta)

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


func update_gravity(delta) -> void:
	velocity.y -= gravity * delta
	
func update_input(speed:float, acceleration:float,deceleration: float) -> void:
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("MoveLeft", "MoveRight", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x,direction.x * speed, acceleration)
		velocity.z =  lerp(velocity.z,direction.z * speed, acceleration)
	else:
		var vel = Vector2(velocity.x,velocity.z)
		var temp = move_toward(Vector2(velocity.x,velocity.z).length(), 0, deceleration)
		velocity.x = vel.normalized().x * temp
		velocity.z = vel.normalized().y * temp
	
func update_velocity() -> void:
	move_and_slide()
