extends CharacterBody3D

@onready var animPlayer = $head/pivot/AnimationPlayer

@onready var wallrayfront = $wallRunRaycasts/front
@onready var wallrayback = $wallRunRaycasts/back
@onready var wallrayleft = $wallRunRaycasts/left
@onready var wallrayright = $wallRunRaycasts/right
@onready var pauseMenu = $pauseMenu


@onready var head = $head
@onready var pivot = $head/pivot
@onready var Camera = $head/pivot/Camera3D
@onready var standdamagecollider = $StaticBody3D/CollisionShape3D
@onready var crouchdamagecollider = $StaticBody3D/CollisionShape3D2

@onready var damagebody = $StaticBody3D

@onready var crouchcast = $crouchCast

@onready var standcollider = $standingCollisionShape
@onready var standingMesh = $standingMesh
@onready var crouchcollider = $crouchingCollisionShape

@export var JUMP_VELOCITY = 4.5 * 3
@export var mouse_sens = 0.2

@export var player_enabled = false

@export_category("speed variables")
@export var slidingspeed: float = 10
@export var walkingspeed: float = 8.5
@export var sprintspeed: float = 13
@export var crouchspeed: float = 4.5
#@export var wallRunSpeed:float = 15

@export_category("camera settings")
@export var slideTilt: float
@export var HeadBobbingSprintSpeed: float = 28
@export var HeadBobbingWalkingSpeed: float = 18
@export var HeadBobbingCrouchingSpeed: float = 11

@export var HeadBobbingSprintIntesity: float = 0.2
@export var HeadBobbingWalkIntesity: float = 0.1
@export var HeadBobbingCrouchIntesity: float = 0.05
var currentHeadBobbingIntensity

var headBobbingVector = Vector2.ZERO
var headBobbingIndex = 0.0

#pause buttons
@onready var ResumeButton = get_node("pauseMenu").get_node("MarginContainer/VBoxContainer/Resume")
@onready var RestartButton = get_node("pauseMenu").get_node("MarginContainer/VBoxContainer/Restart")

var sliding = false
var walking = false
var sprinting = false
var crouching = false
var wallRunning = false

var WeaponEquippedInSlot = false

var currentspeed: float
var crouchingdepth = -0.3

var direction = Vector3.ZERO
var Velocity

var wallNormal = Vector3.ZERO

var slideVector = Vector2.ZERO

var slideTime = 0
var slideTimeMax = 2.5

var lastVelocity = Vector3.ZERO

var paused = true
var ResumePressed = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 3.5


func _ready():
	pauseMenu.hide()
	
	wallrayfront.add_exception(damagebody)
	wallrayback.add_exception(damagebody)
	wallrayleft.add_exception(damagebody)
	wallrayright.add_exception(damagebody)
	wallrayfront.add_exception($".")
	wallrayback.add_exception($".")
	wallrayleft.add_exception($".")
	wallrayright.add_exception($".")
	crouchcast.add_exception(damagebody)
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90),  deg_to_rad(90))

func _process(delta):
	if Input.is_action_just_pressed("escape") or ResumePressed:
		if paused:
			pauseMenu.show()
#			player_enabled = false
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			paused = false
		else:
			pauseMenu.hide()
#			player_enabled = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			paused = true



func _physics_process(delta):
	if !player_enabled: return
	
	wallRun()
	
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if !sliding:
			animPlayer.play("jumping")
	
	if Input.is_action_pressed("crouch"):
		
		
		standcollider.disabled = true
		standdamagecollider.disabled = true
		standingMesh.visible = false
		
		crouchcollider.disabled = false
		crouchdamagecollider.disabled = false
		
		head.position.y = lerp(head.position.y,0.7 + crouchingdepth,delta * 10)
		if sprinting == true and input_dir != Vector2(0,0):
			#currentspeed = lerp(currentspeed, slidingspeed, delta * 20)
			sliding = true
		elif is_on_floor():
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
		head.position.y = 0.7
		if Input.is_action_pressed("sprint"):
			if is_on_floor():
				sprinting = true
				walking = false
				crouching = false
				sliding = false
				
				currentspeed = lerp(currentspeed, sprintspeed, delta * 10)
		elif is_on_floor():
			currentspeed = lerp(currentspeed, walkingspeed, delta * 10)
			sprinting = false
			walking = true
			crouching = false
			sliding = false
	
	if wallRunning:
		#currentspeed = wallRunSpeed
		if wallrayleft.is_colliding():
			Camera.rotation.z = lerp(Camera.rotation.z, -deg_to_rad(15), delta * 8)
		elif wallrayright.is_colliding():
			Camera.rotation.z = lerp(Camera.rotation.z, deg_to_rad(15), delta * 8)
		else:
			Camera.rotation.z = lerp(Camera.rotation.z, 0.0, delta * 10)
	
	if sliding:
		if is_on_floor():
			slideTime -= delta
			Camera.rotation.z = lerp(Camera.rotation.z, -deg_to_rad(4), delta * 8)
		else:
			slideTime = slideTimeMax
			Camera.rotation.z = lerp(Camera.rotation.z, 0.0, delta * 8)
		
		if slideTime <= 0:
			sliding = false
			sprinting = false
	else:
		slideTime = slideTimeMax
		Camera.rotation.z = lerp(Camera.rotation.z, 0.0, delta * 10)
	
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
		if lastVelocity.y < 0.0 and !sliding:
			animPlayer.play("landing")
	
	
	if is_on_floor() or wallRunning:
		direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * 10)
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction,(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),delta * 5)
	
	if sliding:
		if is_on_floor():
			currentspeed = (slideTime + 0.2) * slidingspeed
	
	if direction:
		velocity.x = direction.x * currentspeed
		velocity.z = direction.z * currentspeed
	else:
		velocity.x = lerp(velocity.x, 0.0, delta * 7)
		velocity.z = lerp(velocity.z, 0.0, delta * 7)
	
	lastVelocity = velocity
	
	move_and_slide()


func wallRun():
	if !is_on_floor():
		await get_tree().create_timer(0.15).timeout
		if wallrayleft.is_colliding():
			if Input.is_action_pressed("forward"):
				wallRunning = true
				wallNormal = wallrayleft.get_collision_normal()
				if Input.is_action_just_pressed("jump"):
					velocity.y = JUMP_VELOCITY * 1.8
					if sliding:
						direction = direction + (wallNormal * 1.8)
					elif sprinting:
						direction = direction + (wallNormal * 2)
					elif walking:
						direction = direction + (wallNormal * 2.8)
					
					wallRunning = false
				else:
					velocity.y = 0
			else:
				wallRunning = false
		elif wallrayright.is_colliding():
			if Input.is_action_pressed("forward"):
				wallNormal = wallrayright.get_collision_normal()
				wallRunning = true
				if Input.is_action_just_pressed("jump"):
					velocity.y = JUMP_VELOCITY * 1.8
					if sliding:
						direction = direction + (wallNormal * 1.8)
					elif sprinting:
						direction = direction + (wallNormal * 2)
					elif walking:
						direction = direction + (wallNormal * 2.8)
					
					wallRunning = false
				else:
					velocity.y = 0
			else:
				wallRunning = false
		else:
			wallRunning = false
		
		if wallrayfront.is_colliding():
			wallNormal = wallrayfront.get_collision_normal()
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY * 1.8
				if sliding:
					direction = direction + (wallNormal * 1.8)
				elif sprinting:
					direction = direction + (wallNormal * 2)
				elif walking:
					direction = direction + (wallNormal * 2.8)
		elif wallrayback.is_colliding():
			wallNormal = wallrayback.get_collision_normal()
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY * 1.8
				if sliding:
					direction = direction + (wallNormal * 1.8)
				elif sprinting:
					direction = direction + (wallNormal * 2)
				elif walking:
					direction = direction + (wallNormal * 2.8)
		
	else:
		wallRunning = false


func Pause():
	ResumePressed = true
	await get_tree().create_timer(0.0001).timeout
	ResumePressed = false

func Restart():
	get_tree().reload_current_scene()


func Leave():
	get_tree().quit()
