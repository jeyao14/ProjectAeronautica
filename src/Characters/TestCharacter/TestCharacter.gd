extends Player

<<<<<<< Updated upstream
=======
onready var SPAWNER = $Spawner
onready var ABILITYTIMER = $AbilityCooldown
onready var	TURRETGROUP = $TurretGroup
onready var TURRETTYPE = preload("res://Characters/TestCharacter/Turret/TemplateTurret.tscn")
var ability_active = false

func _ready():
#	$Projectile.connect("test_signal", self, "test_signal_receive")
	pass # Replace with function body.

func _physics_process(delta):
	set_animation()
	set_facing()

func _on_HitBox_area_entered(area):
	print("AREA ENTERED")
	hurt_player()
	pass # Replace with function body.

func use_attack():
	print("using test character 1 attack");

func use_ability():
	print("using test character 1 ability")

func _on_HitBox_body_entered(body):
	print("BODY ENTERED")
	hurt_player()
	pass # Replace with function body.

func test_signal_receive():
	print("SIGNAL")
