extends CharacterBody2D

@onready var player = $"../../Player/player"
@onready var player2 = $"../../Player/player2"
@onready var anim = $AnimatedSprite2D

const SPEED = 100.0
const ATTACK_RANGE := 80.0
const ATTACK_DAMAGE := 10
const ATTACK2_DAMAGE := 20
const ATTACK_COOLDOWN_TIME := 1.5
const ATTACK2_COOLDOWN_TIME := 3.0

var chase = false
var enemyHp := 100
const MAX_HP := 100
var is_hurt := false
var is_attacking := false
var attack_cooldown := 0.0
var attack2_cooldown := 0.0

func _ready():
	add_to_group("enemies")
	anim.play("idle")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if attack_cooldown > 0:
		attack_cooldown -= delta
	if attack2_cooldown > 0:
		attack2_cooldown -= delta

	if is_hurt:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return

	if is_attacking:
		velocity.x = 0
		move_and_slide()
		return

	if chase:
		var target = player
		if player2 and abs(player2.global_position.x - global_position.x) < abs(player.global_position.x - global_position.x):
			target = player2
		var distance = abs(target.global_position.x - global_position.x)

		if distance < ATTACK_RANGE and attack2_cooldown <= 0:
			attack2(target)
		elif distance < ATTACK_RANGE and attack_cooldown <= 0:
			attack(target)
		else:
			var direction_x = sign(target.global_position.x - global_position.x)
			velocity.x = direction_x * SPEED
			anim.play("walk")
			anim.flip_h = direction_x < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("idle")

	move_and_slide()

func attack(target):
	is_attacking = true
	velocity.x = 0
	anim.play("attack")
	anim.flip_h = target.global_position.x < global_position.x
	attack_cooldown = ATTACK_COOLDOWN_TIME
	await get_tree().create_timer(1.0).timeout
	if target and abs(target.global_position.x - global_position.x) < ATTACK_RANGE + 20:
		target.take_damage(ATTACK_DAMAGE)
	is_attacking = false

func attack2(target):
	is_attacking = true
	velocity.x = 0
	anim.play("attack2")
	anim.flip_h = target.global_position.x < global_position.x
	attack2_cooldown = ATTACK2_COOLDOWN_TIME
	await get_tree().create_timer(1.0).timeout
	if target and abs(target.global_position.x - global_position.x) < ATTACK_RANGE + 20:
		target.take_damage(ATTACK2_DAMAGE)
	is_attacking = false

func take_damage(amount: int):
	if is_hurt:
		return
	is_hurt = true
	enemyHp -= amount
	if enemyHp <= 0:
		die()
		return
	anim.play("hurt")
	await get_tree().create_timer(0.5).timeout
	is_hurt = false

func die():
	anim.play("die")
	velocity.x = 0
	set_physics_process(false)
	await get_tree().create_timer(0.5).timeout
	queue_free()

func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "player" or body.name == "player2":
		chase = true

func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "player" or body.name == "player2":
		chase = false
