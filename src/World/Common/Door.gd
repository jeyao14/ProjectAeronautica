extends StaticBody


onready var HITBOX = $Hitbox
export var locked = false
export var health = 100
export var text_offset = 4
onready var current_health = health
onready var FLOATING_TEXT = load(GLOBALS.DAMAGE_FLOATING_TEXT)
onready var MESH = $MeshInstance
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func damage_door(var damage = 1):
	if health == -1:
		return
	health -= damage
	spawn_damage_ui(damage)
	if health <= 0:
		destroy_door()

func destroy_door():
	queue_free()

func spawn_damage_ui(damage = 1):
	var text = FLOATING_TEXT.instance()
	add_child(text)
	text.set_values(damage, Vector3(self.global_transform.origin.x, self.global_transform.origin.y+text_offset, self.global_transform.origin.z + 1))
	
func _on_Hitbox_area_entered(area):
	print(area)
	if area is Bullet:
		damage_door(area.damage)
	
	if not locked and area is Player:
		
		queue_free()


func _on_Hitbox_body_entered(body):
	print(body)
	if body is Bullet:
		damage_door(body.damage)
	
	if not locked and body is Player:
		queue_free()
