
extends "res://addons/MetroidvaniaSystem/Template/Scripts/MetSysGame.gd"
class_name MainGame

@export var DialogPortrait: AnimatedSprite2D
@export var playerPath: PlatformerController2D
@export var startMap: String
@export var interface: CanvasLayer

@export var musicPlayer: AudioStreamPlayer2D
@export var musicAnimationPlayer: AnimationPlayer
@export var endPlayer: AnimationPlayer

const SaveManager = preload("res://addons/MetroidvaniaSystem/Template/Scripts/SaveManager.gd")
const SAVE_PATH = "user://save_data.sav"

# global player variables
var playerDamage: float = 2.0
var playerMaxHP: int = 5
var playerCurrentHP: int = playerMaxHP
var playerMaxAir: float = 3.0
var playerCurrentAir: float = playerMaxAir

var playerIsSwimming: bool = false
var playerDrownDelay: float = 1.0 # after running out of air the player starts losing HP every second

# var dialogueSeen: PackedStringArray = ["Opening1", "Opening2", "Opening3", "Opening4"] # debug
var dialogueSeen: PackedStringArray = []

var obtainedDash: bool = false
var obtainedSlash: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	DialogPortrait.visible = false
	init_player()
	#musicPlayer.play()
	get_script().set_meta(&"singleton", self)
	
	MetSys.reset_state()
	MetSys.set_save_data()

	set_player(playerPath)
	
	# UI STARTS OUT HIDDEN
	interface.visible = false
	
	if FileAccess.file_exists(SAVE_PATH):
		# If save data exists, load it using MetSys SaveManager.
		var save_manager := SaveManager.new()
		save_manager.load_from_text(SAVE_PATH)
		
		# Assign loaded values.
		#collectibles = save_manager.get_value("collectible_count")
		#generated_rooms.assign(save_manager.get_value("generated_rooms"))
		#events.assign(save_manager.get_value("events"))
		#player.abilities.assign(save_manager.get_value("abilities"))
		
		#if not custom_run:
			#var loaded_starting_map: String = save_manager.get_value("current_room")
			#if not loaded_starting_map.is_empty(): # Some compatibility problem.
				#starting_map = loaded_starting_map
	else:
		# If no data exists, set empty one.
		MetSys.set_save_data()
	
	# Initialize room when it changes.
	room_loaded.connect(init_room, CONNECT_DEFERRED)
	# Load the starting room.
	load_room(startMap)
	
	#playerPath.global_position = Vector2(160, 320)
	#playerPath.global_position = Vector2(125, 500)
	#playerPath.global_position = Vector2(1152, 288)
	#playerPath.global_position = Vector2(48, 80)
	add_module("RoomTransitions.gd")

# Returns this node from anywhere.
static func get_singleton() -> MainGame:
	return (MainGame as Script).get_meta(&"singleton") as MainGame

func startMusic():
	musicPlayer.play()
	interface.visible = true
	
func init_player():
	interface._updateHPBar(playerCurrentHP)
	
func updateHP(addition: int) -> void:
	playerCurrentHP = clamp(playerCurrentHP+addition, -1, playerMaxHP)
	interface._updateHPBar(playerCurrentHP)
	
func init_room():
	MetSys.get_current_room_instance().adjust_camera_limits($PlayerController/Camera2D)
	player.on_enter()
	
func endMusic():
	musicAnimationPlayer.play("fadeMusic")

func debugHeal():
	if Input.is_action_pressed("debug"):
		updateHP(9)
	
func playerEmotion(animation):
	DialogPortrait.visible = true
	DialogPortrait.play(animation)
	
func hidePlayerEmotion():
	DialogPortrait.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	debugHeal()
	
func fadeToEndScreen():
	endPlayer.play("end")
	
func _refillDash():
	playerPath.currentCharge = playerPath.dashChargeTime * 2.0
	playerPath.dashCount = 1
	
func _refillWater():
	playerPath.currentWaterCharge = playerPath.waterChargeTime
