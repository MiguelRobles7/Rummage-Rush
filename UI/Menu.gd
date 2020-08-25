extends Node
onready var buttonSound = $button
onready var anim = $StartGame/AnimationPlayer.get_animation("blinking")
signal playButton# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.set_loop(true)
	$StartGame/AnimationPlayer.play("blinking")

func _on_ColorRect_animFinish():
	get_tree().change_scene("res://UI/PlayerSelection.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://UI/PlayerSelection.tscn")


func _on_StartGame_playButton():
	buttonSound.play()
