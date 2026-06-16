extends CharacterBody2D

class_name ObjectBitch

@export var moveSpeed = 60
@export var idleSpeed = 60
@export var enemyHitbox: Area2D
@export var enemyHurtbox: Area2D
@export var enemyDetection: Area2D

@export var animator: AnimatedSprite2D
@export var shaderAnimator: AnimationPlayer
@export var explodeSound: AudioStreamPlayer2D

@export var horizontalMovement: bool = true
@export var verticalMovement: bool = true

@export var enemyHP: float = 10.0

var direction : Vector2 = Vector2.RIGHT

var isDamaged: bool = false
var isScrewed: bool = false

var maxDamageTimer: float = 1.5

var isChasingPlayer: bool = false

var player: PlatformerController2D = MainGame.get_singleton().playerPath
var knockback = Vector2.ZERO

func _ready() -> void:
	player = MainGame.get_singleton().playerPath
	
func _process(delta: float) -> void:
	
	_damageFlashHandling()
	
	#if direction.x == 1:
		#animator.scale.x = -1
	#else:
		#animator.scale.x = 1
	
	if enemyHP > 0:
		if isDamaged:
			animator.play("enemyHurt")
		elif !player:
			animator.play("enemyMove")
		else:
			animator.play("enemyMoveAngry")
	
func _physics_process(delta: float) -> void:
	direction.y = 0
	_moveEnemy(delta)
	_hitboxHandling()
	
func _hitboxHandling():
	if isDamaged:
		enemyHitbox.set_deferred("monitoring", false)
		enemyHitbox.set_deferred("monitorable", false)
	else:
		enemyHitbox.monitoring = true
		enemyHitbox.monitorable = true
	pass

func _moveEnemy(delta):
	
	if velocity.x > 0:
		animator.flip_h = true
	else:
		animator.flip_h = false
		
	if enemyHP > 0:
		if !isChasingPlayer:
			velocity.x = direction.x * idleSpeed * delta
		else:
			_chasePlayer()
			
		move_and_slide()
		
func _chasePlayer():
	if !isDamaged:
		velocity = position.direction_to(player.position) * moveSpeed
	else:
		velocity = knockback * moveSpeed
		knockback = knockback.lerp(Vector2.ZERO, 0.1)
		# sex
	
func _on_hurtbox_area_body_entered(body: Node2D) -> void:
	print("collided")
	if body is TileMap or body is TileMapLayer:
		print("collided with tilemap")
		direction.x *= -1
	elif body is PlatformerController2D and !isDamaged:
		print("collided with player")
		body.hit_by_spike = false
		var direction = player.global_position.direction_to(global_position)
		var explosion_force = -1 * direction * 10
		knockback = explosion_force
		body._owFuck(knockback)

func _enemyDie():
	scale = Vector2(2.0, 2.0)
	animator.play("enemyExplode")
	
	enemyHitbox.set_deferred("monitoring", false)
	enemyHitbox.set_deferred("monitorable", false)
	
	enemyHurtbox.set_deferred("monitoring", false)
	enemyHurtbox.set_deferred("monitorable", false)
	
	MainGame.get_singleton().updateHP(1)
	
	explodeSound.play()
	await animator.animation_finished
	queue_free()
	
func _takeDamage():
	
	isDamaged = true
	
	if enemyHP > 0 && isScrewed == false:
		var direction = global_position.direction_to(player.global_position)
		var explosion_force = -1 * direction * 10
		knockback = explosion_force
	
	enemyHP -= MainGame.get_singleton().playerDamage
	
	if enemyHP <= 0:
		isScrewed = true
		_enemyDie()
	await get_tree().create_timer(maxDamageTimer * 1.01).timeout
	isDamaged = false
		
func _damageFlashHandling():
	if isDamaged && enemyHP > 0:
		animator.play("enemyHurt")
		shaderAnimator.play("takeDamage")
	else:
		shaderAnimator.stop()
		animator.material.set_shader_parameter("flash_value", 0.0)

func _on_hitbox_area_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(7) == true:
		_takeDamage()

func _on_detection_body_entered(body: Node2D) -> void:
	isChasingPlayer = true
