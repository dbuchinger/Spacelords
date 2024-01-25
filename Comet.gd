extends CharacterBody2D

var speed = 100.0

var paddle_id = 28219278566

func _ready():
	velocity = Vector2(-1, .75).normalized() * speed
	#linear_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if collision_info.get_collider().is_in_group("Paddles"):
			velocity = global_position - collision_info.get_collider().global_position
			speed = clamp(speed + 5, 100, 300)
			velocity = velocity.normalized() * speed
		else: 
			speed = clamp(speed + 5, 100, 300)
			velocity = velocity.normalized() * speed
			velocity = velocity.bounce(collision_info.get_normal())
