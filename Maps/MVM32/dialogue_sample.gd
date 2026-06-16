extends Area2D

@export var dialogueFile: DialogueResource

func _on_body_entered(body: Node2D) -> void:
	print("cocacola sex")
	DialogueManager.show_dialogue_balloon(dialogueFile, "start") # Replace with function body.
