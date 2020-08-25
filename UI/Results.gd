extends Node
onready var coinsLabel = $coinsLabel
onready var rubberLabel = $rubberLabel
onready var metalLabel = $metalLabel
onready var plasticLabel = $plasticLabel
onready var anim = $tryAgain/AnimationPlayer.get_animation("blinking")
func _ready():
	anim.set_loop(true)
	$tryAgain/AnimationPlayer.play("blinking")
	coinsLabel.set_text(str(global.coins))
	plasticLabel.set_text(str(global.plastic))
	rubberLabel.set_text(str(global.rubber))
	metalLabel.set_text(str(global.metal))
func _physics_process(delta):
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene("res://UI/Menu.tscn")
	if Input.is_action_just_pressed("space"):
		get_tree().change_scene("res://UI/Menu.tscn")