extends Area2D


func _on_body_entered(body: Node2D) -> void:
	MainGame.get_singleton().endMusic()
	queue_free() # Replace with function body.
