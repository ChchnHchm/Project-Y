@tool
extends Node3D

@export var WeaponType : Weapons :
	set(value):
		WeaponType = value
		if Engine.is_editor_hint():
			loadWeapon()

@onready var weaponMesh : MeshInstance3D = $WeaponMesh
@onready var weaponShadow : MeshInstance3D = $WeaponShadow
@export var player : Player
@export var sway_noise : NoiseTexture2D
@export var sway_speed : float = 1.2
@export var reset : bool = false:
	set(value):
		reset = value
		if Engine.is_editor_hint():
			loadWeapon()
var RandomSwayX
var RandomSwayY
var RandomSwayAmount : float
var time : float = 0.0
var IdleSwayAdjustement
var IdleSwayRotationStrength



var MouseMovement : Vector2
func _input(event):
	if event.is_action_pressed("Switch Hand"):
		position.x =  - position.x
	if event is InputEventMouseMotion:
		MouseMovement = event.relative
		

# Called when the node enters the scene tree for the first time.
func _ready():
	loadWeapon()

func loadWeapon() -> void:
	weaponMesh.mesh = WeaponType.mesh
	position = WeaponType.position
	rotation_degrees = WeaponType.rotation
	weaponShadow.visible = WeaponType.shadow
	scale = WeaponType.scale
	IdleSwayAdjustement = WeaponType.IdleSwayAdjustement
	IdleSwayRotationStrength = WeaponType.IdleSwayRotationStrenght
	RandomSwayAmount = WeaponType.RandomSwayAmount

func SwayWeapon(delta) -> void:
	if not Engine.is_editor_hint():
		#Get random sway value
		var SwayRandom : float = GetSwayNoise()
		var SwayRandomAdjusted : float = SwayRandom * IdleSwayAdjustement
		
		#create time with delta
		time += delta * (sway_speed + SwayRandom)
		RandomSwayX = sin(time * 1.5 + SwayRandomAdjusted) / RandomSwayAmount
		RandomSwayY = sin(time - SwayRandomAdjusted) / RandomSwayAmount
		
		#clamp mouse movement
		MouseMovement = MouseMovement.clamp(WeaponType.SwayMin,WeaponType.SwayMax)
		
		#lerp position
		var WeaponTypePosX : float = WeaponType.position.x
		if position.x < 0:
			# we take neg value if left handed
			WeaponTypePosX = - WeaponTypePosX
		
		position.x = lerp(position.x, WeaponTypePosX - (MouseMovement.x * WeaponType.SwayAmountPosition + RandomSwayX) * delta, WeaponType.SwaySpeedPosition)
		position.y = lerp(position.y, WeaponType.position.y + (MouseMovement.y * WeaponType.SwayAmountPosition + RandomSwayY) * delta, WeaponType.SwaySpeedPosition)

		#lerp rotation
		rotation_degrees.x = lerp(rotation_degrees.x, WeaponType.rotation.x - (MouseMovement.y * WeaponType.SwayAmountRotation + (RandomSwayX * IdleSwayRotationStrength)) * delta, WeaponType.SwaySpeedRotation)
		rotation_degrees.y = lerp(rotation_degrees.y, WeaponType.rotation.y + (MouseMovement.x * WeaponType.SwayAmountRotation + (RandomSwayY * IdleSwayRotationStrength)) * delta, WeaponType.SwaySpeedRotation)
	
func _physics_process(delta):
	SwayWeapon(delta)

func GetSwayNoise() -> float:
	var PlayerPosition : Vector3 = Vector3(0,0,0)
	
	if not Engine.is_editor_hint():
		PlayerPosition = player.global_position
	
	return sway_noise.noise.get_noise_2d(PlayerPosition.x,PlayerPosition.y)
