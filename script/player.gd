extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true

var attack_ip = false

var health_style = StyleBoxFlat.new()


const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$health_bar.add_theme_stylebox_override("fill", health_style)


func _physics_process(delta: float) -> void:
	player_movement(delta)
	enemy_attack()
	attack ()
	current_camera()
	update_health()
	
	if health <= 0 and player_alive:
		die()
	
func die():
	player_alive = false
	health = 0
	set_physics_process(false)
	$regen_cd.stop()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.6)
	await tween.finished
	var screen = preload("res://scene/game_over.tscn").instantiate()
	get_tree().current_scene.add_child(screen)

func player_movement(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		velocity.x = speed
	if Input.is_action_pressed("ui_left"):
		current_dir = "left"
		velocity.x = -speed
	if Input.is_action_pressed("ui_down"):
		current_dir = "down"
		velocity.y = speed
	if Input.is_action_pressed("ui_up"):
		current_dir = "up"
		velocity.y = -speed
		
	if velocity != Vector2.ZERO:
		play_anim(1)
	else:
		play_anim(0)
	
	velocity = velocity.normalized() * speed
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play ("side_walk")
		elif  movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
			
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play ("side_walk")
		elif  movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
			
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play ("front_walk")
		elif  movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
			
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play ("back_walk")
		elif  movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

func player ():
	pass

func _on_player_htibox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true


func _on_player_htibox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false


func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		global.show_popup("-20", global_position + Vector2(-8, -30), Color.RED)
		$regen_cd.start()
		enemy_attack_cooldown = false
		$attack_cooldown.start ()
		print (health)


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true


func attack ():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play ("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play ("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play ("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play ("back_attack")
			$deal_attack_timer.start()

func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop ()
	global.player_current_attack = false
	attack_ip = false

func current_camera ():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
		
	elif global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true

func update_health():
	var healthbar = $health_bar
	
	healthbar.value = health
	health_style.bg_color = Color.from_hsv(health / 100.0 * 0.33 , 1.0, 1.0)
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true
	

func _on_regen_cd_timeout() -> void:
	if health < 100 and health > 0:
		var healed = min(20, 100 - health)
		health += healed
		global.show_popup("+" + str(healed), global_position + Vector2(-8, -30), Color.GREEN)
