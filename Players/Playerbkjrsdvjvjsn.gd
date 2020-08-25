extends KinematicBody
signal p1trashCount
signal pickUpWait
signal p1trashSegregated
signal metalStored
signal metalContPickUp
signal plusOneMetal
signal updateScore
signal metalContainerReturn
signal trashPickedUp
signal rubberStored
signal rubberContPickUp
signal plusOneRubber
signal rubberContainerReturn
signal plasticStored
signal plasticContPickUp
signal plusOnePlastic
signal plasticContainerReturn
signal hazardSpawn
signal minusScore
signal canMove
signal metalContRecycled
signal plasticContRecycled
signal rubberContRecycled
var gravity = Vector3.DOWN * 12
var speed = 3
var isHoldingTrash = false
var velocity = Vector3()
var itemLimit
var trashLimit = 0
var timeCanGrab = true
var p1segregateTrash
var isMoving = false
var p1CanSeg = true
var grabbingSeg = false
var segLimit = 0
var onHandMetal = 0
var canPickUpMetal = false
var metalContainerInteract = false
var isHoldingMetalCont = false
var inMetalRecycle = false
var metalSlowDebuff = 0
var onHandRubber = 0
var canPickUpRubber = false
var rubberContainerInteract = false
var isHoldingRubberCont = false
var inRubberRecycle = false
var rubberSlowDebuff = 0
var onHandPlastic = 0
var canPickUpPlastic = false
var plasticContainerInteract = false
var isHoldingPlasticCont = false
var inPlasticRecycle = false
var plasticSlowDebuff = 0
var segCounterLimit = 0
var rng = RandomNumberGenerator.new()
var canDump = false
var canMove = true
onready var player = get_node(".")
onready var detector = $PickUp
var hazardChanceofDrop = 0
var rubberSegSpeedDec = 0
var plasticSegSpeedDec = 0
var metalSegSpeedDec = 0
var currentSpeed = speed
var spriteContMetal = preload("res://UI Sprites/conmeticon.png")
var spriteContRubber = preload("res://UI Sprites/conrubicon.png")
var spriteContPlastic = preload("res://UI Sprites/conplasicon.png")
var trashCount = 0
onready var spriteTrash = $P1/trashSprite
onready var trashCountLabel = $P1/trashCount
onready var x = $P1/x
onready var playerStatus = $P1/singleSprite
onready var segPlasticLabel = $P1/segLabels/segPlastic
onready var segRubberLabel = $P1/segLabels/segRubber
onready var segMetalLabel = $P1/segLabels/segMetal
onready var segLabels = $P1/segLabels
onready var segImages = $P1/threeicons
onready var metalHold = $MetalHold
onready var plasticHold = $PlasticHold
onready var rubberHold = $RubberHold
onready var garbageHold = $GarbageHold
onready var segHold = $segHold
func _ready():
	itemLimit = false
	p1segregateTrash = false
func p1weightDebuff(type):
	speed = 3
	speed -= (.2*type)
func _physics_process(delta): 
	#Player Pick Up Trash
	var item = detector.get_collider()
	if detector.is_colliding() and item.has_method("Grab") and timeCanGrab == true and grabbingSeg == false and trashLimit != 3:
		if Input.is_action_just_pressed("space"):
			trashLimit += 1
			trashCountLabel.set_text(str(trashLimit))
			item.Grab()
			timeCanGrab = false
			p1CanSeg = false
			isHoldingTrash = true
			emit_signal("pickUpWait")
			emit_signal("p1trashCount")
			p1weightDebuff(trashLimit)
			hazardChanceofDrop += 5
			print("Trash on hand:", trashLimit)
			emit_signal("trashPickedUp")
	#detects segregated metal
	if detector.is_colliding() and item.has_method("metalSeg") and p1CanSeg == true and segLimit != 10:
		if Input.is_action_just_pressed("space"):
			segCounterLimit -= 1
			segImages.show()
			segLabels.show()
			grabbingSeg = true
			segLimit += 1
			item.metalSeg()
			metalSlowDebuff += 1
			metalSegSpeedDec += (speed*metalSlowDebuff) 
			emit_signal("plusOneMetal")
			p1weightDebuff(segLimit)
			segMetalLabel.set_text(str(onHandMetal))
			print("Segregated Trash on Hand:",segLimit, "\nSegregated Metal:" , onHandMetal)
	if detector.is_colliding() and item.has_method("rubberSeg") and p1CanSeg == true and segLimit != 10:
		if Input.is_action_just_pressed("space"):
			segCounterLimit -= 1
			segImages.show()
			segLabels.show()
			grabbingSeg = true
			segLimit += 1
			item.rubberSeg()
			rubberSlowDebuff += 1
			rubberSegSpeedDec += (speed*rubberSlowDebuff) 
			emit_signal("plusOneRubber")
			p1weightDebuff(segLimit)
			segRubberLabel.set_text(str(onHandRubber))
			print("Segregated Trash on Hand:",segLimit, "\nSegregated Rubber:" , onHandRubber)
	if detector.is_colliding() and item.has_method("plasticSeg") and p1CanSeg == true and segLimit != 10:
		if Input.is_action_just_pressed("space"):
			segCounterLimit -= 1
			segImages.show()
			segLabels.show()
			grabbingSeg = true
			segLimit += 1
			item.plasticSeg()
			plasticSlowDebuff += 1
			plasticSegSpeedDec += (speed*plasticSlowDebuff) 
			emit_signal("plusOnePlastic")
			p1weightDebuff(segLimit)
			segPlasticLabel.set_text(str(onHandPlastic))
			print("Segregated Trash on Hand:",segLimit, "\nSegregated Plastic:" , onHandPlastic)
	#metal recycling
	if metalContainerInteract == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("space"):
			#stores metal in container
			if onHandMetal > 0 and onHandMetal < 11 and canPickUpMetal == false: 
				segLimit -= onHandMetal
				onHandMetal = 0
				segMetalLabel.set_text(str(onHandMetal))
				metalSlowDebuff = 0
				p1weightDebuff(segLimit)
				emit_signal("metalStored")
				grabbingSeg = false
				print("Stored Metal in Container\n", speed)
			elif onHandMetal > 10 and canPickUpMetal == false:
				print("too many metals")
			elif canPickUpMetal == true and segLimit <= 0:
				playerStatus.set_texture(spriteContMetal)
				metalHold.show()
				emit_signal("metalContPickUp")
				canPickUpMetal = false
				print("Picked Up Metal Container")
				isHoldingMetalCont = true
				p1weightDebuff(12)
	#rubber
	if rubberContainerInteract == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("space"):
			#stores rubber in container
			if onHandRubber > 0  and onHandRubber < 11 and canPickUpRubber == false: #and onHandMetal < 11
				segLimit -= onHandRubber
				onHandRubber = 0
				segRubberLabel.set_text(str(onHandRubber))
				rubberSlowDebuff = 0
				p1weightDebuff(segLimit)
				emit_signal("rubberStored")
				grabbingSeg = false
				print("Stored Rubber in Container\n" , speed)
			elif onHandRubber > 10 and canPickUpRubber == false:
				print("too many metals")
			elif canPickUpRubber == true and segLimit <= 0:
				playerStatus.set_texture(spriteContRubber)
				rubberHold.show()
				emit_signal("rubberContPickUp")
				canPickUpRubber = false
				print("Picked Up Rubber Container")
				isHoldingRubberCont = true
				p1weightDebuff(12)
	#plastic
	if plasticContainerInteract == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("space"):
			#stores rubber in container
			if onHandPlastic > 0  and onHandPlastic < 11 and canPickUpPlastic == false: #and onHandMetal < 11
				segLimit -= onHandPlastic
				onHandPlastic = 0
				segPlasticLabel.set_text(str(onHandPlastic))
				plasticSlowDebuff = 0
				p1weightDebuff(segLimit)
				emit_signal("plasticStored")
				grabbingSeg = false
				print("Stored Plastic in Container\n", speed)
			elif onHandPlastic > 10 and canPickUpPlastic == false:
				print("too many metals")
			elif canPickUpPlastic == true and segLimit <= 0:
				playerStatus.set_texture(spriteContPlastic)
				plasticHold.show()
				emit_signal("plasticContPickUp")
				canPickUpPlastic = false
				print("Picked Up Plastic Container")
				isHoldingPlasticCont = true
				p1weightDebuff(12)
	#if holding metal cont and near metal recyler, puts container in recycler and gives points
	if inMetalRecycle == true and isHoldingMetalCont == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("space"):
			emit_signal("metalContainerReturn")
			emit_signal("metalContRecycled")
			emit_signal("updateScore")
			playerStatus.set_texture(null)
			speed = 3
			metalHold.hide()
	if inRubberRecycle == true and isHoldingRubberCont == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("space"):
			emit_signal("rubberContainerReturn")
			emit_signal("rubberContRecycled")
			emit_signal("updateScore")
			playerStatus.set_texture(null)
			speed = 3
			rubberHold.hide()
	if inPlasticRecycle == true and isHoldingPlasticCont == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("space"):
			emit_signal("plasticContainerReturn")
			emit_signal("plasticContRecycled")
			emit_signal("updateScore")
			playerStatus.set_texture(null)
			speed = 3
			plasticHold.hide()
	#when player segregate trash resets stuff
	if p1segregateTrash == true and isHoldingTrash == true:
		if Input.is_action_just_pressed("space"):
			segCounterLimit += trashLimit
			var prevz = segCounterLimit
			if segCounterLimit > 5:
				print("Segregate is too much")
				trashLimit = (segCounterLimit - 5)
				p1segregateTrash = false
				speed = 3
				p1weightDebuff(trashLimit)
			else:
				speed = 3
				emit_signal("p1trashSegregated")
				p1segregateTrash = false
				p1CanSeg = true
				hazardChanceofDrop = 0
				trashLimit = 0
				print("Trash put in segregated area")
	if canDump == true:
		if Input.is_action_just_pressed("space"):
			if isHoldingTrash == true:
				trashLimit = 0
				emit_signal("minusScore")
				isHoldingTrash = false
				canDump = false
				p1CanSeg = true
				speed = 3
			if grabbingSeg == true:
				segLimit = 0
				emit_signal("minusScore")
				onHandMetal = 0
				onHandPlastic = 0
				onHandRubber = 0
				segMetalLabel.set_text(str(onHandMetal))
				segPlasticLabel.set_text(str(onHandPlastic))
				segRubberLabel.set_text(str(onHandRubber))
				grabbingSeg = false
				canDump = false
				p1CanSeg = true
				speed = 3
	if detector.is_colliding() and item.has_method("hazard"):
		if Input.is_action_just_pressed("space"):
			item.hazard()
		else:
			currentSpeed = speed
			speed = 0
			emit_signal("canMove")
			item.hazard()
	if trashLimit > 0:
		garbageHold.show()
		spriteTrash.show()
		x.show()
		trashCountLabel.show()
	if trashLimit <= 0:
		spriteTrash.hide()
		x.hide()
		trashCountLabel.hide()
		spriteTrash.hide()
		garbageHold.hide()
		isHoldingTrash = false
	if onHandMetal <= 0 and onHandPlastic <= 0 and onHandRubber <= 0:
		segLabels.hide()
		segImages.hide()
		segHold.hide()
	if onHandMetal > 0 or onHandPlastic > 0 or onHandRubber > 0:
		segHold.show()
	velocity += gravity*delta
	#Movement X
	if Input.is_action_pressed("d") and Input.is_action_pressed("a"):
		velocity.x = 0
		isMoving = false
	elif Input.is_action_pressed("d"):
		velocity.x = float(speed)
		player.set_rotation_degrees(Vector3(0,90,0))
		isMoving = true
	elif Input.is_action_pressed("a"):
		velocity.x = float(-speed)
		player.set_rotation_degrees(Vector3(0,-90,0))
		isMoving = true
	else :
		velocity.x = 0
		isMoving = false
	#Movement Z
	if Input.is_action_pressed("w") and Input.is_action_pressed("s"):
		velocity.z = 0
		isMoving = false
	elif Input.is_action_pressed("s"):
		player.set_rotation_degrees(Vector3(0,0,0))
		velocity.z = float(speed)
		isMoving = true
	elif Input.is_action_pressed("w"):
		velocity.z = float(-speed)
		player.set_rotation_degrees(Vector3(0,180,0))
		isMoving = true
	else :
		velocity.z = 0
		isMoving = false
	if isMoving == true:
		var angle = atan2(velocity.x,velocity.z)
		var char_rot = player.get_rotation()
		char_rot.y = angle
		player.set_rotation(char_rot)
	velocity = velocity.normalized() * speed
	move_and_slide(velocity, Vector3.UP)
	if segLimit <= 0:
		grabbingSeg = false
	if speed > 3:
		speed = 3
#after timeout p1 can grab again
func _on_p1Wait_timeout():
	timeCanGrab = true
#when inside segregation area can dispose trash
func _on_Segregation_Area_body_entered(body):
	if body.get_name() == "Player1":
		p1segregateTrash = true
#checks if player can pick up metal container
func _on_metalContainer_canPickUp():
	canPickUpMetal = true
#+1 metal when pick up metal
func _on_Player1_plusOneMetal():
	onHandMetal += 1
	print("On hand metal:",onHandMetal)
#updates when player is out of container body
func _on_metalContainer_body_exited(body):
	if body.get_name() == 'Player1':
		metalContainerInteract = false
#updates when player is in recycle body
func _on_MetalRecycle_body_entered(body):
	if body.get_name() == "Player1":
		inMetalRecycle = true
#updates when player is out of recycle body
func _on_MetalRecycle_body_exited(body):
	if body.get_name() == "Player1":
		inMetalRecycle = false
func _on_Player1_plusOneRubber():
	onHandRubber += 1
	print("On hand rubber:",onHandRubber)
func _on_rubberContainer_canPickUp():
	canPickUpRubber = true
func _on_rubberContainer_body_exited(body):
	if body.get_name() == "Player1":
		rubberContainerInteract = false
func _on_RubberRecycle_body_entered(body):
	if body.get_name() == "Player1":
		inRubberRecycle = true
func _on_RubberRecycle_body_exited(body):
	if body.get_name() == "Player1":
		inRubberRecycle = false
func _on_Player1_plusOnePlastic():
	 onHandPlastic += 1
func _on_plasticContainer_canPickUp():
	canPickUpPlastic = true
func _on_plasticContainer_body_exited(body):
	if body.get_name() == "Player1":
		plasticContainerInteract = false
func _on_PlasticRecycle_body_entered(body):
	if body.get_name() == "Player1":
		inPlasticRecycle = true
func _on_PlasticRecycle_body_exited(body):
	if body.get_name() == "Player1":
		inPlasticRecycle = false
func _on_hazardDropP1_timeout():
	rng.randomize()
	var random = rng.randi_range(1, 100)
	if random <= hazardChanceofDrop:
		emit_signal("hazardSpawn")
func _on_Dump_body_entered(body):
	if body.get_name() == "Player1":
		canDump = true
func _on_p1CanMove_timeout():
	speed = currentSpeed
	currentSpeed = speed
#when near metal recycle, allow contact
func _on_metalContainer_p1IsEntered():
	metalContainerInteract = true
func _on_plasticContainer_p1IsEntered():
	plasticContainerInteract = true
func _on_rubberContainer_p1IsEntered():
	rubberContainerInteract = true
func _on_plasticContainer_gotRecycled():
	canPickUpPlastic = false
func _on_rubberContainer_gotRecycled():
	canPickUpRubber = false
func _on_metalContainer_gotRecycled():
	canPickUpMetal = false
func _on_Segregation_Area_body_exited(body):
	if body.get_name() == "Player1":
		p1segregateTrash = false
func _on_Dump_body_exited(body):
	if body.get_name() == "Player1":
			canDump = false
