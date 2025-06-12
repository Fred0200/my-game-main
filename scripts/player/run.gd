extends State

@onready var anim: AnimatedSprite2D = $"../../anim"
@export var player : CharacterBody2D

func Enter():
	anim.play('run')

func Exit():
	pass

func Update(_delta:float):
	if Input.is_action_just_pressed("attack"):
		Transitioned.emit(self, 'attack')
	elif Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		Transitioned.emit(self, 'jump')	
	elif not Input.get_axis('ui_left', 'ui_right'):
		Transitioned.emit(self, 'idle')

func Physics_Update(_delta):
	player.move_player()
	print(Global.coins)
