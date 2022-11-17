extends Node

onready var PARENT = get_parent()
onready var STUN_TIMER = $StunTimer
onready var SLOW_TIMER = $SlowTimer

export var stun = false
onready var stunicon = preload("res://Assets/Status/stun.png")
export var slow = false
onready var slowicon = preload("res://Assets/Status/slow.png")

var base_speed = 0.0
var slowed_speed = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _physics_process(delta):
	pass

# SLOW FUNCTIONS
func set_defaults(ref):
	PARENT = ref
	
	if ref.speed:
		base_speed = ref.speed

func slow(duration: float = 2.0, slow_divider:float = 2.0):
	if parent_null():
		return
	if PARENT.speed == null:
		return
	
	if slow:
		SLOW_TIMER.wait_time = duration
		SLOW_TIMER.start()
		return
	
	slow = true
	PARENT.create_status_icon("slow", slowicon);
	if base_speed == 0.0:
		base_speed = PARENT.speed
	slowed_speed = base_speed / slow_divider
	PARENT.speed = slowed_speed
	
	if SLOW_TIMER:
		SLOW_TIMER.wait_time = duration
		SLOW_TIMER.start()
	else:
		yield(get_tree().create_timer(duration, false), "timeout")
		slow = false
		PARENT.speed = base_speed
	pass
	
func _on_SlowTimer_timeout():
	slow = false
	PARENT.speed = base_speed
	PARENT.clear_status("slow")
	pass # Replace with function body.

# STUN FUNCTIONS
func stun(duration:float = 2.0):
	if parent_null():
		return
	if(stun == true):
		STUN_TIMER.stop()
		STUN_TIMER.wait_time = duration;
		STUN_TIMER.start();
		return
	stun = true
#	PARENT.set_physics_process(false)
	PARENT.create_status_icon("stun", stunicon);
	if STUN_TIMER:
		STUN_TIMER.wait_time = duration
		STUN_TIMER.start()
	else:
		yield(get_tree().create_timer(duration, false), "timeout")
#		PARENT.set_physics_process(true)

func _on_StunTimer_timeout():
	stun = false
#	PARENT.set_physics_process(true)
	PARENT.clear_status("stun")
	pass # Replace with function body.

func parent_null():
	if PARENT == null:
		return true
	return false
