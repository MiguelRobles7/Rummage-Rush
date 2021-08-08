extends Node
onready var audio = $AudioStreamPlayer
onready var anim = $Button/AnimationPlayer.get_animation("New Anim")
func _ready():
	audio.play()
	anim.set_loop(true)
	$Button/AnimationPlayer.play("New Anim")
	
