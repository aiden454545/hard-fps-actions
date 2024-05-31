extends Node3D

@onready var RayCast = $RayCast3D

@export var speed = 3

var oldPos
var newPos
var starterPos

var direction

var lifetime = 5

var damage
var gun
var player
var guninteract


func _ready():
	direction = global_transform.basis.z
	oldPos = global_transform.origin
	starterPos = global_transform.origin
	RayCast.top_level = true
	get_tree().create_timer(lifetime).timeout.connect(destroy)




func _process(delta):
	RayCast.add_exception(player)
	RayCast.add_exception(gun)
	RayCast.add_exception(guninteract)
	


func _physics_process(delta):
	newPos = global_transform.origin - (direction * speed * delta)
	
	#DebugDraw3D.draw_sphere(RayCast.global_transform.origin, 1, Color.MAGENTA, 5)
	
	
	var direct_space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(oldPos, newPos)
	query.exclude = [player, player.damagebody, gun, guninteract, self]
	var result = direct_space.intersect_ray(query)
	result_func(result)
	
	global_transform.origin = newPos
	
	
	#if RayCast.is_colliding():
	#	var result = RayCast.get_collider()
	
	
	DebugDraw3D.draw_arrow(starterPos, newPos, Color.RED, 0.1, true)
	oldPos = newPos

func result_func(result):
	if result:
		DebugDraw3D.draw_sphere(result.position)
		var normal = result.normal
		if result.collider is RigidBody3D:
			result.collider.apply_force(direction * -200, result.position)
		
		if result.collider is Damageable:
			print("damage: " + str(damage))
			result.collider.take_damage(damage)
			SpawnParticles(result, "HitParticle")
			destroy()
		else:
			SpawnParticles(result, "HitParticle")
			destroy()


func SpawnParticles(result, particle):
	if particle == "HitParticle":
		var HPar = Preload.HitParcticles.instantiate()
		result.collider.add_child(HPar)
		HPar.global_position = result.position
	else:
		return


func destroy():
	queue_free()
