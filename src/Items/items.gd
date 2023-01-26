extends Interactable

func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	if body is Player:
		print ("item picked up")
		body.weap_damage_min += 2
		body.weap_damage_max += 2
		print ("damage up 2")
		call_deferred('free')
