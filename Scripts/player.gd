extends Node

const Board = preload("res://Scripts/board.gd")
const Common = preload("res://common_lib.gd")
const Piece = preload("res://Scripts/piece.gd").Piece

var root
var board_view_node
var board_logic_node
var info_node
var promotion_dialog

const STATE_UNSELECTED = 0
const STATE_OWN_SELECTED = 1
const STATE_ENEMY_SELECTED = 2
const STATE_GAME_OVER = 3
const STATE_IN_DIALOG = 4

var player_turn = Piece.WHITE
var player_white = Player.new()
var player_black = Player.new()

var prev_piece
var move_state = STATE_UNSELECTED
var active_moves

func _ready():
	root = get_tree().get_current_scene()
	board_view_node = root.get_node("board_control/Viewport/board_view")
	board_logic_node = root.get_node("logic/board")
	info_node = root.get_node("info_control")
	promotion_dialog = root.get_node("promotion_dialog")

func reset():
	prev_piece = null
	move_state = STATE_UNSELECTED
	player_turn = Piece.WHITE
	player_white.reset()
	player_black.reset()

func _process_user_input():
	if (Input.is_action_just_pressed("ui_select")):
		var mouse_pos = get_viewport().get_mouse_pos()
		var board_rect = board_view_node.get_viewport().get_rect()
		if (!board_rect.has_point(mouse_pos)):
			return
		
		var square = board_view_node.get_board_square(mouse_pos)
		var sel_piece = board_logic_node.get_piece(square)
		if (move_state == STATE_UNSELECTED):
			if (sel_piece != null):
				active_moves = board_logic_node.get_moves_with_castling(sel_piece)
				board_view_node.display_moves(active_moves)
				if (sel_piece.color == player_turn):
					move_state = STATE_OWN_SELECTED
				else:
					move_state = STATE_ENEMY_SELECTED
		elif (move_state == STATE_OWN_SELECTED):
			# selecting friendly piece again
			if (sel_piece != null && sel_piece.color == player_turn):
				if (prev_piece == sel_piece):
					move_state = STATE_UNSELECTED
					board_view_node.clear_moves()
				else:
					active_moves = board_logic_node.get_moves_with_castling(sel_piece)
					board_view_node.display_moves(active_moves)
			# selecting a move for the piece
			elif (Common.array2d_contains(active_moves, square)):
				if (get_active_player().in_check):
					var tmpX = prev_piece.x
					var tmpY = prev_piece.y
					prev_piece.x = square.x
					prev_piece.y = square.y
					if (sel_piece != null):
						sel_piece.captured = true
					if (board_logic_node.is_player_in_check(player_turn)):
						prev_piece.x = tmpX
						prev_piece.y = tmpY
						if (sel_piece != null):
							sel_piece.captured = false
					else:
						prev_piece.x = tmpX
						prev_piece.y = tmpY
						if (sel_piece != null):
							sel_piece.captured = false
						move_piece(sel_piece, square)
				else: #player not currently in check
					var tmpX = prev_piece.x
					var tmpY = prev_piece.y
					prev_piece.x = square.x
					prev_piece.y = square.y
					if (sel_piece != null):
						sel_piece.captured = true
					if (board_logic_node.is_player_in_check(player_turn)):
						prev_piece.x = tmpX
						prev_piece.y = tmpY
						if (sel_piece != null):
							sel_piece.captured = false
					else:
						prev_piece.x = tmpX
						prev_piece.y = tmpY
						if (sel_piece != null):
							sel_piece.captured = false
						move_piece(sel_piece, square)
				sel_piece = null
			# selecting an enemy piece that is not a move
			elif (sel_piece != null && sel_piece.color != player_turn):
				active_moves = board_logic_node.get_moves_with_castling(sel_piece)
				board_view_node.display_moves(active_moves)
				move_state = STATE_ENEMY_SELECTED
			# selecting empty square
			else:
				move_state == STATE_UNSELECTED
				board_view_node.clear_moves()
		elif (move_state == STATE_ENEMY_SELECTED):
			if (sel_piece != null):
				if (prev_piece == sel_piece):
					move_state = STATE_UNSELECTED
					board_view_node.clear_moves()
				else:
					active_moves = board_logic_node.get_moves_with_castling(sel_piece)
					board_view_node.display_moves(active_moves)
					if (sel_piece.color == player_turn):
						move_state = STATE_OWN_SELECTED
					else:
						move_state = STATE_ENEMY_SELECTED
			else:
				move_state == STATE_UNSELECTED
				board_view_node.clear_moves()
		if (sel_piece != null):
			prev_piece = sel_piece
		info_node.update()
		#main logic end
	#if input end

func move_piece(sel_piece, square):
	# check for promotion
	if (prev_piece.type == Piece.PAWN):
		if (square.y == 0 && prev_piece.color == Piece.WHITE || square.y == 7 && prev_piece.color == Piece.BLACK):
			promotion_dialog.set_color(prev_piece.color)
			promotion_dialog.popup()
			move_state = STATE_IN_DIALOG
	
	# check for castling
	if (prev_piece.type == Piece.KING):
		print(prev_piece.toString())
		if (square.x == (prev_piece.x - 2)): #qs castle
			var rook = board_logic_node.get_piece(Vector2(0, prev_piece.y))
			rook.x = 3
			rook.hasMoved = true
		elif (square.x == (prev_piece.x + 2)): #ks castle
			var rook = board_logic_node.get_piece(Vector2(7, prev_piece.y))
			rook.x = 5
			rook.hasMoved = true
	
	prev_piece.x = square.x
	prev_piece.y = square.y
	prev_piece.hasMoved = true
	if (sel_piece != null):
		sel_piece.captured = true
	
	board_view_node.show_pieces()
	board_view_node.clear_moves()
	
	if (move_state != STATE_IN_DIALOG):
		info_node.toggle_timer(player_turn)
		player_turn = !player_turn
		move_state = STATE_UNSELECTED
		player_white.in_check = board_logic_node.is_player_in_check(Piece.WHITE)
		player_black.in_check = board_logic_node.is_player_in_check(Piece.BLACK)
		get_active_player().in_checkmate = board_logic_node.is_checkmate(player_turn)
		if (get_active_player().in_checkmate):
			move_state = STATE_GAME_OVER

func promote_pawn(type):
	promotion_dialog.hide()
	var new_piece = Board.get_new_piece(type, player_turn)
	Piece.copy(prev_piece, new_piece)
	board_logic_node.replace_piece(prev_piece, new_piece)
	
	player_white.in_check = board_logic_node.is_player_in_check(Piece.WHITE)
	player_black.in_check = board_logic_node.is_player_in_check(Piece.BLACK)
	get_active_player().in_checkmate = board_logic_node.is_checkmate(player_turn)
	if (get_active_player().in_checkmate):
		move_state = STATE_GAME_OVER
	else:
		move_state = STATE_UNSELECTED
	player_turn = !player_turn
	board_view_node.show_pieces()
	info_node.update()

func get_player(color):
	if(color == Piece.WHITE):
		return player_white
	else:
		return player_black

func get_active_player():
	if(player_turn == Piece.WHITE):
		return player_white
	else:
		return player_black

class Player:
	var out_of_time = false
	var in_check = false
	var in_checkmate = false
	var has_castled = false
	
	func reset():
		out_of_time = false
		in_check = false
		in_checkmate = false
		has_castled = false