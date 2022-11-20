extends CharacterBody3D

# 鼠标灵敏度
var MOUSE_SENSITIVITY = 0.1

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		$CameraRoot.rotate_x(deg_to_rad(event.relative.y) * MOUSE_SENSITIVITY * -1.0)
		$CameraRoot.rotation.x = clamp($CameraRoot.rotation.x, deg_to_rad(-75.0), deg_to_rad(75.0))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY) * -1)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	@warning_ignore(return_value_discarded)
	move_and_slide()