extends CharacterBody2D


const SPEED = 150.0
const ACCELERATION = 600.0
const JUMP_VELOCITY = -300.0
const FRICTION = 600.0

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_time_timer = $CoyoteTimeTimer



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	apply_gravity(delta)

	# Handle Jump.
	handle_jump()

	# Get the input input_axis and handle the movement/deceleration.
	# As good practice, you shouldnt replace UI actions with custom gameplay actions.
	var input_axis = Input.get_axis("ui_left", "ui_right")
	
	handle_acceleration(input_axis, delta)
	
	apply_friction(input_axis, delta)
	
	update_animations(input_axis)
	
	#coyote time, nerd
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_ledge:
		coyote_time_timer.start()
		

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func handle_jump():
	if is_on_floor() or coyote_time_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	if not is_on_floor():
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_VELOCITY/2:
			velocity.y = JUMP_VELOCITY/2


func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)


func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)


func update_animations(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = input_axis < 0
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
	if not is_on_floor():
		animated_sprite_2d.play("jump")
