extends Path2D

@onready var follow = get_node("PathFollow2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_right"):
		follow.progress += 300 * delta
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_left"):
		follow.progress -= 300 * delta
