extends Area2D

signal crystal_collected(body) # signal - crystal colleced for game

func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.is_in_group("Player"):
		body.set_position($DestinationPoint.global_position)
