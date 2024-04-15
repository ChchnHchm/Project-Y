@tool
extends Node3D
@onready var grid_map : GridMap = $GridMap


@export var start : bool = false : set = set_start
func set_start(val:bool) ->void:
	if Engine.is_editor_hint():
		generate()
@export_range(0,1) var survival_chance : float = 0.25
@export var BorderSize : int = 20 : 	set = set_border_size
func set_border_size(val:int) ->void:
	BorderSize = val
	if Engine.is_editor_hint():
		visualizeBorder()
@export var roomNumber : int = 4

@export var roomMargin : int  = 1
@export var roomRecursion : int = 15
@export var minRoomSize : int = 2
@export var MaxRoomSize : int = 4
@export_multiline var customSeed : String = "" : set = setSeed
func setSeed(val:String)->void:
	customSeed = val
	seed(val.hash())
@export var Reset : bool = false : set = set_reset
func set_reset(val:bool)->void:
	var DungeonCells : Node3D = $"Dungeon Mesh"
	if DungeonCells.get_child_count() > 0:
		for n in DungeonCells.get_children(): n.queue_free()
	if grid_map :
		grid_map.clear()
var roomTiles : Array[PackedVector3Array] = []
var roomPosition : PackedVector3Array = []


func visualizeBorder()->void:
	if grid_map :
		grid_map.clear()
	for i in range(-1,BorderSize+1):
		grid_map.set_cell_item(Vector3i(i,0,-1),3)
		grid_map.set_cell_item(Vector3i(i,0,BorderSize),3)
		grid_map.set_cell_item(Vector3i(BorderSize,0,i),3)
		grid_map.set_cell_item(Vector3i(-1,0,i),3)


func generate()->void:
	roomTiles.clear()
	roomPosition.clear()
	if customSeed : setSeed(customSeed)
	visualizeBorder()
	for i in roomNumber:
		makeRoom(roomRecursion)
	
	var roomPostitionVector2 : PackedVector2Array = []
	var del_graph : AStar2D = AStar2D.new()
	var mst_graph : AStar2D = AStar2D.new()

	for p in roomPosition:
		roomPostitionVector2.append(Vector2(p.x,p.z))
		del_graph.add_point(del_graph.get_available_point_id(),Vector2(p.x,p.z))
		mst_graph.add_point(mst_graph.get_available_point_id(),Vector2(p.x,p.z))
		
		
	var delauney : Array = Array(Geometry2D.triangulate_delaunay(roomPostitionVector2))
	
	
	for i in delauney.size()/3:
		var p1 : int = delauney.pop_front()
		var p2 : int = delauney.pop_front()
		var p3 : int = delauney.pop_front()
		del_graph.connect_points(p1,p2)
		del_graph.connect_points(p2,p3)
		del_graph.connect_points(p1,p3)

	var visitedPoints : PackedInt32Array = []
	visitedPoints.append(randi() % roomPosition.size())
	while visitedPoints.size() != mst_graph.get_point_count():
		var PossibleConnections : Array[PackedInt32Array] = []
		for visitedPoint in visitedPoints:
			for connexion in del_graph.get_point_connections(visitedPoint):
				if !visitedPoints.has(connexion):
					var con : PackedInt32Array = [visitedPoint, connexion]
					PossibleConnections.append(con)

		var connection : PackedInt32Array = PossibleConnections.pick_random()
		for pc in PossibleConnections:
			if roomPostitionVector2[pc[0]].distance_squared_to(roomPostitionVector2[pc[1]]) <\
			roomPostitionVector2[connection[0]].distance_squared_to(roomPostitionVector2[connection[1]]):
				connection = pc
		
		
		visitedPoints.append(connection[1])
		mst_graph.connect_points(connection[0], connection[1])
		del_graph.disconnect_points(connection[0],connection[1])
	
	var hallway_graph : AStar2D = mst_graph

	for p in del_graph.get_point_ids():
		for c in del_graph.get_point_connections(p):
			if c>p :
				var kill : float = randf()
				if survival_chance > kill:
					hallway_graph.connect_points(p,c)
	
	createHallways(hallway_graph)

func createHallways(hallway_graph:AStar2D):
	var hallways : Array[PackedVector3Array] = []
	for p in hallway_graph.get_point_ids():
		for c in hallway_graph.get_point_connections(p):
			if c>p:
				var roomFrom : PackedVector3Array = roomTiles[p]
				var roomTo : PackedVector3Array = roomTiles[c]
				var tileFrom : Vector3 = roomFrom[0]
				var tileTo : Vector3 = roomTo[0]
				for t in roomFrom:
					if t.distance_squared_to(roomPosition[c]) <\
					tileFrom.distance_squared_to(roomPosition[c]):
						tileFrom = t
				for t in roomTo:
					if t.distance_squared_to(roomPosition[p]) <\
					tileTo.distance_squared_to(roomPosition[p]):
						tileTo = t
				var hallway : PackedVector3Array = [tileFrom,tileTo]
				hallways.append(hallway)
				grid_map.set_cell_item(tileFrom,2)
				grid_map.set_cell_item(tileTo,2)
	var astar : AStarGrid2D = AStarGrid2D.new()
	astar.size = Vector2i.ONE * BorderSize
	astar.update()
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	
	for t in grid_map.get_used_cells_by_item(0):
		astar.set_point_solid(Vector2i(t.x,t.z))
	for h in hallways:
		var pos_from : Vector2i = Vector2i(h[0].x,h[0].z)
		var pos_to : Vector2i = Vector2i(h[1].x,h[1].z)
		var hall: PackedVector2Array = astar.get_point_path(pos_from,pos_to)
		for t in hall:
			var pos : Vector3i = Vector3i(t.x,0,t.y)
			if grid_map.get_cell_item(pos) < 0:
				grid_map.set_cell_item(pos,1)
func makeRoom(rec : int):
	if !rec > 0:
		return

	var width : int = (randi() % (MaxRoomSize - minRoomSize)) + minRoomSize
	var height : int = (randi() % (MaxRoomSize - minRoomSize)) + minRoomSize

	var startPosition : Vector3i
	startPosition.x = randi() % (BorderSize - width +1)
	startPosition.z = randi() % (BorderSize - height +1)

	for r in range(-roomMargin, height+roomMargin):
		for c in range(-roomMargin,width+roomMargin):
			var pos : Vector3i = startPosition + Vector3i(c,0,r)
			if grid_map.get_cell_item(pos) == 0:
				makeRoom(rec-1)
				return

	var room : PackedVector3Array = []
	for r in height:
		for c in width:
			var pos : Vector3i = startPosition + Vector3i(c,0,r)
			grid_map.set_cell_item(pos,0)
			room.append(pos)
	roomTiles.append(room)
	var avgX : float = startPosition.x + (float(width)/2)
	var avgZ : float = startPosition.z + (float(height)/2)
	var pos :Vector3 = Vector3(avgX,0,avgZ)
	roomPosition.append(pos)
