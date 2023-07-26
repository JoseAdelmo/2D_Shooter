extends KinematicBody2D

const movespeed = 400
var bullet_speed = 2600
export var fire_rate = 0.2

var bullet = preload("res://Bullet.tscn")
var can_fire = true

func _physics_process(delta: float) -> void:
	# Movimento com as teclas do teclado
	var motion = Vector2()
	if Input.is_action_pressed("up"):
		motion.y -= 1
	if Input.is_action_pressed("down"):
		motion.y += 1
	if Input.is_action_pressed("left"):
		motion.x -= 1
	if Input.is_action_pressed("right"):
		motion.x += 1
		
	# Obter a posição do mouse na tela
	var mouse_position = get_global_mouse_position()
	
	# Calcular a direção do jogador em relação à posição do mouse
	var look_dir = (mouse_position - global_position).normalized()
	
	# Apontar o jogador na direção do mouse
	look_at(global_position + look_dir)

	if Input.is_action_pressed("fire") and can_fire:
		var bullet_instance = bullet.instance()
		bullet_instance.position = global_position
		bullet_instance.rotation_degrees = rotation_degrees
		bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed, 0).rotated(rotation))
		get_tree().get_root().add_child(bullet_instance)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
		
	# Movimentar o jogador na direção do mouse
	motion = look_dir * movespeed
	move_and_slide(motion)
	
func kill():
	get_tree().reload_current_scene()
	


func _on_Area2D_body_entered(body):
	if "Enemey" in body.name:
		kill()
