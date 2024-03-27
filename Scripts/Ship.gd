extends CharacterBody2D

#Player control variables
@export var ship_right_action = "ship_right1"
@export var ship_left_action := "ship_left1"
@export var ship_down_action := "ship_down1"
@export var ship_up_action := "ship_up1"
@export var fire_bullet_action := "ship_bullet1"
@export var fire_missile_action := "ship_missile1"

#Ship aim and movement
var speed = 2.5
var ship_velocity = Vector2.ZERO
var thrust_vector = Vector2.ZERO
var ship_aim =  Vector2.ZERO
var thrust = 10
var drag = .1

#Ship stats
var bullet_reload_time = 500
var missile_reload_time = 300

# Reload trackers. These are set to the negative value of the load time so that the player can
# shoot them at the start of the game.
var current_bullet_reload = -bullet_reload_time
var current_missile_reload = -missile_reload_time

#Respawn system
var disabled = false
var spawn_point = global_position
var spawn_rotation = 0
var respawn_delay = 3000
var respawn_signal = 0
var invincibility_duration = 1500
var invincibility_timer = 0

#Scene and Object initializations
@onready var game = $"/root/Game Space"
@onready var projectile_spawn = $ProjectileSpawn
@onready var collision_shape = $CollisionShape2D
var bullet = preload("res://Bullet.tscn")
var missile = preload("res://Missile.tscn")

func _ready():
	spawn_point = position
	spawn_rotation = rotation
	ship_aim =  projectile_spawn.global_position - global_position
	ship_aim = ship_aim.normalized()

func _process(delta):
	ship_aim = projectile_spawn.global_position - global_position
	ship_aim = ship_aim.normalized()
	if Input.is_action_pressed(fire_bullet_action) && !disabled:
			_shoot_bullet()
	if Input.is_action_pressed(fire_missile_action) && !disabled:
			_shoot_missile()
	if disabled:
		if Time.get_ticks_msec() >= respawn_signal:
			_ship_respawn()
	
	print(global_position, "|", projectile_spawn.global_position)
func _physics_process(delta):
	if !disabled:
		thrust_vector = Input.get_vector(ship_left_action,ship_right_action,ship_up_action,ship_down_action)
		thrust_vector = thrust_vector.normalized() * speed
		
		if thrust_vector != Vector2.ZERO:
			ship_velocity = ship_velocity.move_toward(thrust_vector*speed, thrust*delta)
		else:
			ship_velocity = ship_velocity.move_toward(Vector2.ZERO, drag*delta)
		
		look_at(global_position + thrust_vector)
		var collision_info = move_and_collide(ship_velocity)
		
		if collision_info:
			if collision_info.get_collider().is_in_group("Walls"):
				ship_velocity = Vector2.ZERO
			else:
				_ship_destroyed()

func _shoot_bullet():
	if Time.get_ticks_msec() > (current_bullet_reload + bullet_reload_time):
		var new_bullet = bullet.instantiate()
		new_bullet.position = projectile_spawn.global_position
		new_bullet.velocity = ship_aim
		game.add_child(new_bullet)
		current_bullet_reload = Time.get_ticks_msec()

func _shoot_missile():
	if Time.get_ticks_msec() > (current_missile_reload + missile_reload_time):
		var new_missile = missile.instantiate()
		new_missile.position = projectile_spawn.global_position
		new_missile.velocity = ship_aim
		new_missile.rotation = global_rotation + PI/2 #Need to rotate them 90 degrees for whatever reason
		game.add_child(new_missile)
		current_missile_reload = Time.get_ticks_msec()

func _ship_destroyed():
	disabled = true
	visible = false
	collision_shape.set_deferred("disabled", true)
	ship_velocity = Vector2.ZERO
	thrust_vector = Vector2.ZERO
	respawn_signal = Time.get_ticks_msec() + respawn_delay
	invincibility_timer = respawn_signal + invincibility_duration

func _ship_respawn():
	visible = true
	disabled = false
	position = spawn_point
	rotation = spawn_rotation
	current_missile_reload = -missile_reload_time
	_respawn_invincibility()

func _respawn_invincibility():
	while (Time.get_ticks_msec() < invincibility_timer):
		await get_tree().create_timer(.100).timeout
		modulate.a = .5
		await get_tree().create_timer(.100).timeout
		modulate.a = 1
	collision_shape.set_deferred("disabled", false)
