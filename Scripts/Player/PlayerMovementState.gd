class_name PlayerMovementState extends State

var PLAYER: Player
var ANIMATION : AnimationPlayer
var Weapon : WeaponController
@export var SPEED : float = 5.0
@export var ACCELERATION : float = 0.1 # anything between 0 and 1
@export var DECELERATION : float = 0.25 # anything between 0 and 1 
@export var WeaponBobSpeed : float = 6.0
@export var WeaponBobHorizontal: float = 2.0
@export var WeaponBobVertical: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#PLAYER = get_tree().get_first_node_in_group("Player")
	await owner.ready
	PLAYER = owner
	ANIMATION = PLAYER.ANIMATIONPLAYER
	Weapon = PLAYER.WeaponController


