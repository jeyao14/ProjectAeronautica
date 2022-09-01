extends Spatial


export var rotate_speed = 5
onready var CAMERABOOM = $CameraBoom
onready var TWEEN = $Tween
export var enable_cardinal = false;

var reset = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func rotate_camera(delta):
	if Input.is_action_pressed("c_rotate_left"):
		CAMERABOOM.rotate_y(rotate_speed*delta)
		pass
	if Input.is_action_pressed("c_rotate_right"):
		CAMERABOOM.rotate_y(-rotate_speed*delta)
		pass
	pass
	
func reset_camera(delta):
	var current_rot = CAMERABOOM.rotation_degrees
	
	if (Input.is_action_just_pressed("reset_camera") && enable_cardinal == true):
		reset = true;
		var nearest_cardinal = find_nearest_cardinal(current_rot.y);
		TWEEN.interpolate_property(CAMERABOOM, "rotation_degrees", current_rot, Vector3(current_rot.x,nearest_cardinal,current_rot.z), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		TWEEN.start();
		yield(TWEEN, "tween_completed")
		reset = false;
#		CAMERABOOM.rotation.y = lerp_angle(current_rot, 0, delta*10)
	if (Input.is_action_just_pressed("reset_camera") && enable_cardinal == false):
		reset = true;
		TWEEN.interpolate_property(CAMERABOOM, "rotation_degrees", current_rot, Vector3(current_rot.x,0,current_rot.z), 0.2, Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		TWEEN.start();
		yield(TWEEN, "tween_completed")
		reset = false;
	pass
	
func find_nearest_cardinal(rotation):
	if (rotation < 45 && rotation >= -45):
		rotation = 0;
	if (rotation >= 45 && rotation < 135):
		rotation = 90;
	if (rotation >= 135):
		rotation = 180;
	if( rotation < -135):
		rotation = -180;
	if (rotation >= -135 && rotation < -45):
		rotation = -90;

	return rotation;

func _physics_process(delta):
	if(!reset):
		rotate_camera(delta)
		reset_camera(delta)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
