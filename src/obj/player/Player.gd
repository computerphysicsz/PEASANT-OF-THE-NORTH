extends KinematicBody2D

signal barrel_jump
signal killed

onready var sprite = $Sprite
onready var camera = $Camera
onready var timer = $Timer

const GRAVITY = 900

const XAXIS_DECEL = 0.6
const YAXIS_DECEL = 0.2

const XAXIS_FORCE = 2000 / XAXIS_DECEL
const YAXIS_FORCE = 300
const YAXIS_HOLD = 5

const XAXIS_TERMINAL = XAXIS_FORCE / 20 * XAXIS_DECEL
const YAXIS_TERMINAL = 500

var velocity = Vector2()

var dead = false

# THANKS "PLATFORMER 2D" FOR STEPS I SHOULD CONSIDER
# STEPS FOR SELF:
# MOVEMENT AXES (Y-X)
# DIRECTION
# ANIMATION

func _physics_process(delta):
	if !dead:
		# Honestly these physics are complete suckage but I don't care I'm getting this done
		
		# [X AXIS]
		# > Run!
		var b = 1 + int(Input.is_action_pressed("b_button")) * 0.8
		# > Get axes of movement and immediately multiply by the force level and delta.
		var walk = Input.get_axis("dpad_left", "dpad_right") * XAXIS_FORCE * b
		# > Friction.
		var friction
		if is_on_floor():
			friction = XAXIS_DECEL
		else:
			friction = 1
		# > Collisions.
		if is_on_wall():
			velocity.x = 0
		# > Clamp to terminal values.
		var application = 1 if is_on_floor() else 0.1
		velocity.x = clamp(friction * (velocity.x + walk * delta * application), -XAXIS_TERMINAL * b, XAXIS_TERMINAL * b)
		
		# [Y AXIS]
		# > Allow jumping.
		if Input.is_action_just_pressed("a_button") and is_on_floor():
		# if Input.is_action_just_pressed("a_button") and (is_on_floor() or (velocity.y < 50 and !is_on_floor())):
			velocity.y = -YAXIS_FORCE
			# * On that note. Take x into account.
			velocity.y -= abs(walk) * 0.007
		# > Holding jump midair.
		if Input.is_action_pressed("a_button") and !Input.is_action_just_pressed("a_button") and velocity.y < 0:
			velocity.y -= YAXIS_HOLD
		# > Gravity and collisions.
		if velocity.y > 0 and is_on_floor():
			velocity.y = 0
		elif velocity.y < 0 and is_on_ceiling():
			velocity.y = GRAVITY * delta
		else:
			velocity.y += GRAVITY * delta
		# > Clamp to terminal values.
		velocity.y = clamp(velocity.y, -YAXIS_TERMINAL, YAXIS_TERMINAL)
		
		# [MOVE CHARACTER]
		move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		
		# [ANIMATE]
		# Easy enough.
		# > Flipping.
		if walk != 0: sprite.flip_h = walk < 0;
		# > Actual animations.
		if is_on_floor():
			if abs(velocity.x) > 50:
				sprite.play("Walk")
				sprite.speed_scale = abs(velocity.x) / XAXIS_TERMINAL
			else: sprite.play("Idle")
		else:
			if velocity.y > -50:
				sprite.play("Fall")
			else: sprite.play("Jump")
			
	else:
		velocity.y += GRAVITY * delta
		move_and_slide_with_snap(velocity, Vector2.DOWN, Vector2.UP)
		sprite.play("Dead")


func _on_Player_barrel_jump():
	velocity.y = -500
	velocity.y -= abs(velocity.x) * 0.007

func _on_Player_killed():
	if !dead:
		dead = true
		set_collision_mask_bit(0, false)
		velocity.y = -YAXIS_TERMINAL * 0.8
		timer.start()

func _on_Timer_timeout():
	get_tree().reload_current_scene()
