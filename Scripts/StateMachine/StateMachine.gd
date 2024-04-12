class_name StateMachine extends Node

@export var CURRENT_STATE : State
var states: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	#on recherche tout les state enfant pour les ranger dans la liste
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child node")
	await owner.ready
	CURRENT_STATE.enter(null)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	CURRENT_STATE.update(delta)
	Global.debug.add_debug_property("Current State",CURRENT_STATE.name,1)


func _physics_process(delta):
	CURRENT_STATE.physics_update(delta)


func on_child_transition(new_state_name: StringName):
	var new_state = states.get(new_state_name)
	if new_state :
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter(new_state)
			CURRENT_STATE = new_state
	else:
		push_warning(new_state_name + " State does not exist")
