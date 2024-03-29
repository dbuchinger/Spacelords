extends Area2D

var death_timer = 0
var bullet_lifespan = 0
var speed = 800
var velocity = Vector2.ZERO

func _ready():
	death_timer = Time.get_ticks_msec() + bullet_lifespan

func _process(delta):
	if Time.get_ticks_msec() >= death_timer:
		queue_free()

func _physics_process(delta):
	position += velocity * speed * delta

func _on_body_entered(body):
	queue_free()
