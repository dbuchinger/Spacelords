extends CharacterBody2D

var base_speed = 400
var max_speed = 1200
var current_speed = base_speed
var acceleration_rate = 10

func _ready():
	velocity = Vector2(-1, .75).normalized() * current_speed
	#linear_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed

func _physics_process(delta):
	rotation += current_speed/200 * delta
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		if collision_info.get_collider().is_in_group("Paddles"):
			velocity = global_position - collision_info.get_collider().global_position
			current_speed = clamp(current_speed + acceleration_rate, base_speed, max_speed)
			velocity = velocity.normalized() * current_speed
			print(current_speed)
		elif collision_info.get_collider().is_in_group("Shields"):
			current_speed = clamp(current_speed + acceleration_rate, base_speed, max_speed)
			velocity = velocity.normalized() * current_speed
			velocity = velocity.bounce(collision_info.get_normal())
			collision_info.get_collider().queue_free()
			print(current_speed)
		else: 
			current_speed = clamp(current_speed + acceleration_rate, base_speed, max_speed)
			velocity = velocity.normalized() * current_speed
			velocity = velocity.bounce(collision_info.get_normal())
			print(current_speed)
