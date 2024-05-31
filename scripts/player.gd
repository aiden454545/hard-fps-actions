extends CharacterBody3D

@onready var pivot = $pivot
@onready var Camera = $pivot/Camera3D
@onready var standdamagecollider = $StaticBody3D/CollisionShape3D
@onready var crouchdamagecollider = $StaticBody3D/CollisionShape3D2

@onready var damagebody = $StaticBody3D

@onready var crouchcast = $crouchCast

@onready var standcollider = $standingCollisionShape
@onready var crouchcollider = $crouchingCollisionShape

@export var JUMP_VELOCITY = 4.5 * 3
@export var mouse_sens = 0.2

@export var player_enabled = true

@export_category("speed variables")
@export var slidingspeed: float = 6
@export var walkingspeed: float = 7
@export var sprintspeed: float = 10
@export var crouchspeed: float = 3.5

@export_category("camera settings")
@export var slideTilt: float
@export var HeadBobbingSprintSpeed: float = 22
@export var HeadBobbingWalkingSpeed: float = 16
@export var HeadBobbingCrouchingSpeed: float = 10

@export var HeadBobbingSprintIntesity: float = 0.2
@export var HeadBobbingWalkIntesity: float = 0.1
@export var HeadBobbingCrouchIntesity: float = 0.05
var currentHeadBobbingIntensity

var camNormalRot = Vector3.ZERO

var headBobbingVector = Vector2.ZERO
var headBobbingIndex = 0.0


var sliding = false
var walking = false
var sprinting = false
var crouching = false

var currentspeed: float
var crouchingdepth = -0.3

var camera_rotation: Vector3

var direction = Vector3.ZERO
var Velocity

var max: float = 4
var slideVector = Vector2.ZERO

var slideTime = 0
var slideTimeMax = 2.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 3.5

func _ready():
	camNormalRot = Camera.rotation
	crouchcast.add_exception($StaticBody3D)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			Camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-90),  deg_to_rad(90))

func _process(delta):
	if Input.is_action_just_pressed("escape") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif Input.is_action_just_pressed("escape") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if !player_enabled: return
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("crouch"):
		
		
		standcollider.disabled =true
		standdamagecollider.disabled = true
		
		crouchcollider.disabled = false
		crouchdamagecollider.disabled = false
		
		Camera.position.y = lerp(Camera.position.y,0.7 + crouchingdepth,delta * 10)
		if sprinting == true and input_dir != Vector2(0,0):
			#currentspeed = lerp(currentspeed, slidingspeed, delta * 20)
			sliding = true
		else:
			currentspeed = lerp(currentspeed, crouchspeed, delta * 10)
			sprinting = false
			sliding = false
			walking = false
			crouching = true
		
		
	elif !crouchcast.is_colliding():
		standcollider.disabled = false
		standdamagecollider.disabled = false
		crouchcollider.disabled = true
		crouchdamagecollider.disabled = true
		Camera.position.y = 0.7
		if Input.is_action_pressed("sprint"):
			sprinting = true
			walking = false
			crouching = false
			sliding = false
			
			currentspeed = lerp(currentspeed, sprintspeed, delta * 10)
		else:
			currentspeed = lerp(currentspeed, walkingspeed, delta * 10)
			sprinting = false
			walking = true
			crouching = false
			sliding = false
	
	if sliding:
		slideTime -= delta
		if slideTime <= 0:
			sliding = false
			sprinting = false
	else:
		slideTime = slideTimeMax
	
	
	if sprinting:
		currentHeadBobbingIntensity = HeadBobbingSprintIntesity
		headBobbingIndex += HeadBobbingSprintSpeed * delta
	elif walking:
		currentHeadBobbingIntensity = HeadBobbingWalkIntesity
		headBobbingIndex += HeadBobbingWalkingSpeed * delta
	elif crouching:
		currentHeadBobbingIntensity = HeadBobbingCrouchIntesity
		headBobbingIndex += HeadBobbingCrouchingSpeed * delta
	
	if is_on_floor() and !sliding and input_dir != Vector2.ZERO:
		headBobbingVector.y = sin(headBobbingIndex)
		headBobbingVector.x = sin(headBobbingIndex/2)
		
		pivot.position.y = lerp(pivot.position.y, headBobbingVector.y * (currentHeadBobbingIntensity/2), delta * 10)
		pivot.position.x = lerp(pivot.position.x, headBobbingVector.x * currentHeadBobbingIntensity, delta * 10)
	else:
		pivot.position.y = lerp(pivot.position.y, 0.0, delta * 10)
		pivot.position.x = lerp(pivot.position.x, 0.0, delta * 10)
	
	
	if is_on_floor():
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * 10)
	else:
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * 5)
	
	if sliding:
		currentspeed = (slideTime + 0.2) * slidingspeed
	
	if direction:
		velocity.x = direction.x * currentspeed
		velocity.z = direction.z * currentspeed
	else:
		velocity.x = move_toward(velocity.x, 0, currentspeed)
		velocity.z = move_toward(velocity.z, 0, currentspeed)

	move_and_slide()

