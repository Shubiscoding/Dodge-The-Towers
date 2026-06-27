extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

signal bird_died
signal scored

func _on_body_entered(body: Node2D) -> void:
	emit_signal("bird_died")


func _on_score_area_body_entered(body: Node2D) -> void:
	audio_stream_player_2d.play()
	emit_signal("scored")
	
