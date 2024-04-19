extends Node3D

var WorldGenerator : PackedScene = preload("res://Scenes/Dungeon.tscn")
var DungeonResource : DungeonsBluePrint = preload("res://assets/DongeonRes.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	var Generator : DungeonGenerator = WorldGenerator.instantiate()
	add_child(Generator)
	Generator.SetDungeonType(DungeonResource)
	Generator.SetDungeonFromCode(get_node("."))
