extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const GRAVITY = 981
const JUMP_VELOCITY = -350.0
var is_alive = true
func _physics_process(delta: float) -> void:
	if !is_alive:
		animated_sprite_2d.stop()
		audio_stream_player_2d.stop()
		return
	
	velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("Jump"):
		velocity.y = JUMP_VELOCITY
	
	move_and_slide()
