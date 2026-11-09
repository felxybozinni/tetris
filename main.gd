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
@onready var mega_bar: ProgressBar = $Control/ReferenceRect/Control/MegaBar
@onready var levelsound: AudioStreamPlayer2D = $levelsound

@onready var ticktimer: Timer = $ticktimer
var score = 0
var lines = 0
var gamelevel = 1
var linestolevel = 3
var currentlinestolevel = 0
@onready var pieceholder: CanvasLayer = $pieces
var fast = false
var megabarprog = 0
var frenzybarprog = 0
@onready var frenzy_bar: ProgressBar = $Control/ReferenceRect/Control/Panel5/ProgressBar

var level = [
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0]
]

var pieces = [
	[Vector2(3,0),Vector2(4,0),Vector2(5,0),Vector2(4,1)],
	[Vector2(3,0),Vector2(4,0),Vector2(5,0),Vector2(6,0)],
	[Vector2(3,0),Vector2(4,0),Vector2(4,1),Vector2(5,1)],
	[Vector2(3,1),Vector2(4,1),Vector2(4,0),Vector2(5,0)],
	[Vector2(3,0),Vector2(3,1),Vector2(4,0),Vector2(4,1)],
	[Vector2(3,0),Vector2(4,0),Vector2(5,0),Vector2(5,1)],
	[Vector2(3,1),Vector2(3,0),Vector2(4,0),Vector2(5,0)],
	[Vector2(0,0),Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(4,0),Vector2(5,0),Vector2(6,0),Vector2(7,0)],
	[Vector2(4,0),Vector2(4,1),Vector2(5,2),Vector2(3,2)]
]

var size = Vector2(300,630)

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
		score += 10
		megabarprog += 3
		frenzybarprog += 1.5
	nextpiece = randi_range(0,6)
	var piece = pieces [chosenpiece]
	selectedpieces.clear()
	if frenzybarprog >= 100:
		level.remove_at(20)
		level.insert(0,[0,0,0,0,0,0,0,0,0,0])
		renderboard()
		score += 1000
		lines += 3
		levelsound.play()
		level.remove_at(20)
		level.insert(0,[0,0,0,0,0,0,0,0,0,0])
		renderboard()
		level.remove_at(20)
		level.insert(0,[0,0,0,0,0,0,0,0,0,0])
		renderboard()
		frenzybarprog = 0
	currentpiecetype = Vector2(chosenpiece,1)
	for i in piece:
		level [i.y] [i.x] = chosenpiece+1
		selectedpieces.append(i)
	renderboard()

func renderboard():
	for i in pieceholder.get_children():
		i.queue_free()
	for y in 21:
		for x in 10:
			var instance = TEXTURE.instantiate()
			pieceholder.add_child(instance)
			instance.global_position = Vector2(x*30,y*30)+window.position
			match level [y] [x]:
				0:
					instance.texture = null
				1:
					instance.texture = BLOCK_0
				2:
					instance.texture = BLOCK_1
				3:
					instance.texture = BLOCK_2
				4:
					instance.texture = BLOCK_3
				5:
					instance.texture = BLOCK_4
				6:
					instance.texture = BLOCK_5
				7:
					instance.texture = BLOCK_6
				8:
					instance.texture = BLOCK_1
					instance.self_modulate = Color(0.529, 0.533, 0.72, 1.0)
				9:
					instance.texture = BLOCK_0

func _on_ticktimer_timeout() -> void:
	tick()

func tick():
	if selectedpieces.size() > 0:
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

func _process(_delta: float) -> void:
	if score >= 100000:
		get_tree().change_scene_to_file("res://win.tscn")
	nextdisplay.frame = nextpiece
	if nextpiece == 7:
		nextdisplay.self_modulate = Color(0.529,0.533,0.72,1)
	else:
		nextdisplay.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	if linestolevel <= currentlinestolevel:
		currentlinestolevel = 0
		linestolevel *= 1.5
		linestolevel = snapped(linestolevel,1)
		gamelevel += 1
		ticktimer.wait_time *= 0.8
	var linesthistick = 0
	if Input.is_action_just_pressed("left") == true:
		if checkleft(selectedpieces) == true:
			var colour
			for i in selectedpieces:
				colour = level [i.y] [i.x]
			for i in selectedpieces:
						level [i.y] [i.x] = 0
			for i in selectedpieces:
						selectedpieces [selectedpieces.find(i)] += Vector2(-1,0)
						level [i.y] [i.x-1] = colour
						renderboard()
	if Input.is_action_just_pressed("right") == true:
		if checkright(selectedpieces) == true:
			var colour
			for i in selectedpieces:
				colour = level [i.y] [i.x]
			for i in selectedpieces:
						level [i.y] [i.x] = 0
			for i in selectedpieces:
						selectedpieces [selectedpieces.find(i)] += Vector2(1,0)
						level [i.y] [i.x+1] = colour
						renderboard()
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
			if scanner.y >= 20:
				pass
			else:
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
	if Input.is_action_just_pressed("megaaction"):
		if megabarprog >= 100:
			nextpiece = 7
			megabarprog = 0
	if fast == true:
		Engine.time_scale = 2
	else:
		Engine.time_scale = 1
	levelcount.text = "level "+str(gamelevel)
	scorecount.text = str(score)+" points"
	linecount.text = str(lines)+" lines"
	mega_bar.value = megabarprog
	for i in level:
		if i.find(0) == -1:
			level.remove_at(level.find(i))
			level.insert(0,[0,0,0,0,0,0,0,0,0,0])
			renderboard()
			linesthistick += 1
			score += 100
			lines += 1
			levelsound.play()
			megabarprog += 13
			frenzybarprog += 7
			currentlinestolevel += 8
	frenzy_bar.value = frenzybarprog
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
		if level [i.y] [i.x-1] != 0 && checkedpieces.has(Vector2(i.x-1,i.y)) == false:
			permitted = false
	return permitted

func checkright(checkedpieces : Array):
	var permitted = true
	for i in checkedpieces:
		if i.x == 9 or i.y == 20:
			permitted = false
			return permitted
		if level [i.y] [i.x+1] != 0 && checkedpieces.has(Vector2(i.x+1,i.y)) == false:
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
		if i.x < 0 or i.x >= 10:
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
