extends CharacterBody3D

var speed
const WALK_SPEED = 6.0
const RUN_SPEED = 8.0
const JUMP_VELOCITY = 3
const SENSITIVITY = 0.01

# Bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.00

# Init
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var animation_player = $"../AnimationPlayer"
@onready var player_node = $"../player"

func _ready():
	# PLEASE WORK CUTSCENE
	set_physics_process(false)
	$"../AudioStreamPlayer2D".stop()
	animation_player.play("Intro")
	await animation_player.animation_finished
	player_node.visible = false
	set_physics_process(true)
	$"../AudioStreamPlayer2D".play()
	
	$Head/Camera3D.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Sprint
	if Input.is_action_just_pressed("sprint") and is_on_floor():
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time*BOB_FREQ) * BOB_AMP
	pos.x = cos(time*BOB_FREQ/2) * BOB_AMP
	return pos
		
		
