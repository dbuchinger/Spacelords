extends RigidBody2D

var speed = 70.0

func _ready():
	linear_velocity = Vector2(-1, 1).normalized() * speed
	#linear_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed

func _on_body_entered(body):
	speed += 2
	linear_velocity /= (speed-2)
	linear_velocity *= speed
