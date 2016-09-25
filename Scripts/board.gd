extends Node

const Piece = preload("res://Scripts/piece.gd").Piece
const King = preload("res://Scripts/piece.gd").King
const Queen = preload("res://Scripts/piece.gd").Queen
const Rook = preload("res://Scripts/piece.gd").Rook
const Knight = preload("res://Scripts/piece.gd").Knight
const Bishop = preload("res://Scripts/piece.gd").Bishop
const Pawn = preload("res://Scripts/piece.gd").Pawn

const Common = preload("res://common_lib.gd")

const piece_list = Array()
const future_piece_list = Array()

var player_node

func _ready():
	var root = get_tree().get_current_scene()
	player_node = root.get_node("logic/player")
	pass

static func get_color_range(color):
	if (color == Piece.WHITE):
		return range(16)
	else:
		return range(16, 32)

func replace_piece(prev, cur):
	for i in range(32):
		if (piece_list[i] == prev):
			piece_list[i] = cur
			return

func get_piece(coord):
	for i in range(piece_list.size()):
		if (!piece_list[i].captured):
			if (piece_list[i].x == coord.x && piece_list[i].y == coord.y):
				return piece_list[i]
	return null

# return: Array of Vector2 containing valid move locations
func get_moves_with_castling(sel_piece):
	var moves = get_moves(sel_piece)
	
	# add castling if king
	if (sel_piece.type == Piece.KING):
		if (is_qs_castle_legal(sel_piece)):
			moves.append([])
			moves[moves.size() - 1].append(Vector2(sel_piece.x - 2, sel_piece.y))
		if (is_ks_castle_legal(sel_piece)):
			moves.append([])
			moves[moves.size() - 1].append(Vector2(sel_piece.x + 2, sel_piece.y))
	return moves

func get_moves(sel_piece):
	var moves = sel_piece.get_moves()
	var i = 1 # 0 is reserved for the piece's own position
	while (i < moves.size()):
		var j = 0
		var foundPiece = false
		var remove = false
		while (j < moves[i].size()):
			if (!is_move_valid(sel_piece, moves[i][j])):
				remove = true
				if (get_piece(moves[i][j]) != null):
					foundPiece = true
			
			if (!remove):
				if (foundPiece):
					remove = true
				else:
					var move_piece = get_piece(moves[i][j])
					if (move_piece != null):
						if (move_piece.color == sel_piece.color):
							remove = true
							foundPiece = true
						else:
							if (foundPiece):
								remove = true;
							else:
								foundPiece = true
			if (remove):
				moves[i].remove(j)
			else:
				j += 1
		i += 1
	return moves

func is_qs_castle_legal(king):
	if (player_node.get_player(king.color).in_check):
		return false
	if (king.hasMoved || get_piece(Vector2(0, king.y)).hasMoved):
		return false
	for i in range(1, 4):
		if (get_piece(Vector2(i, king.y)) != null):
			return false
	if (is_square_attacked_by(Vector2(2, king.y), !king.color) || is_square_attacked_by(Vector2(3, king.y), !king.color)):
		return false
	return true

func is_ks_castle_legal(king):
	if (player_node.get_player(king.color).in_check):
		return false
	if (king.hasMoved || get_piece(Vector2(7, king.y)).hasMoved):
		return false
	for i in range(5, 7):
		if (get_piece(Vector2(i, king.y)) != null):
			return false
	if (is_square_attacked_by(Vector2(5, king.y), !king.color) || is_square_attacked_by(Vector2(6, king.y), !king.color)):
		return false
	return true

func is_square_attacked_by(square, color):
	for i in get_color_range(color):
		var piece = piece_list[i]
		if (piece.captured):
			continue
		var moves = get_moves(piece)
		for j in range(moves.size()):
			for k in range(moves[j].size()):
				if (moves[j][k].x == square.x && moves[j][k].y == square.y):
					return true
	return false

func is_move_valid(sel_piece, coord):
	# move is outside of board
	if (coord.x < 0 || coord.x >= 8 || coord.y < 0 || coord.y >= 8):
		return false
	
	if (sel_piece.type == Piece.PAWN):
		var move_piece = get_piece(coord)
		if (sel_piece.x != coord.x && move_piece == null):
			return false;
		if (sel_piece.x == coord.x && move_piece != null):
			return false;
	
	return true

func is_player_in_check(color):
	var king
	var set = get_color_range(!color)
	for i in get_color_range(color):
		if (piece_list[i].type == Piece.KING):
			king = piece_list[i]
			break
	return is_square_attacked_by(Vector2(king.x, king.y), !color)

func is_checkmate(color):
	# check all possible moves for checkmate
	if (player_node.get_active_player().in_check):
		var set
		set = get_color_range(color)
		for i in set:
			var piece = piece_list[i]
			if (piece.captured):
				continue
			var moves = get_moves(piece)
			for x in range(moves.size()):
				for y in range(moves[x].size()):
					var tmpX = piece.x
					var tmpY = piece.y
					var move_piece = get_piece(moves[x][y])
					if (move_piece != null):
						move_piece.captured = true
					piece.x = moves[x][y].x
					piece.y = moves[x][y].y
					if (!is_player_in_check(player_node.player_turn)):
						piece.x = tmpX
						piece.y = tmpY
						print(piece.toString())
						if (move_piece != null):
							move_piece.captured = false
						return false
					piece.x = tmpX
					piece.y = tmpY
					if (move_piece != null):
						move_piece.captured = false
		return true
	return false

func _create_pieces():
	piece_list.clear()
	
	for i in range(8):
		piece_list.append(Pawn.new(Piece.WHITE))
	
	for i in range(2):
		piece_list.append(Bishop.new(Piece.WHITE))
	
	for i in range(2):
		piece_list.append(Knight.new(Piece.WHITE))
	
	for i in range(2):
		piece_list.append(Rook.new(Piece.WHITE))
	
	piece_list.append(Queen.new(Piece.WHITE))
	piece_list.append(King.new(Piece.WHITE))
	
	for i in range(8):
		piece_list.append(Pawn.new(Piece.BLACK))
	
	for i in range(2):
		piece_list.append(Bishop.new(Piece.BLACK))
	
	for i in range(2):
		piece_list.append(Knight.new(Piece.BLACK))
	
	for i in range(2):
		piece_list.append(Rook.new(Piece.BLACK))
	
	piece_list.append(Queen.new(Piece.BLACK))
	piece_list.append(King.new(Piece.BLACK))

func _reset():
	# pawns
	for j in range(0, 17, 16):
		for i in range(8):
			piece_list[i + j].x = i
	
	for i in range(0, 17, 16):
		# bishops
		piece_list[8 + i].x = 2
		piece_list[9 + i].x = 5
		
		# knights
		piece_list[10 + i].x = 1
		piece_list[11 + i].x = 6
		
		# rooks
		piece_list[12 + i].x = 0
		piece_list[13 + i].x = 7
		
		# king/queen
		piece_list[14 + i].x = 3
		piece_list[15 + i].x = 4
	
	# White
	for i in range(8):
		piece_list[i].y = 6
	for i in range(8, 16):
		piece_list[i].y = 7
		
	#Black
	for i in range(16, 24):
		piece_list[i].y = 1
	for i in range(24, 32):
		piece_list[i].y = 0

static func get_new_piece(type, color):
	if (type == Piece.PAWN):
		return Pawn.new(color)
	if (type == Piece.BISHOP):
		return Bishop.new(color)
	if (type == Piece.KNIGHT):
		return Knight.new(color)
	if (type == Piece.ROOK):
		return Rook.new(color)
	if (type == Piece.QUEEN):
		return Queen.new(color)
	if (type == Piece.KING):
		return King.new(color)