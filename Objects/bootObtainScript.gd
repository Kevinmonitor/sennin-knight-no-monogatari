extends Area2D

@export var dialogueFile: DialogueResource
@export var dialogueID: String
@export var sprite: Sprite2D

func _ready() -> void:
	if MainGame.get_singleton().obtainedDash:
		queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	print("cocacola boots with the fur")
	if MainGame.get_singleton().obtainedDash:
		queue_free()
		MainGame.get_singleton().obtainedDash = true
		MainGame.get_singleton().playerPath._gainDash()
	else:
		sprite.visible = false
		# OBTAIN ITEM
		await play_pre_dialog()
		MainGame.get_singleton().hidePlayerEmotion()
		MainGame.get_singleton().playerPath.set_physics_process(true)
		MainGame.get_singleton().obtainedDash = true
		MainGame.get_singleton().playerPath._gainDash()
		queue_free()
	
func play_pre_dialog():
	MainGame.get_singleton().playerPath.set_physics_process(false)
	MainGame.get_singleton().playerPath.velocity = Vector2(0, 0)
	DialogueManager.show_dialogue_balloon(dialogueFile, "start")
	MainGame.get_singleton().dialogueSeen.append(dialogueID)
	await DialogueManager.dialogue_ended
