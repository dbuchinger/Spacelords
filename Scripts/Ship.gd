extends CharacterBody2D

var speed = 5
var ship_velocity = Vector2.ZERO
var thrust_vector = Vector2.ZERO
var thrust = 10
var drag = .0000000000000001

func _physics_process(delta):
	thrust_vector.x = Input.get_action_strength("ship_right") - Input.get_action_strength("ship_left")
	thrust_vector.y = Input.get_action_strength("ship_down") - Input.get_action_strength("ship_up") 
	thrust_vector = thrust_vector.normalized() * speed
	
	if thrust_vector != Vector2.ZERO:
		ship_velocity = ship_velocity.move_toward(thrust_vector*speed, thrust*delta)
	else:
		ship_velocity = ship_velocity.move_toward(Vector2.ZERO, drag*delta)
	
	move_and_collide(ship_velocity)
