extends Area2D

signal bounds_hit(body)

func _on_player_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"): # is the player hitting the wall
		emit_signal("bounds_hit", body)  # Emit signal with the player refrence
