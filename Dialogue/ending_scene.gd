# the end!
extends Area2D

@export var dialogueFile: DialogueResource
@export var dialogueID: String

func _on_body_entered(body: Node2D) -> void:
	print("cocacola sex")
	if MainGame.get_singleton().dialogueSeen.has(dialogueID):
		pass
	else:
		await play_dialog()
		# ENDING STUFF HERE!
		MainGame.get_singleton().hidePlayerEmotion()
		MainGame.get_singleton().fadeToEndScreen()
	
func play_dialog():
	MainGame.get_singleton().playerPath.set_physics_process(false)
	MainGame.get_singleton().playerPath.velocity = Vector2(0, 0)
	DialogueManager.show_dialogue_balloon(dialogueFile, "start")
	MainGame.get_singleton().dialogueSeen.append(dialogueID)
	await DialogueManager.dialogue_ended
