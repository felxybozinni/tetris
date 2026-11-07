extends Node2D
const TEXTURE = preload("uid://bm3h7jhlce17d")
@onready var window: ColorRect = $BG/ColorRect
const BLOCK_0 = preload("uid://dw7r03a2u0i5h")
const BLOCK_1 = preload("uid://bslwcov0r78x0")
const BLOCK_2 = preload("uid://bg0e2pypp8xrk")
const BLOCK_3 = preload("uid://6bule6jklgdt")
const BLOCK_4 = preload("uid://cnvjrrh3fqevj")
const BLOCK_5 = preload("uid://wqb854xek56d")
const BLOCK_6 = preload("uid://cyv2fd8b78004")
@onready var levelcount: Label = $Control/ReferenceRect/Control/VBoxContainer/levelcount
@onready var scorecount: Label = $Control/ReferenceRect/Control/VBoxContainer/scorecount
@onready var linecount: Label = $Control/ReferenceRect/Control/VBoxContainer/linecount
@onready var nextdisplay: AnimatedSprite2D = $Control/ReferenceRect/Control/Panel/nextdisplay

@onready var ticktimer: Timer = $ticktimer
var score = 0
var lines = 0
var gamelevel = 1
var linestolevel = 3
var currentlinestolevel = 0
@onready var pieceholder: CanvasLayer = $pieces
var fast = false

var level = [
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]

var pieces = [
	[Vector2(6,0),Vector2(7,0),Vector2(8,0),Vector2(7,1)],
	[Vector2(6,0),Vector2(7,0),Vector2(8,0),Vector2(9,0)],
	[Vector2(6,0),Vector2(7,0),Vector2(7,1),Vector2(8,1)],
	[Vector2(6,1),Vector2(7,1),Vector2(7,0),Vector2(8,0)],
	[Vector2(6,0),Vector2(6,1),Vector2(7,0),Vector2(7,1)],
	[Vector2(6,0),Vector2(7,0),Vector2(8,0),Vector2(8,1)],
	[Vector2(6,1),Vector2(6,0),Vector2(7,0),Vector2(8,0)]
]

var size = Vector2(420,630)

var selectedpieces = []
var currentpiecetype = Vector2()
var queueddirection = "down"
var nextpiece
func _ready() -> void:
	newpiece()
	renderboard()

func newpiece():
	var chosenpiece
	if nextpiece == null:
		chosenpiece = randi_range(0,6)
	else:
		chosenpiece = nextpiece
	nextpiece = randi_range(0,6)
	var piece = pieces [chosenpiece]
	selectedpieces.clear()
	currentpiecetype = Vector2(chosenpiece,1)
	for i in piece:
		level [i.y] [i.x] = chosenpiece+1
		selectedpieces.append(i)
	renderboard()

func renderboard():
	for i in pieceholder.get_children():
		i.queue_free()
	for y in 21:
		for x in 14:
			var instance = TEXTURE.instantiate()
			pieceholder.add_child(instance)
			instance.global_position = Vector2(x*30,y*30)+window.position
			match level [y] [x]:
				0:
					instance.texture = null
				1:
					print(instance.global_position)
					instance.texture = BLOCK_0
				2:
					print(instance.global_position)
					instance.texture = BLOCK_1
				3:
					print(instance.global_position)
					instance.texture = BLOCK_2
				4:
					print(instance.global_position)
					instance.texture = BLOCK_3
				5:
					print(instance.global_position)
					instance.texture = BLOCK_4
				6:
					print(instance.global_position)
					instance.texture = BLOCK_5
				7:
					print(instance.global_position)
					instance.texture = BLOCK_6

func _on_ticktimer_timeout() -> void:
	tick()

func tick():
	if selectedpieces.size() > 0:
		match queueddirection:
			"down":
				if checkdown(selectedpieces) == true:
					var colour
					for i in selectedpieces:
						colour = level [i.y] [i.x]
					for i in selectedpieces:
						level [i.y] [i.x] = 0
					for i in selectedpieces:
						selectedpieces [selectedpieces.find(i)] += Vector2(0,1)
						level [i.y+1] [i.x] = colour
						renderboard()
				else:
					newpiece()
			"left":
				if checkleft(selectedpieces) == true:
					var colour
					for i in selectedpieces:
						colour = level [i.y] [i.x]
					for i in selectedpieces:
						level [i.y] [i.x] = 0
					for i in selectedpieces:
						selectedpieces [selectedpieces.find(i)] += Vector2(-1,1)
						level [i.y+1] [i.x-1] = colour
						renderboard()
				else:
					if checkdown(selectedpieces) == false:
						newpiece()
			"right":
				if checkright(selectedpieces) == true:
					var colour
					for i in selectedpieces:
						colour = level [i.y] [i.x]
					for i in selectedpieces:
						level [i.y] [i.x] = 0
					for i in selectedpieces:
						selectedpieces [selectedpieces.find(i)] += Vector2(1,1)
						level [i.y+1] [i.x+1] = colour
						renderboard()
				else:
					if checkdown(selectedpieces) == false:
						newpiece()
		queueddirection = "down"

func _process(_delta: float) -> void:
	nextdisplay.frame = nextpiece
	if linestolevel <= currentlinestolevel:
		currentlinestolevel = 0
		linestolevel *= 1.5
		linestolevel = snapped(linestolevel,1)
		level += 1
		ticktimer.wait_time *= 0.8
	var linesthistick = 0
	if Input.is_action_just_pressed("left") == true:
		queueddirection = "left"
	if Input.is_action_just_pressed("right") == true:
		queueddirection = "right"
	if Input.is_action_just_pressed("rotate") == true:
		rotate_piece()
	for i in level [0]:
		if i != 0 && currentpiecetype.x+1 != i:
			get_tree().change_scene_to_file("res://lose.tscn")
	if Input.is_action_pressed("down"):
		fast = true
	else:
		fast = false
	if Input.is_action_just_pressed("up"):
		var positionlowests = []
		for i in selectedpieces:
			if selectedpieces.has(Vector2(i.x,i.y+1)):
				break
			var scanner = Vector2(i)
			while level [scanner.y+1] [scanner.x] == 0:
				scanner.y += 1
				if scanner.y == 20:
					break
			positionlowests.append(scanner.y-i.y)
		if positionlowests.size() == 0:
			positionlowests.append(0)
		var colour
		for i in selectedpieces:
			colour = level [i.y] [i.x]
		for i in selectedpieces:
			level [i.y] [i.x] = 0
		for i in selectedpieces:
			selectedpieces [selectedpieces.find(i)] += Vector2(0,positionlowests.min())
			if i.y+positionlowests.min() <= 20:
				level [i.y+positionlowests.min()] [i.x] = colour
			renderboard()
		
	if fast == true:
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1
	levelcount.text = "level "+str(gamelevel)
	scorecount.text = str(score)+" points"
	linecount.text = str(lines)+" lines"
	for i in level:
		if i.find(0) == -1:
			level.remove_at(level.find(i))
			level.insert(0,[0,0,0,0,0,0,0,0,0,0,0,0,0,0])
			renderboard()
			linesthistick += 1
			score += 100
			lines += 1
			currentlinestolevel += 1
	if linesthistick != 0:
		score += (10^linesthistick)

func checkdown(checkedpieces : Array):
	var permitted = true
	for i in checkedpieces:
		if i.y == 20:
			permitted = false
			return permitted
		if level [i.y+1] [i.x] != 0 && checkedpieces.has(Vector2(i.x,i.y+1)) == false:
			permitted = false
	return permitted

func checkleft(checkedpieces : Array):
	var permitted = true
	for i in checkedpieces:
		if i.x == 0 or i.y == 20:
			permitted = false
			return permitted
		if level [i.y+1] [i.x-1] != 0 && checkedpieces.has(Vector2(i.x-1,i.y+1)) == false:
			permitted = false
	return permitted

func checkright(checkedpieces : Array):
	var permitted = true
	for i in checkedpieces:
		if i.x == 13 or i.y == 20:
			permitted = false
			return permitted
		if level [i.y+1] [i.x+1] != 0 && checkedpieces.has(Vector2(i.x+1,i.y+1)) == false:
			permitted = false
	return permitted

func rotate_piece():
	if selectedpieces.size() == 0:
		return
	var rotatedpieces = []
	var pivot = selectedpieces[1]
	for i in selectedpieces:
		var relative_position = i - pivot
		var rotated_position = Vector2(-relative_position.y,relative_position.x)
		rotatedpieces.append(rotated_position + pivot)
	for i in rotatedpieces:
		if i.x < 0 or i.x >= 14:
			return
		if i.y < 0 or i.y >= 21:
			return
		if level[i.y][i.x] != 0 and not selectedpieces.has(i):
			return
	for i in selectedpieces:
		level[i.y][i.x] = 0
	selectedpieces = rotatedpieces
	for i in selectedpieces:
		level[i.y][i.x] = int(currentpiecetype.x)+1
	renderboard()
