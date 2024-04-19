@tool
class_name DungeonCell extends Node3D

func _ready():
	print(owner)
	
func remove_wall_up():
	$Wall/Wall_up.free()
func remove_wall_down():
	$Wall/Wall_down.free()
func remove_wall_right():
	$Wall/Wall_right.free()
func remove_wall_left():
	$Wall/Wall_left.free()
func remove_door_up():
	$Door/Door_up.free()
func remove_door_down():
	$Door/Door_down.free()
func remove_door_right():
	$Door/Door_right.free()
func remove_door_left():
	$Door/Door_left.free()
