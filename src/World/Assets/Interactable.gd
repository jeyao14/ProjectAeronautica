extends KinematicBody
class_name Interactable

var detected : bool = false

onready var INTERACTION_CONTAINER = $Node2D/Viewport/Control/Panel/InteractionContainer

var speech_bubble = preload("res://ButtonInteraction.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func create_interaction():
	if(INTERACTION_CONTAINER.get_child_count() > 0):
		return;
	var speech = speech_bubble.instance()
	INTERACTION_CONTAINER.add_child(speech)
	
func clear_interaction():
	if(INTERACTION_CONTAINER.get_child_count() > 0):
		var interactiontodelete = INTERACTION_CONTAINER.get_child(0);
		interactiontodelete.queue_free();
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
