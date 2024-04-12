extends CharacterBody3D

@onready var Camera = $Camera3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5 * 4
@export var mouse_sens = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 6

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
			Camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
			Camera.rotation.x = clamp(Camera.rotation.x, deg_to_rad(-90),  deg_to_rad(90))

func _process(delta):
	if Input.is_action_just_pressed("ui_text_completion_replace"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
