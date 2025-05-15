extends State

@export var player : CharacterBody2D
@onready var anim: AnimatedSprite2D = $"../../anim"
@onready var hitbox = $"../../hitbox/collision"

func Enter():
	hitbox.set_deferred('disabled', false)
	player.velocity.x = 0  # Stop horizontal movement
	anim.play('attack_1')

func Exit():
	hitbox.set_deferred('disabled', true)

func Update(_delta:float):
	await anim.animation_finished
	if Input.get_axis('ui_left', 'ui_right') != 0:
		Transitioned.emit(self, 'run')
	else:
		Transitioned.emit(self, 'idle')

func Physics_Update(_delta):
	pass
	
	
