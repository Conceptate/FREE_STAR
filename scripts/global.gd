extends Node

# Declare current_scene as empty
var current_scene = null

# Declare root; the object that is before everything else,
# ie. before the highest parent scene Node.
onready var root = get_tree().get_root()

func _ready():
	# Get the current scene by doing something.. i dont understand what the -1 means
	current_scene = root.get_child(root.get_child_count() - 1)

# Here's the goto_scene that is called with a deferred signal.
# This makes the call come from outside of the game scope/thread,
# specifically in idle time. If the scene is ever deleted,
# you can still call it... somehow. I don't get it either.
func goto_scene(path):
	call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
	# Free/delete the old scene
	current_scene.free()
	print("scene freed")
	
	# Add and instance the new scene
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	
	# Inject the scene into the bigger directory, replacing the old scene in "the scene editor", or root
	root.add_child(current_scene)
	
	# Add the current scene to the current scene API (optional)
	get_tree().set_current_scene(current_scene)