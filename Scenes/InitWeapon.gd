@tool
extends Node3D

@export var WeaponType : Weapons :
	set(value):
		WeaponType = value
		if Engine.is_editor_hint():
			loadWeapon()

@onready var weaponMesh : MeshInstance3D = $WeaponMesh
@onready var weaponShadow : MeshInstance3D = $WeaponShadow

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

func SwayWeapon(delta) -> void:
	
	#clamp mouse movement
	MouseMovement = MouseMovement.clamp(WeaponType.SwayMin,WeaponType.SwayMax)
	
	#lerp position
	var WeaponTypePosX : float = WeaponType.position.x
	if position.x < 0:
		# we take neg value if left handed
		WeaponTypePosX = - WeaponTypePosX
	
	position.x = lerp(position.x, WeaponTypePosX - (MouseMovement.x * WeaponType.SwayAmountPosition) * delta, WeaponType.SwaySpeedPosition)
	position.y = lerp(position.y, WeaponType.position.y + (MouseMovement.y * WeaponType.SwayAmountPosition) * delta, WeaponType.SwaySpeedPosition)

	#lerp rotation
	rotation_degrees.x = lerp(rotation_degrees.x, WeaponType.rotation.x - (MouseMovement.y * WeaponType.SwayAmountRotation) * delta, WeaponType.SwaySpeedRotation)
	rotation_degrees.y = lerp(rotation_degrees.y, WeaponType.rotation.y + (MouseMovement.x * WeaponType.SwayAmountRotation) * delta, WeaponType.SwaySpeedRotation)
	
func _physics_process(delta):
	SwayWeapon(delta)
