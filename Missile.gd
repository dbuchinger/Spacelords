extends Area2D

var death_time = 0
var speed = 150
var velocity = Vector2.ZERO

func _ready():
	death_time = Time.get_ticks_msec() + 5000

func _process(delta):
	if Time.get_ticks_msec() >= death_time:
		queue_free()

func _physics_process(delta):
	position += velocity * speed * delta

func _on_body_entered(body):
	if body.is_in_group("Shields"):
		body.queue_free()
	
	queue_free()
