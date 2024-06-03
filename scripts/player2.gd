extends RigidBody3D


@onready var floorCast = $floorCast
@onready var head = $Head
@onready var pivot = $Head/Pivot
@onready var camera = $Head/Pivot/Camera3D

@export var player_enabled = true

@export_group("speed variables")
@export var walkingSpeed: float = 7
@export var sprintingSpeed: float = 10
@export var slidingSpeed: float = 6
@export var crouchingSpeed: float = 4
@export var stopSpeed: float = 2

@export var mouse_sens = 0.2

@export var debug: bool = false


var fbDir
var lrDir
var grip = 10

var mouseInput

var neededForce
var currentMoveSpeed

func _ready():
	linear_damp = 1.0
	fbDir = -head.transform.basis.z
	lrDir = -head.transform.basis.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fbDir = -head.transform.basis.z
	lrDir = -head.transform.basis.x
	head.global_position = global_position + Vector3(0, 0.7, 0)

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			mouseInput = event
			head.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-90),  deg_to_rad(90))

func _physics_process(delta):
	if !player_enabled: return
	var input = Input.get_vector("left", "right", "forward", "back")
	
	if Input.is_action_pressed("crouch"):
		currentMoveSpeed = crouchingSpeed
	else:
		if Input.is_action_pressed("sprint"):
			currentMoveSpeed = sprintingSpeed
		else:
			currentMoveSpeed = walkingSpeed
	var fbtorque = -input.x * currentMoveSpeed
	var lrtorque = -input.y * currentMoveSpeed
	
	if input.x != 0 or input.y != 0:
		lrtorque = (-input.x * currentMoveSpeed) / 1.5
		fbtorque = (-input.y * currentMoveSpeed) / 1.5
	
	if input.x == 0 and input.y == 0 and floorCast.is_colliding():
		apply_stoping_force(input)
	
	apply_z_force()
	apply_central_impulse(fbDir * fbtorque / 20)
	apply_central_impulse(lrDir * lrtorque / 20)
	
	if debug:
		DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + (fbDir * fbtorque / 2), Color.BLUE, 0.1, true)
		DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + (lrDir * lrtorque / 2), Color.RED, 0.1, true)


func apply_stoping_force(input):
	var fbdir = -global_basis.z
	var lrdir = -global_basis.x
	var state := PhysicsServer3D.body_get_direct_state(get_rid())
	var tire_world_vel := state.get_velocity_at_local_position( global_position)
	var fbforce = fbdir.dot(tire_world_vel) * mass * 8
	var lrforce = lrdir.dot(tire_world_vel) * mass * 8
	
	apply_central_force(-fbdir * fbforce)
	apply_central_force(-lrdir * lrforce)
	
	if debug:
		DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + (-fbdir * fbforce), Color.PURPLE, 0.1, true)
		DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + (-lrdir * lrforce), Color.PURPLE, 0.1, true)

func apply_z_force():
	var fbdir: Vector3 = global_basis.z
	var lrdir: Vector3 = global_basis.x
	var state := PhysicsServer3D.body_get_direct_state(get_rid())
	var tire_world_vel := state.get_velocity_at_local_position(global_position - global_position)
	var fbforce = fbdir.dot(tire_world_vel) * mass /2
	var lrforce = lrdir.dot(tire_world_vel) * mass /2
	
	apply_central_force(-fbdir * fbforce)
	apply_central_force(-lrdir * lrforce)
	
	if debug:
		DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + (-fbdir * fbforce / 8), Color.PINK, 0.1, true)
		DebugDraw3D.draw_arrow(global_transform.origin, global_transform.origin + (-lrdir * lrforce / 8), Color.PINK, 0.1, true)
