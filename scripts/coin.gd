extends Area2D

var coins := 1

@onready var coin_sfx = $coin_sfx as AudioStreamPlayer


func _on_body_entered(body):
	if body.is_in_group("player"):
		$anim.play("collect")
		coin_sfx.play()
		# evita a colisao dupla de moedas, fa
		await $collision.call_deferred("queue_free")
		Global.coins += coins
		Global.score += 100
		

func _on_animated_sprite_2d_animation_finished():
	if $anim.animation == "collect":
		queue_free()
	
