class_name DebugPanel extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer
#
#var property
var frames_per_second : String
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.debug = self
	
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if visible:
		frames_per_second = "%.2f" % (1.0/delta) # recuper les fps a chaque frame
		#frames_per_second = str(Engine.get_frames_per_second()) # recupere les fps a chaque seconde
		#property.text = property.name + ": " + frames_per_second
		add_debug_property("FPS",frames_per_second,1)

func _input(event):
	#toggle debug panel when press
	if event.is_action_pressed("DebugPanel"):
		visible = !visible
func add_debug_property(title: String, value, order):
	var target
	target = property_container.find_child(title,true,false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": "+str(value)
	elif visible:
		target.text = title+ ": "+str(value)
