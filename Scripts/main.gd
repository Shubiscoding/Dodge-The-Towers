extends Node2D

@onready var towers: Node2D = $Towers
@onready var timer: Timer = $Timer
@onready var bird: CharacterBody2D = $Bird
@onready var restart: CanvasLayer = $Restart
@onready var overlay: CanvasLayer = $Restart/Overlay

var count: int = 0
const MAX_TOWER_COUNT: int = 3
const TOWER_SPEED: int = 250
const BIRD_START_POSITION: Vector2 = Vector2(97.0, 344.725)
const BACKGROUND_START_POSITION: int = 1435
var score = 0
var can_play: bool = true
var game_start: bool = false

#-------------------------------
# MAIN FUNCTION
#-------------------------------

func _ready() -> void:
	timer.stop()
	bird.is_alive = false


func _process(delta: float) -> void:
	if game_start:
		if !can_play:
			bird.is_alive = false
			timer.stop()
			restart.show()
			overlay.show()
			
			if Input.is_action_just_pressed("Continue"):
				can_play = true
				restart.hide()
				overlay.hide()
				
				# Rest score
				score = 0
				$HUD/ScorePanel/ScoreLabel.text = "SCORE:%s" % score
				
				# Rest bird position
				bird.position = BIRD_START_POSITION
				bird.is_alive = true
				$Bird/AnimatedSprite2D.play()
				$Bird/AudioStreamPlayer2D.play()
				bird.velocity = Vector2(0, 0)
				
				# Remove exisiting towers
				if towers:
					for child in towers.get_children():
						child.queue_free() 
				
				# Reset Timer
				timer.start()
			return 
			
		_update_tower(delta)
		_move_background(delta, $TextureRect)
		_move_background(delta, $TextureRect2)
		_check_if_bird_hit_ground()
		return 
	
	# if game has not started yet
	if Input.is_action_just_pressed("Continue"):
		timer.start()
		game_start = true
		bird.is_alive = true
		bird.show()
		$Bird/AnimatedSprite2D.play()
		$Bird/AudioStreamPlayer2D.play()
		$MenuThings.get_child(0).queue_free()
		$HUD.show()
	_move_background(delta, $TextureRect)
	_move_background(delta, $TextureRect2)
		
#-------------------------------
# TOWER FUNCTIONS
#-------------------------------

func _on_timer_timeout() -> void:
	var tower_preload = preload("res://Scenes/tower.tscn")
	var TowerInstance = tower_preload.instantiate()
	TowerInstance.position.x = 630
	TowerInstance.position.y = randi_range(100, 350)
	TowerInstance.bird_died.connect(_check_if_bird_dead)
	TowerInstance.scored.connect(_check_if_scored_increased)
	
	if count <= MAX_TOWER_COUNT: 
		towers.add_child(TowerInstance)
		count = len(towers.get_children())
		timer.start()

		
func _update_tower(delta: float) -> void:
	if towers:
		for tower_child in towers.get_children():
			if tower_child.position.x < -60:
				tower_child.queue_free()
				
			tower_child.position.x -= TOWER_SPEED * delta


#-------------------------------
# BIRD FUNCTIONS
#-------------------------------

func _check_if_bird_dead() -> void:
	$Bird/AnimatedSprite2D.stop()
	$Bird/Dead.play()
	can_play = false
	

func _check_if_bird_hit_ground() -> void:
	if bird.position.y > 760:
		can_play = false 
		$Bird/Dead.play()
		
#-------------------------------
# HUD FUNCTIONS
#-------------------------------

func _move_background(delta: float, body: TextureRect) ->void:
	if body.position.x < -BACKGROUND_START_POSITION:
		body.position.x = BACKGROUND_START_POSITION
			
	body.position.x -= 50 * delta
	
	
func _check_if_scored_increased() ->void:
	score += 1
	$HUD/ScorePanel/ScoreLabel.text = "SCORE:%s" % score
	
	
#func _menu_load() -> void:
	#if !$MenuThings:
		#var menu_preload = preload("res://Scenes/menu.tscn")
		#var MenuInstance = menu_preload.instantiate()
		#MenuInstance.position.x = 305.0
		#MenuInstance.position.y = 233.0
		#$MenuThings.add_child(MenuInstance)
	
	
