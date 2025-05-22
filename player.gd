extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $anim
@onready var hitbox_collision: CollisionShape2D = $hitbox/collision
@onready var hitbox: Area2D = $hitbox
@onready var collision: CollisionPolygon2D = $collision
@onready var moeda = preload("res://coin.tscn")
@onready var destroy_sfx = preload("res://sounds/destroy_sfx.tscn")
@onready var fsm: Node = $fsm
@onready var camera: Camera2D = $camera
@onready var shoot_cooldown: Timer = $shoot_cooldown

const BULLET_SCENE = preload("res://prefabs/bullet.tscn")
@onready var bullet_position: Marker2D = $bullet_position

const SPEED = 160
const JUMP_VELOCITY = -280
const AIR_FRICTION := 0.95

var is_attacking = false
var points = 00000
var player_health = 100
var toma_pau = 100   # damage

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_pressed('shoot') and shoot_cooldown.is_stopped():
		shoot_bullet()




#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		#anim.play('jump')
		#
		#
	## Attack
	#elif Input.is_action_just_pressed("attack") and not is_attacking:
		#is_attacking = true
		#hitbox_collision.set_deferred('disabled', false)
		#
		#velocity.x = 0  # Stop horizontal movement
		#anim.play('attack_1')
		#await anim.animation_finished
		#
		#is_attacking = false
		#hitbox_collision.set_deferred('disabled', true)
	#
	#elif not is_attacking:
		## Get the input direction and handle the movement/deceleration.
		#var direction := Input.get_axis("ui_left", "ui_right")
		#velocity.x = direction * SPEED
		#
		#if not is_on_floor():
			## Keep jump animation playing while in air
			#if anim.animation != 'jump':
				#anim.play('jump')
		#else:
			#if direction > 0:
				#collision.scale.x = direction
				#hitbox.scale.x = direction
				#anim.flip_h = false
				#anim.play('walking')
			#elif direction < 0:
				#collision.scale.x = direction
				#hitbox.scale.x = direction
				#anim.flip_h = true
				#anim.play('walking')
			#else:
				#velocity.x = move_toward(velocity.x, 0, SPEED)
				#anim.play('idle')

	move_and_slide()
	
	if Input.is_action_pressed('ui_left'):
		if sign(bullet_position.position.x) == 1:
			bullet_position.position.x *= -1
	
	if Input.is_action_pressed('ui_right'):
		if sign(bullet_position.position.x) == -1:
			bullet_position.position.x *= -1
	
func move_player():
	var direction = Input.get_axis('ui_left', 'ui_right')
	
	# playstation controller
	if direction < 0: direction = floor(direction)  
	else: direction = ceil(direction)
		
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if direction != 0:
		anim.scale.x = direction * 1.5 #(pq o anim foi tem 1.5 de scale )
		hitbox.scale.x = direction
		# fsm.scale.x = direction so se recoverter para Node2D (existe o 'change type')



# função take damage para vc fazer
func take_damage():
	camera.apply_shake(30)
	
	var knockback_vector := Vector2.ZERO
	knockback_vector = Vector2(-100, -100)
	if knockback_vector != Vector2.ZERO:
			velocity = knockback_vector 

	# para vc descomentar qnd criar o Globals
	#if Globals.player_health <= 0:
		#fsm.force_change_state('die')



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("collectable"):
		body.queue_free()
		points += 1
		
	if body.is_in_group("block"):
		var new_coin = moeda
		new_coin.instantiate()
		

# Breaking box - normal box hit and box destruction
func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.break_sprite()
			play_destroy_sfx()
		else:
			body.animation_player.play("hit")
			body.hit_block_sfx.play()
			body.create_coin()

# Break box sound
func play_destroy_sfx():
	var sound_sfx = destroy_sfx.instantiate()
	get_parent().add_child(sound_sfx)
	sound_sfx.play()
	await sound_sfx.finished
	sound_sfx.queue_free()
		


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.collision_layer == 5:
		print("saporra funcionou")
		anim.play("hurt")
		player_health = player_health - toma_pau
		take_damage()
		
		if player_health <= 0:
			anim.play("death")
			await anim.animation_finished
			queue_free()
			
func shoot_bullet():
	var bullet_instance = BULLET_SCENE.instantiate()
	
	if sign(bullet_position.position.x) == 1:
		bullet_instance.set_direction(1)
	else:
		bullet_instance.set_direction(-1)
	
	# the same as get_parent().add_child(bullet_instance)
	add_sibling(bullet_instance)
	
	bullet_instance.global_position = bullet_position.global_position
	shoot_cooldown.start()
