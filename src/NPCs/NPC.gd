extends KinematicBody
class_name NPC

export var title = ""

var detect : bool = false

onready var HITBOX = get_node("HitBox/CollisionShape")
onready var COLLIDER = $InteractionDetection
onready var SPEECH_BUBBLE_CONTAINER = $Node2D/Viewport/Control/Panel/InteractionContainer

var speech_bubble = preload("res://UI/SpeechBubble.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = true;
	
func create_speech_bubble(name, text):
	var childcount = SPEECH_BUBBLE_CONTAINER.get_child_count()
	print(childcount)
	if(SPEECH_BUBBLE_CONTAINER.get_child_count() > 0):
		return;
	var speech = speech_bubble.instance()
	SPEECH_BUBBLE_CONTAINER.add_child(speech)
	speech.set_values(name, text)
	print("speech bubble")
	
func clear_speech_bubble():
	if(SPEECH_BUBBLE_CONTAINER.get_child_count() > 0):
		var speechtodelete = SPEECH_BUBBLE_CONTAINER.get_child(0);
		speechtodelete.queue_free();
