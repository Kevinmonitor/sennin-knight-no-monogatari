extends Area2D

@export var dialogueFile: DialogueResource
@export var dialogueID: String

func _on_body_entered(body: Node2D) -> void:
	print("cocacola sex")
	if MainGame.get_singleton().dialogueSeen.has(dialogueID):
		pass
	else:
		# TRANSPORT USER TO THE SEX ZONE
		# PLAY EFFECT
		# CHANGE ROOMOpening2.tscn
		await play_pre_dialog()
		MainGame.get_singleton().load_room("Room1.tscn")
		MainGame.get_singleton().room_loaded.connect(move_to_start_room, CONNECT_ONE_SHOT)
		MainGame.get_singleton().playerPath.startGame = true
		MainGame.get_singleton().playerPath.set_physics_process(true)
		MainGame.get_singleton().hidePlayerEmotion()
		# SPAWN PLAYER IN NEW POSITION
	
func play_pre_dialog():
	MainGame.get_singleton().playerPath.set_physics_process(false)
	MainGame.get_singleton().playerPath.velocity = Vector2(0, 0)
	DialogueManager.show_dialogue_balloon(dialogueFile, "start")
	MainGame.get_singleton().dialogueSeen.append(dialogueID)
	await DialogueManager.dialogue_ended

func move_to_start_room():
	MainGame.get_singleton().playerPath.position = Vector2(120, 80)
