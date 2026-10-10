extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var playerHp := 100
const MAX_HP := 100

var attack_cooldown := 0.0
var attack2_cooldown := 0.0
const ATTACK_COOLDOWN_TIME := 0.5
const ATTACK2_COOLDOWN_TIME := 1.5
const ATTACK_DAMAGE := 10
const ATTACK2_DAMAGE := 25
var is_hurt := false
var is_dead := false

@onready var sprite = $AnimatedSprite2D
@onready var hp_bar = $"../../HUD/HpBar"

func _process(delta):
	hp_bar.value = playerHp

func _physics_process(delta: float) -> void:
	if attack_cooldown > 0:
		attack_cooldown -= delta
	if attack2_cooldown > 0:
		attack2_cooldown -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_hurt:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		return
		
	if is_dead:
		velocity.x = 0
		move_and_slide()
		return

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("ui_attack") and attack_cooldown <= 0 and is_on_floor():
		sprite.play("attack")
		attack_cooldown = ATTACK_COOLDOWN_TIME
		deal_damage(ATTACK_DAMAGE)
	elif Input.is_action_just_pressed("ui_attack2") and attack2_cooldown <= 0:
		sprite.play("attack2")
		attack2_cooldown = ATTACK2_COOLDOWN_TIME
		deal_damage(ATTACK2_DAMAGE)
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
	
func take_damage(amount: int):
	if is_hurt or is_dead:
		return
	is_hurt = true
	playerHp -= amount
	if playerHp <= 0:
		die()
		return
	sprite.play("hurt")
	await get_tree().create_timer(0.5).timeout
	is_hurt = false
	
func die():
	is_dead = true
	sprite.play("death")
	velocity.x = 0
	set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	#get_tree().reload_current_scene()

func deal_damage(amount: int):
	await get_tree().create_timer(0.2).timeout
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if abs(enemy.global_position.x - global_position.x) < 100 and abs(enemy.global_position.y - global_position.y) < 80:
			enemy.take_damage(amount)
