extends Control

const PAWN_WHITE_IMG = preload("res://img/pawn_white.png")
const PAWN_BLACK_IMG = preload("res://img/pawn_black.png")
const BISHOP_WHITE_IMG = preload("res://img/bishop_white.png")
const BISHOP_BLACK_IMG = preload("res://img/bishop_black.png")
const KNIGHT_WHITE_IMG = preload("res://img/knight_white.png")
const KNIGHT_BLACK_IMG = preload("res://img/knight_black.png")
const ROOK_WHITE_IMG = preload("res://img/rook_white.png")
const ROOK_BLACK_IMG = preload("res://img/rook_black.png")
const QUEEN_WHITE_IMG = preload("res://img/queen_white.png")
const QUEEN_BLACK_IMG = preload("res://img/queen_black.png")
const KING_WHITE_IMG = preload("res://img/king_white.png")
const KING_BLACK_IMG = preload("res://img/king_black.png")

const View = preload("res://Scripts/board_view.gd")
const Player = preload("res://Scripts/player.gd")
const Piece = preload("res://Scripts/piece.gd").Piece

const CAP_IMG_SIZE = 30

const cap_pieces = Array()

var root
var player_node
var board_node

# Child Nodes
var label_turn
var label_check
var time_white
var time_black

var cap_white
var cap_black

var timer_white
var timer_black

func _ready():
	root = get_tree().get_current_scene()
	player_node = root.get_node("logic/player")
	board_node = root.get_node("logic/board")
	time_white = get_node("Viewport/time_white")
	time_black = get_node("Viewport/time_black")
	cap_white = get_node("Viewport/captured_white")
	cap_black = get_node("Viewport/captured_black")
	
	label_turn = get_node("Viewport/player_turn")
	label_check = get_node("Viewport/check_state")
	
	timer_white = get_node("timer_white")
	timer_black = get_node("timer_black")
	
	set_process(true)

func update_cap_grids():
	for i in range(32):
		var piece = board_node.piece_list[i]
		if (piece.captured && !cap_pieces[i]):
			var tx = TextureFrame.new()
			tx.set_texture(View.get_piece_img(piece.type, piece.color))
			tx.set_expand(true)
			tx.set_custom_minimum_size(Vector2(CAP_IMG_SIZE, CAP_IMG_SIZE))
			tx.set_size(Vector2(CAP_IMG_SIZE, CAP_IMG_SIZE))
			if (piece.color == Piece.WHITE):
				cap_white.add_child(tx)
			else:
				cap_black.add_child(tx)
			cap_pieces[i] = true

func reset():
	cap_pieces.clear()
	for i in range(32):
		cap_pieces.append(false)
	
	for i in range(cap_white.get_child_count()):
		var child = cap_white.get_child(i)
		cap_white.remove_child(child)
		child.free()
	for i in range(cap_black.get_child_count()):
		var child = cap_black.get_child(i)
		cap_black.remove_child(child)
		child.free()
	
	timer_white.set_wait_time(1500)
	timer_black.set_wait_time(1500)
	timer_white.set_active(true)
	timer_white.start()
	timer_black.start()
	timer_black.set_active(false)
	update()

func toggle_timer(color):
	timer_white.set_active(color)
	timer_black.set_active(!color)

func _process(delta):
	var tw = int(timer_white.get_time_left())
	var tb = int(timer_black.get_time_left())
	var secW = tw % 60
	var secB = tb % 60
	if (secW < 10):
		secW = str(tw % 60, "0")
	if (secB < 10):
		secB = str(tb % 60, "0")
	time_white.set_text(str("WHITE:\n", tw / 60, ":", secW))
	time_black.set_text(str("BLACK:\n", tb / 60, ":", secB))

func _on_draw():
	update_cap_grids()
	if (player_node.player_turn == Piece.WHITE):
		label_turn.set_text("WHITE's move")
	else:
		label_turn.set_text("BLACK's move")
	
	if(player_node.player_white.in_checkmate):
		label_check.set_text("WHITE in checkmate!")
	elif(player_node.player_black.in_checkmate):
		label_check.set_text("BLACK in checkmate!")
	elif(player_node.player_white.in_check):
		label_check.set_text("WHITE in check!")
	elif(player_node.player_black.in_check):
		label_check.set_text("BLACK in check!")
	elif(player_node.player_white.out_of_time):
		label_check.set_text("WHITE out of time!")
	elif(player_node.player_black.out_of_time):
		label_check.set_text("BLACK out of time!")
	else:
		label_check.set_text("")

func _on_Button_pressed():
	root.reset = true

func _on_timer_white_timeout():
	player_node.move_state = Player.STATE_GAME_OVER
	player_node.get_active_player().out_of_time = true
	timer_white.stop()
	timer_black.set_active(false)
	update()

func _on_timer_black_timeout():
	player_node.move_state = Player.STATE_GAME_OVER
	player_node.get_active_player().out_of_time = true
	timer_white.set_active(false)
	timer_black.stop()
	update()