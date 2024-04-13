class_name Weapons extends Resource

@export var name : StringName
@export_category("Weapon Orientation")
@export var position : Vector3
@export var rotation : Vector3
@export_category("Weapon Sway")
@export var SwayMin: Vector2 = Vector2(-20.0,-20.0)
@export var SwayMax : Vector2 = Vector2(20.0,20.0)
@export_range(0,0.2,0.01) var SwaySpeedPosition : float = 0.07
@export_range(0,0.2,0.01) var SwaySpeedRotation : float = 0.1
@export_range(0,0.25,0.01) var SwayAmountPosition : float = 0.1
@export_range(0,50,0.1) var SwayAmountRotation : float = 30
@export_category("Visual Settings")
@export var mesh : Mesh
@export var shadow : bool
@export var damageAmount : float
