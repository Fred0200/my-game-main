extends State

@onready var anim: AnimatedSprite2D = $"../../anim"
@export var player : CharacterBody2D

func Enter():
	anim.play('idle')
	player.velocity.x = 0

func Exit():
	pass

func Update(_delta:float):
	if Input.get_axis('ui_left', 'ui_right'):
		Transitioned.emit(self, 'run')
	elif Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		Transitioned.emit(self, 'jump')
	elif Input.is_action_just_pressed('attack'):
		Transitioned.emit(self, 'attack')	
