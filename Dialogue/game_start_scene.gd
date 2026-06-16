extends Area2D

@export var dialogueFile: DialogueResource
@export var dialogueID: String

func _on_body_entered(body: Node2D) -> void:
	print("cocacola sex")
	if MainGame.get_singleton().dialogueSeen.has(dialogueID):
		pass
	else:
		await play_dialog()
		MainGame.get_singleton().playerPath.set_physics_process(true)
		MainGame.get_singleton().startMusic()
		MainGame.get_singleton().hidePlayerEmotion()
	
func play_dialog():
	MainGame.get_singleton().playerPath.set_physics_process(false)
	MainGame.get_singleton().playerPath.velocity = Vector2(0, 0)
	DialogueManager.show_dialogue_balloon(dialogueFile, "start")
	MainGame.get_singleton().dialogueSeen.append(dialogueID)
	await DialogueManager.dialogue_ended
