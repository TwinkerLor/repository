extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var playerHp := 100
const MAX_HP := 100
var attack_cooldown := 0.0
const ATTACK_COOLDOWN_TIME := 0.5
var is_hurt := false
var is_dead := false
var god_mode := false
@onready var sprite = $AnimatedSprite2D
#@onready var hp_bar = %HpBar

func _ready():
	add_to_group("player")
	#if not is_multiplayer_authority():
		#hp_bar.hide()

#func _process(delta):
	#if is_multiplayer_authority():
		#hp_bar.value = playerHp

func _physics_process(delta: float) -> void:
	if attack_cooldown > 0:
		attack_cooldown -= delta
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

	var direction = 0.0
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if Input.is_action_just_pressed("ui_attack") and attack_cooldown <= 0:
			if is_on_floor():
				sprite.play("attack")
			else:
				sprite.play("airAttack")
			attack_cooldown = ATTACK_COOLDOWN_TIME
			deal_damage(15)

	if sprite.animation == "attack" and sprite.is_playing():
		pass
	elif sprite.animation == "airAttack" and sprite.is_playing():
		pass
	elif not is_on_floor() and velocity.y != 0:
		sprite.play("jump")
	elif abs(velocity.x) > 10:
		sprite.play("run")
	else:
		sprite.play("idle")
		
	if abs(velocity.x) > 10:
		sprite.flip_h = velocity.x < 0
		
	if is_multiplayer_authority():
		if Engine.get_physics_frames() % 2 == 0:
			sync_movement.rpc(global_position, velocity, sprite.flip_h)
		
	move_and_slide()
	
@rpc("any_peer", "call_local", "reliable")
	
func take_damage(amount: int):
	if god_mode:
		return
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
	print("Найдено врагов:", enemies.size())
	for enemy in enemies:
		print("Враг:", enemy.global_position, " Игрок:", global_position)
		if abs(enemy.global_position.x - global_position.x) < 100 and abs(enemy.global_position.y - global_position.y) < 80:
			print("Попадание!")
			enemy.take_damage(amount)
			
@rpc("any_peer", "unreliable_ordered", "call_remote")
func sync_movement(new_pos: Vector2, new_vel: Vector2, is_flipped: bool):
	if not is_multiplayer_authority():
		global_position = new_pos
		velocity = new_vel
		$AnimatedSprite2D.flip_h = is_flipped
		
		if abs(velocity.x) > 10:
			$AnimatedSprite2D.play("run")
		elif not is_on_floor():
			$AnimatedSprite2D.play("jump")
		else:
			$AnimatedSprite2D.play("idle")
