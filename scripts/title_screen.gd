extends Control

# Called when the node enters the scene tree for the first time.
#func _ready():
	#Globals.coins = 0 
	#Globals.score = 0
	#Globals.player_life = 3

func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://world.tscn")

func _on_credits_btn_pressed():
	print("test")
	pass

func _on_quit_btn_pressed():
	get_tree().quit()
