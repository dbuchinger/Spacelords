extends CharacterBody2D

var speed = 70.0

func _ready():
	velocity = Vector2(-1, 1).normalized() * speed
	#linear_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity *= 1.03
		velocity = velocity.bounce(collision_info.get_normal())
