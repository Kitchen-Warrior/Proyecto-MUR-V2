extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash = $dash  # ahora es el nodo con su propio script

# Constantes
const DASH_SPEED = 1200.0
const DASH_LENGTH = 0.1
const NORMAL_SPEED = 135.0
const JUMP_VELOCITY = -265.0

# Variables
var health: int = 5
var jump_count: int = 0


func _physics_process(delta: float) -> void:
	# --- GRAVEDAD (no sobreescribir ataque) ---
	if not is_on_floor():
		velocity += get_gravity() * delta
		if animated_sprite_2d.animation != "atack":
			animated_sprite_2d.play("jump")

	# DASH
	if Input.is_action_just_pressed("dash"):
		dash.start_dash(DASH_LENGTH)
	var speed = DASH_SPEED if dash.is_dashing() else NORMAL_SPEED

	# SALTO
	if Input.is_action_just_pressed("JUMP") and (is_on_floor() or jump_count == 0):
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	if is_on_floor():
		jump_count = 0

	# MOVIMIENTO HORIZONTAL
	var direction := Input.get_axis("IZQUIERDA", "DERECHA")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# --- ANIMACIONES: ataque tiene prioridad ---
	if Input.is_action_just_pressed("atack"):
		print("ataque")
		animated_sprite_2d.play("atack")

	elif animated_sprite_2d.animation == "atack" and animated_sprite_2d.is_playing():
		pass
	else:
		if not is_on_floor():
			animated_sprite_2d.play("jump")
		elif Input.is_action_pressed("DERECHA"):
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run")
		elif Input.is_action_pressed("IZQUIERDA"):
			animated_sprite_2d.flip_h = true
			animated_sprite_2d.play("run")
		else:
			animated_sprite_2d.play("idle")

	# Movimiento + colisiones
	move_and_slide()
	_check_spike_damage()


################### DAÑO ###################

func _check_spike_damage():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "spikes":
			die()

# enemies damages
func enemies_damage():
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs:
		take_damage()

func take_damage() -> void:
	health -= 1
	print("Vida restante: ", health)
	if health <= 0:
		die()

func die() -> void:
	print("¡Game Over!")
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
