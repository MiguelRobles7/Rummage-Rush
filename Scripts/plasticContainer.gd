extends Area
onready var limit0 = $limit0
onready var limit1 = $limit1
onready var limit2 = $limit2
onready var limit3 = $limit3
onready var limit4 = $limit4
onready var limit5 = $limit5
var plasticsStored = 0
var p1PlasticCounter = 0
var p2PlasticCounter = 0
var p3PlasticCounter = 0
var p4PlasticCounter = 0
var canPickUp = false
var pickable = false
onready var plasticContainer = $"."
signal canPickUp
signal p1IsEntered
signal p2IsEntered
signal p3IsEntered
signal p4IsEntered
signal cannotPickUp
signal gotRecycled
signal playAnim
onready var conEmpty = $StaticBody/conEmpty
onready var conHalf = $StaticBody/conHalf
onready var conFull = $StaticBody/conFull
func _ready():
	pass
#checks if for amount of plastic stored if amount = 10 allows pickup of containers
func _physics_process(delta):
	if plasticsStored <= 0:
		conEmpty.show()
		conHalf.hide()
		conFull.hide()
	if plasticsStored > 0 and plasticsStored < 3:
		conEmpty.hide()
		conHalf.show()
		conFull.hide()
	if plasticsStored > 3:
		conEmpty.hide()
		conHalf.hide()
		conFull.show()
	if plasticsStored >= 5:
		pickable = true
	else:
		pickable = false
	if pickable == true:
		emit_signal("canPickUp")
	if plasticsStored <= 0:
		limit0.show()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if plasticsStored == 1:
		limit0.hide()
		limit1.show()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if plasticsStored == 2:
		limit0.hide()
		limit1.hide()
		limit2.show()
		limit3.hide()
		limit4.hide()
		limit5.hide()
	if plasticsStored == 3:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.show()
		limit4.hide()
		limit5.hide()
	if plasticsStored == 4:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.show()
		limit5.hide()
	if plasticsStored >= 5:
		limit0.hide()
		limit1.hide()
		limit2.hide()
		limit3.hide()
		limit4.hide()
		limit5.show()
#When p1 enters emits signal to p1 script that p1 has entered
func _on_plasticContainer_body_entered(body):
	if body.get_name() == 'Player1':
		emit_signal("p1IsEntered")
	elif body.get_name() == 'Player2':
		emit_signal("p2IsEntered")
	elif body.get_name() == 'Player3':
		emit_signal("p3IsEntered")
	elif body.get_name() == 'Player4':
		emit_signal("p4IsEntered")
#refreshes plastic counter when player stores metal
func _on_Player1_plasticStored():
	plasticsStored += p1PlasticCounter
	p1PlasticCounter = 0
#makes container "disappear" when picked up
func _on_Player1_plasticContPickUp():
	var location = Vector3(0,-10,0)
	plasticContainer.translate(location)
#player 1 sends signal that plastic stored +1
func _on_Player1_plusOnePlastic():
	p1PlasticCounter += 1
#when player 1 puts container in recycling facility returns. Add wait function in final product
func _on_Player1_plasticContainerReturn():
	var location = Vector3(0,10,0)
	plasticContainer.translate(location)
	emit_signal("playAnim")
	plasticsStored = 0
func _on_Player1_plasticContRecycled():
	emit_signal("gotRecycled")
func _on_Player2_plasticStored():
	plasticsStored += p2PlasticCounter
	p2PlasticCounter = 0
#makes container "disappear" when picked up
func _on_Player2_plasticContPickUp():
	var location = Vector3(0,-10,0)
	plasticContainer.translate(location)
#player 1 sends signal that plastic stored +1
func _on_Player2_plusOnePlastic():
	p2PlasticCounter += 1
#when player 1 puts container in recycling facility returns. Add wait function in final product
func _on_Player2_plasticContainerReturn():
	var location = Vector3(0,10,0)
	plasticContainer.translate(location)
	emit_signal("playAnim")
	plasticsStored = 0
func _on_Player2_plasticContRecycled():
	emit_signal("gotRecycled")
func _on_Player3_plasticStored():
	plasticsStored += p3PlasticCounter
	p3PlasticCounter = 0
func _on_Player3_plasticContPickUp():
	var location = Vector3(0,-10,0)
	plasticContainer.translate(location)
func _on_Player3_plusOnePlastic():
	p3PlasticCounter += 1
func _on_Player3_plasticContainerReturn():
	var location = Vector3(0,10,0)
	plasticContainer.translate(location)
	plasticsStored = 0
	emit_signal("playAnim")
func _on_Player3_plasticContRecycled():
	emit_signal("gotRecycled")

func _on_Player4_plasticStored():
	plasticsStored += p4PlasticCounter
	p4PlasticCounter = 0
func _on_Player4_plasticContPickUp():
	var location = Vector3(0,-10,0)
	plasticContainer.translate(location)
func _on_Player4_plusOnePlastic():
	p4PlasticCounter += 1
func _on_Player4_plasticContainerReturn():
	var location = Vector3(0,10,0)
	plasticContainer.translate(location)
	plasticsStored = 0
	emit_signal("playAnim")
func _on_Player4_plasticContRecycled():
	emit_signal("gotRecycled")
