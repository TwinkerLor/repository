extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var playerHp := 100
const MAX_HP := 100
var attack_cooldown := 0.0
const ATTACK_COOLDOWN_TIME := 0.5
@onready var sprite = $AnimatedSprite2D
@onready var hp_bar = $"../../HUD/HpBar"

func _process(delta):
	hp_bar.value = playerHp

func _physics_process(delta: float) -> void:
	if attack_cooldown > 0:
		attack_cooldown -= delta
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("ui_attack") and attack_cooldown <= 0:
		sprite.play("attack")
		attack_cooldown = ATTACK_COOLDOWN_TIME
	elif Input.is_action_just_pressed("ui_attack2") and attack_cooldown <= 0:
		sprite.play("attack2")
		attack_cooldown = ATTACK_COOLDOWN_TIME
	elif sprite.animation == "attack" and sprite.is_playing():
		pass
	elif sprite.animation == "attack2" and sprite.is_playing():
		pass
	elif not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("run")
	else:
		sprite.play("idle")

	if direction != 0:
		sprite.flip_h = direction < 0

	move_and_slide()
