extends KinematicBody
signal trashCount
signal pickUpWait
signal trashSegregated
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
signal tLim1
signal tLim2
signal tLim3
signal trashDumped
signal p4animTimerStart
signal segMetalGo
signal segPlasticGo
signal segRubberGo
signal segregateAnimPlay
signal dizzyAnimPlay
var gravity = Vector3.DOWN * 12
var speed = 3
var isHoldingTrash = false
var velocity = Vector3()
var itemLimit
var trashLimit = 0
var timeCanGrab = true
var segregateTrash
var isMoving = false
var canSeg = true
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
#var segCounterLimit = 0
var rng = RandomNumberGenerator.new()
var canDump = false
var canMove = true
onready var player = get_node(".")
onready var detector = $PickUp
var enteredTrashArea = false
var hazardChanceofDrop = 0
var rubberSegSpeedDec = 0
var plasticSegSpeedDec = 0
var metalSegSpeedDec = 0
var currentSpeed = speed
var spriteContMetal = preload("res://Assets/Sprites/conmeticon.png")
var spriteContRubber = preload("res://Assets/Sprites/conrubicon.png")
var spriteContPlastic = preload("res://Assets/Sprites/conplasicon.png")
var trashCount = 0
var amountCanPutSeg = 0
var trashAmount = 0
onready var spriteTrash = $P4/trashSprite
onready var trashCountLabel = $P4/trashCount
onready var x = $P4/x
onready var playerStatus = $P4/singleSprite
onready var segPlasticLabel = $P4/segLabels/segPlastic
onready var segRubberLabel = $P4/segLabels/segRubber
onready var segMetalLabel = $P4/segLabels/segMetal
onready var segLabels = $P4/segLabels
onready var segImages = $P4/threeicons
onready var metalHold = $MetalHold
onready var plasticHold = $PlasticHold
onready var rubberHold = $RubberHold
onready var garbageHold = $GarbageHold
onready var segHold = $segHold
onready var noHoldGrab = $noHoldGrab/AnimationPlayer
onready var noHoldGrabSprite = $noHoldGrab
onready var trashHoldGrab = $trashHoldGrab/AnimationPlayer
onready var trashHoldGrabSprite = $trashHoldGrab
onready var segGrab = $segTrashHoldGrab/AnimationPlayer
onready var segGrabSprite = $segTrashHoldGrab
onready var dizzyNoHold = $dizzyNoHold/AnimationPlayer
onready var dizzyTrashHold = $dizzyTrashHold/AnimationPlayer
onready var dizzySegTrashHold = $dizzySegTrashHold/AnimationPlayer
onready var dizzyPlasticHold = $dizzyPlasticHold/AnimationPlayer
onready var dizzyMetalHold = $dizzyMetalHold/AnimationPlayer
onready var dizzyRubberHold = $dizzyRubberHold/AnimationPlayer
onready var dizzyNoHoldSprite = $dizzyNoHold
onready var dizzyTrashHoldSprite = $dizzyTrashHold
onready var dizzySegTrashHoldSprite = $dizzySegTrashHold
onready var dizzyPlasticHoldSprite = $dizzyPlasticHold
onready var dizzyMetalHoldSprite = $dizzyMetalHold
onready var dizzyRubberHoldSprite = $dizzyRubberHold
onready var noHold = $NoHold
var isTrashNoHold = false
var isTrashYesHold = false
var isSegTrashNoHold = false
var isSegTrashYesHold = false
func _ready():
	itemLimit = false
	segregateTrash = false
func weightDebuff(type):
	speed = 3
	speed -= (.2*type)
func _physics_process(delta): 
	#Player Pick Up Trash
	var item = detector.get_collider()
	if enteredTrashArea == true and timeCanGrab == true and grabbingSeg == false and trashLimit != 3 and trashAmount > 0:
		if Input.is_action_just_pressed("p4X"):
			trashLimit += 1
			trashAmount -= 1
			trashCountLabel.set_text(str(trashLimit))
			timeCanGrab = false
			canSeg = false
			isHoldingTrash = true
			emit_signal("pickUpWait")
			emit_signal("trashCount")
			weightDebuff(trashLimit)
			hazardChanceofDrop += 5
			print("Trash on hand:", trashLimit)
			emit_signal("trashPickedUp")
			if trashLimit > 1:
				trashHoldGrabSprite.show()
				trashHoldGrab.play("Object_0.004Action")
				isTrashYesHold = true
				garbageHold.hide()
			if trashLimit <= 1:
				noHoldGrabSprite.show()
				isTrashNoHold = true
				noHoldGrab.play("Object_0.004Action")
			emit_signal("p4animTimerStart")
	#detects segregated metal
	if detector.is_colliding() and item.has_method("metalSeg") and canSeg == true and segLimit != 10:
		if Input.is_action_just_pressed("p4X"):
			global.segCounterLimit -= 1
			global.metal += 1
			segImages.show()
			segLabels.show()
			grabbingSeg = true
			segLimit += 1
			item.metalSeg()
			metalSlowDebuff += 1
			metalSegSpeedDec += (speed*metalSlowDebuff) 
			emit_signal("plusOneMetal")
			weightDebuff(segLimit)
			segMetalLabel.set_text(str(onHandMetal))
			if segLimit > 1:
				segGrabSprite.show()
				segGrab.play("Object_0.004Action")
				segHold.hide()
				isSegTrashYesHold = true
			if segLimit <= 1:
				noHoldGrabSprite.show()
				isSegTrashNoHold = true
				noHoldGrab.play("Object_0.004Action")
			emit_signal("p4animTimerStart")
	if detector.is_colliding() and item.has_method("rubberSeg") and canSeg == true and segLimit != 10:
		if Input.is_action_just_pressed("p4X"):
			global.segCounterLimit -= 1
			global.rubber += 1
			segImages.show()
			segLabels.show()
			grabbingSeg = true
			segLimit += 1
			item.rubberSeg()
			rubberSlowDebuff += 1
			rubberSegSpeedDec += (speed*rubberSlowDebuff) 
			emit_signal("plusOneRubber")
			weightDebuff(segLimit)
			segRubberLabel.set_text(str(onHandRubber))
			if segLimit > 1:
				segGrabSprite.show()
				segGrab.play("Object_0.004Action")
				segHold.hide()
				isSegTrashYesHold = true
			if segLimit <= 1:
				noHoldGrabSprite.show()
				isSegTrashNoHold = true
				noHoldGrab.play("Object_0.004Action")
			emit_signal("p4animTimerStart")
	if detector.is_colliding() and item.has_method("plasticSeg") and canSeg == true and segLimit != 10:
		if Input.is_action_just_pressed("p4X"):
			global.segCounterLimit -= 1
			global.plastic += 1
			segImages.show()
			segLabels.show()
			grabbingSeg = true
			segLimit += 1
			item.plasticSeg()
			plasticSlowDebuff += 1
			plasticSegSpeedDec += (speed*plasticSlowDebuff) 
			emit_signal("plusOnePlastic")
			weightDebuff(segLimit)
			segPlasticLabel.set_text(str(onHandPlastic))
			if segLimit > 1:
				segGrabSprite.show()
				segGrab.play("Object_0.004Action")
				segHold.hide()
				isSegTrashYesHold = true
			if segLimit <= 1:
				noHoldGrabSprite.show()
				isSegTrashNoHold = true
				noHoldGrab.play("Object_0.004Action")
			emit_signal("p4animTimerStart")
	#metal recycling
	if metalContainerInteract == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("p4X"):
			#stores metal in container
			if onHandMetal > 0 and onHandMetal < 11 and canPickUpMetal == false: 
				segLimit -= onHandMetal
				onHandMetal = 0
				segMetalLabel.set_text(str(onHandMetal))
				metalSlowDebuff = 0
				weightDebuff(segLimit)
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
				weightDebuff(12)
	#rubber
	if rubberContainerInteract == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("p4X"):
			#stores rubber in container
			if onHandRubber > 0  and onHandRubber < 11 and canPickUpRubber == false: #and onHandMetal < 11
				segLimit -= onHandRubber
				onHandRubber = 0
				segRubberLabel.set_text(str(onHandRubber))
				rubberSlowDebuff = 0
				weightDebuff(segLimit)
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
				weightDebuff(12)
	#plastic
	if plasticContainerInteract == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("p4X"):
			#stores rubber in container
			if onHandPlastic > 0  and onHandPlastic < 11 and canPickUpPlastic == false: #and onHandMetal < 11
				segLimit -= onHandPlastic
				onHandPlastic = 0
				segPlasticLabel.set_text(str(onHandPlastic))
				plasticSlowDebuff = 0
				weightDebuff(segLimit)
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
				weightDebuff(12)
	#if holding metal cont and near metal recyler, puts container in recycler and gives points
	if inMetalRecycle == true and isHoldingMetalCont == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("p4X"):
			emit_signal("metalContainerReturn")
			emit_signal("metalContRecycled")
			emit_signal("updateScore")
			playerStatus.set_texture(null)
			speed = 3
			metalHold.hide()
			emit_signal("segMetalGo")
			isHoldingMetalCont = false
	if inRubberRecycle == true and isHoldingRubberCont == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("p4X"):
			emit_signal("rubberContainerReturn")
			emit_signal("rubberContRecycled")
			emit_signal("updateScore")
			playerStatus.set_texture(null)
			speed = 3
			rubberHold.hide()
			emit_signal("segRubberGo")
			isHoldingRubberCont = false
	if inPlasticRecycle == true and isHoldingPlasticCont == true and isHoldingTrash == false:
		if Input.is_action_just_pressed("p4X"):
			emit_signal("plasticContainerReturn")
			emit_signal("plasticContRecycled")
			emit_signal("updateScore")
			playerStatus.set_texture(null)
			speed = 3
			plasticHold.hide()
			emit_signal("segPlasticGo")
			isHoldingPlasticCont = false
	#when player segregate trash resets stuff
	if segregateTrash == true and isHoldingTrash == true:
		if Input.is_action_just_pressed("p4X"):
			global.segCounterLimit += trashLimit
			if global.segCounterLimit == 8:
				print("Segregate too much")
				trashLimit = 3
				speed = 3
				weightDebuff(trashLimit)
				segregateTrash = false
				global.segCounterLimit = 5
				trashCountLabel.set_text(str(trashLimit))
				emit_signal("tLim3")
				emit_signal("trashSegregated")
				emit_signal("segregateAnimPlay")
			elif global.segCounterLimit == 7:
				print("Segregate too much")
				trashLimit = 2
				speed = 3
				weightDebuff(trashLimit)
				segregateTrash = false
				global.segCounterLimit = 5
				trashCountLabel.set_text(str(trashLimit))
				emit_signal("tLim2")
				emit_signal("trashSegregated")
				emit_signal("segregateAnimPlay")
			elif global.segCounterLimit == 6:
				print("Segregate too much")
				trashLimit = 1
				speed = 3
				weightDebuff(trashLimit)
				segregateTrash = false
				global.segCounterLimit = 5
				trashCountLabel.set_text(str(trashLimit))
				emit_signal("tLim1")
				emit_signal("trashSegregated")
				emit_signal("segregateAnimPlay")
			elif global.segCounterLimit > 5:
				segregateTrash = false
			else:
				speed = 3
				emit_signal("trashSegregated")
				segregateTrash = false
				canSeg = true
				hazardChanceofDrop = 0
				trashLimit = 0
				emit_signal("segregateAnimPlay")
	if canDump == true:
		if Input.is_action_just_pressed("p4X"):
			if isHoldingTrash == true or grabbingSeg == true:
				trashLimit = 0
				emit_signal("minusScore")
				isHoldingTrash = false
				speed = 3
				segLimit = 0
				onHandMetal = 0
				onHandPlastic = 0
				onHandRubber = 0
				segPlasticLabel.set_text(str(onHandPlastic))
				segMetalLabel.set_text(str(onHandMetal))
				segRubberLabel.set_text(str(onHandRubber))
				emit_signal("trashDumped")
				grabbingSeg = false
				canSeg = true
				canDump = false
	if detector.is_colliding() and item.has_method("hazard"):
		if isHoldingTrash == true:
			currentSpeed = speed
			speed = 0
			emit_signal("canMove")
			item.hazard()
			dizzyTrashHoldSprite.show()
			dizzyTrashHold.play("Object_0.001Action_Object_0.001_Object_0.001")
			emit_signal("dizzyAnimPlay")
			garbageHold.hide()
			noHold.hide()
		elif grabbingSeg == true:
			currentSpeed = speed
			speed = 0
			emit_signal("canMove")
			item.hazard()
			dizzySegTrashHoldSprite.show()
			dizzySegTrashHold.play("Object_0.001Action_Object_0.001_Object_0.001")
			emit_signal("dizzyAnimPlay")
			segHold.hide()
			noHold.hide()
		elif isHoldingMetalCont == true:
			currentSpeed = speed
			speed = 0
			emit_signal("canMove")
			item.hazard()
			dizzyMetalHoldSprite.show()
			dizzyMetalHold.play("Object_0.007Action_Object_0.007_Object_0.007")
			emit_signal("dizzyAnimPlay")
			metalHold.hide()
			noHold.hide()
		elif isHoldingPlasticCont == true:
			currentSpeed = speed
			speed = 0
			emit_signal("canMove")
			item.hazard()
			dizzyPlasticHoldSprite.show()
			dizzyPlasticHold.play("Object_0.000Action_Object_0.000_Object_0.000")
			emit_signal("dizzyAnimPlay")
			plasticHold.hide()
			noHold.hide()
		elif isHoldingRubberCont == true:
			currentSpeed = speed
			speed = 0
			emit_signal("canMove")
			item.hazard()
			dizzyRubberHoldSprite.show()
			dizzyRubberHold.play("Object_0.007Action_Object_0.007_Object_0.007")
			emit_signal("dizzyAnimPlay")
			rubberHold.hide()
			noHold.hide()
		else:
			currentSpeed = speed
			speed = 0
			emit_signal("canMove")
			item.hazard()
			dizzyNoHoldSprite.show()
			dizzyNoHold.play("Object_0Action_Object_0_Object_0")
			emit_signal("dizzyAnimPlay")
			noHold.hide()
	if trashLimit > 0:
		spriteTrash.show()
		x.show()
		trashCountLabel.show()
	if trashLimit <= 0:
		spriteTrash.hide()
		x.hide()
		trashCountLabel.hide()
		garbageHold.hide()
		isHoldingTrash = false
		hazardChanceofDrop = 0
	if onHandMetal <= 0 and onHandPlastic <= 0 and onHandRubber <= 0:
		segLabels.hide()
		segImages.hide()
		segHold.hide()
		grabbingSeg = false
	if onHandMetal > 0 or onHandPlastic > 0 or onHandRubber > 0 and segLimit > 0:
		grabbingSeg = true
	velocity += gravity*delta
	#Movement X
	if Input.is_action_pressed("p4LSRight") and Input.is_action_pressed("p4LSLeft"):
		velocity.x = 0
		isMoving = false
	elif Input.is_action_pressed("p4LSRight"):
		velocity.x = float(speed)
		player.set_rotation_degrees(Vector3(0,90,0))
		isMoving = true
	elif Input.is_action_pressed("p4LSLeft"):
		velocity.x = float(-speed)
		player.set_rotation_degrees(Vector3(0,-90,0))
		isMoving = true
	else :
		velocity.x = 0
		isMoving = false
	#Movement Z
	if Input.is_action_pressed("p4LSUp") and Input.is_action_pressed("p4LSDown"):
		velocity.z = 0
		isMoving = false
	elif Input.is_action_pressed("p4LSDown"):
		player.set_rotation_degrees(Vector3(0,0,0))
		velocity.z = float(speed)
		isMoving = true
	elif Input.is_action_pressed("p4LSUp"):
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
func _on_p4Wait_timeout():
	timeCanGrab = true
#when inside segregation area can dispose trash
func _on_Segregation_Area_body_entered(body):
	if body.get_name() == "Player4":
		segregateTrash = true
#checks if player can pick up metal container
func _on_metalContainer_canPickUp():
	canPickUpMetal = true
#+1 metal when pick up metal
func _on_Player4_plusOneMetal():
	onHandMetal += 1
	print("On hand metal:",onHandMetal)
#updates when player is out of container body
func _on_metalContainer_body_exited(body):
	if body.get_name() == 'Player4':
		metalContainerInteract = false
#updates when player is in recycle body
func _on_MetalRecycle_body_entered(body):
	if body.get_name() == "Player4":
		inMetalRecycle = true
#updates when player is out of recycle body
func _on_MetalRecycle_body_exited(body):
	if body.get_name() == "Player4":
		inMetalRecycle = false
func _on_Player4_plusOneRubber():
	onHandRubber += 1
	print("On hand rubber:",onHandRubber)
func _on_rubberContainer_canPickUp():
	canPickUpRubber = true
func _on_rubberContainer_body_exited(body):
	if body.get_name() == "Player4":
		rubberContainerInteract = false
func _on_RubberRecycle_body_entered(body):
	if body.get_name() == "Player4":
		inRubberRecycle = true
func _on_RubberRecycle_body_exited(body):
	if body.get_name() == "Player4":
		inRubberRecycle = false
func _on_Player4_plusOnePlastic():
	 onHandPlastic += 1
func _on_plasticContainer_canPickUp():
	canPickUpPlastic = true
func _on_plasticContainer_body_exited(body):
	if body.get_name() == "Player4":
		plasticContainerInteract = false
func _on_PlasticRecycle_body_entered(body):
	if body.get_name() == "Player4":
		inPlasticRecycle = true
func _on_PlasticRecycle_body_exited(body):
	if body.get_name() == "Player4":
		inPlasticRecycle = false
func _on_hazardDropP4_timeout():
	rng.randomize()
	var random = rng.randi_range(1, 100)
	if random <= hazardChanceofDrop:
		emit_signal("hazardSpawn")
func _on_Dump_body_entered(body):
	if body.get_name() == "Player4":
		canDump = true
func _on_p4CanMove_timeout():
	speed = currentSpeed
	currentSpeed = speed
#when near metal recycle, allow contact
func _on_metalContainer_p4IsEntered():
	metalContainerInteract = true
func _on_plasticContainer_p4IsEntered():
	plasticContainerInteract = true
func _on_rubberContainer_p4IsEntered():
	rubberContainerInteract = true
func _on_plasticContainer_gotRecycled():
	canPickUpPlastic = false
func _on_rubberContainer_gotRecycled():
	canPickUpRubber = false
func _on_metalContainer_gotRecycled():
	canPickUpMetal = false
func _on_Segregation_Area_body_exited(body):
	if body.get_name() == "Player4":
		segregateTrash = false
func _on_Dump_body_exited(body):
	if body.get_name() == "Player4":
			canDump = false
func _on_Center_Area_body_entered(body):
	if body.get_name() == "Player4":
		enteredTrashArea = true
func _on_Center_Area_body_exited(body):
	if body.get_name() == "Player4":
		enteredTrashArea = false
func _on_Main_plusOneTrash():
	trashAmount += 1
func _on_p4animTimer_timeout():
	if isTrashNoHold == true:
		noHoldGrabSprite.hide()
		garbageHold.show()
		isTrashNoHold = false
	if isTrashYesHold == true:
		trashHoldGrabSprite.hide()
		garbageHold.show()
		isTrashYesHold = false
	if isSegTrashNoHold == true:
		noHoldGrabSprite.hide()
		segHold.show()
		isSegTrashNoHold = false
	if isSegTrashYesHold == true:
		segGrabSprite.hide()
		segHold.show()
		isSegTrashYesHold = false
func _on_p4HazardTimer_timeout():
	if isHoldingTrash == true:
		dizzyTrashHoldSprite.hide()
		garbageHold.show()
		noHold.show()
	elif grabbingSeg == true:
		dizzySegTrashHoldSprite.hide()
		segHold.show()
		noHold.show()
	elif isHoldingMetalCont == true:
		dizzyMetalHoldSprite.hide()
		metalHold.show()
		noHold.show()
	elif isHoldingPlasticCont == true:
		dizzyPlasticHoldSprite.hide()
		plasticHold.show()
		noHold.show()
	elif isHoldingRubberCont == true:
		dizzyRubberHoldSprite.hide()
		rubberHold.show()
		noHold.show()
	else:
		dizzyNoHoldSprite.hide()
		noHold.show()
