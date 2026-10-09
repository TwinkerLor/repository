extends CharacterBody2D

@onready var player = $Player/player
@onready var player2 = $Player/player2
const SPEED = 100.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var chase = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction_x = sign(player.position.x - position.x)
	if chase == true:	
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.name == "player2":
		chase = true	


func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player" or body.name == "player2":
		chase = false
