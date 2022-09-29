extends Player

onready var SPAWNER = $Spawner
onready var SHOOTTIMER = $ShootTimer
var ammocount = magsize


func _ready():
#	$Projectile.connect("test_signal", self, "test_signal_receive")
	print("Ammo: ", ammocount, "/", magsize)
#	don't let this stat go beyond 100
	SPAWNER.cooldown = 1.2 + -(dex/100.0)
#	print("cooldown = ", SPAWNER.cooldown)
	SPAWNER.ammocount = ammocount;
	pass # Replace with function body.

func _physics_process(delta):
	set_animation()
	set_facing()
	GetSpawnerAmmoInfo()

func use_attack():
	if(ammocount > 0):
		SPAWNER.mouse_direction = mouse_direction
		var fireSuccess = SPAWNER.fire()
	print("Ammo: ", ammocount, "/", magsize)

func reload():
	ammocount = magsize;
	SPAWNER.ammocount = ammocount;
	print("Ammo: ", ammocount, "/", magsize)

func stop_attack():
	SPAWNER.shoot = false

func _on_HitBox_area_entered(area):
	print("AREA ENTERED")
	hurt_player()
	pass # Replace with function body.

func use_ability():
	print("using test character 1 ability")

func _on_HitBox_body_entered(body):
	print("BODY ENTERED")
	hurt_player()
	pass # Replace with function body.
	
func GetSpawnerAmmoInfo():
	ammocount = SPAWNER.ammocount

func test_signal_receive():
	print("SIGNAL")
