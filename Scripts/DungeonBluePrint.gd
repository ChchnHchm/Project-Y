class_name DungeonsBluePrint extends Resource

@export_category("Difficulty")
@export_range(0,1) var survival_chance : float = 0.25
@export_category("Dungeon Settings")
@export var BorderSize : int = 20 
@export var roomNumber : int = 4
@export var roomMargin : int  = 1
@export var roomRecursion : int = 15
@export var minRoomSize : int = 2
@export var MaxRoomSize : int = 4
@export_category("Dungeon Seed")
@export_multiline var customSeed : String = "" 
