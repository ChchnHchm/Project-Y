@tool
extends Node3D

@export var WeaponType : Weapons :
	set(value):
		WeaponType = value
		if Engine.is_editor_hint():
			loadWeapon()

@onready var weaponMesh : MeshInstance3D = $WeaponMesh
@onready var weaponShadow : MeshInstance3D = $WeaponShadow

func _input(event):
	if event.is_action_pressed("Switch Hand"):
		if position == WeaponType.positionRightHand:
			position = WeaponType.positionLeftHand
		else:
			position = WeaponType.positionRightHand

# Called when the node enters the scene tree for the first time.
func _ready():
	loadWeapon()

func loadWeapon() -> void:
	weaponMesh.mesh = WeaponType.mesh
	position = WeaponType.positionRightHand
	rotation_degrees = WeaponType.rotation
	weaponShadow.visible = WeaponType.shadow
