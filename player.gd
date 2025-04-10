extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $anim
@onready var hitbox_collision: CollisionShape2D = $hitbox/collision
@onready var hitbox: Area2D = $hitbox
@onready var collision: CollisionPolygon2D = $collision
@onready var moeda = preload("res://coin.tscn")
@onready var destroy_sfx = preload("res://sounds/destroy_sfx.tscn")

const SPEED = 160
const JUMP_VELOCITY = -280

var is_attacking = false
var points = 00000
var player_health = 100
var toma_pau = 100   # damage

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	# FIXME: saporra n esta saltando, 
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play('jump')
		
		
	# Attack
	elif Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		hitbox_collision.set_deferred('disabled', false)
		
		velocity.x = 0  # Stop horizontal movement
		anim.play('attack_1')
		await anim.animation_finished
		
		is_attacking = false
		hitbox_collision.set_deferred('disabled', true)
	
	elif not is_attacking:
		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * SPEED
		if direction > 0:
			collision.scale.x = direction
			hitbox.scale.x = direction
			anim.flip_h = false
			anim.play('walking')
		elif direction < 0:
			collision.scale.x = direction
			hitbox.scale.x = direction
			anim.flip_h = true
			anim.play('walking')
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play('idle')

	move_and_slide()
	






# função take damage para vc fazer
func take_damage():
	var knockback_vector := Vector2.ZERO
	knockback_vector = Vector2(-100, -100)
	if knockback_vector != Vector2.ZERO:
			velocity = knockback_vector 



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



#eu não quero trabalhar hoje 
#I don´t want to work today
#je ne querer pas trabalhar hoje
