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

func _initialize():
	var root = get_tree().get_current_scene()
	player_node = root.get_node("logic/player")
	pass

static func get_color_range(color):
	if (color == Piece.WHITE):
		return range(16)
	else:
		return range(16, 32)

func get_piece(coord):
	for i in range(piece_list.size()):
		if (!piece_list[i].captured):
			if (piece_list[i].x == coord.x && piece_list[i].y == coord.y):
				return piece_list[i]
	return null

# return: Array of Vector2 containing valid move locations
func get_valid_moves(sel_piece):
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
	# add castling if rook/king
	if (sel_piece.type == Piece.KING || sel_piece.type == Piece.ROOK):
		if (is_qs_castle_legal(sel_piece)):
			moves.append([])
			if (sel_piece.type == Piece.KING):
				moves[moves.size() - 1].append(Vector2(sel_piece.x - 2, sel_piece.y))
			else:
				moves[moves.size() - 1].append(Vector2(sel_piece.x + 3, sel_piece.y))
		if (is_ks_castle_legal(sel_piece)):
			moves.append([])
			if (sel_piece.type == Piece.KING):
				moves[moves.size() - 1].append(Vector2(sel_piece.x + 2, sel_piece.y))
			else:
				moves[moves.size() - 1].append(Vector2(sel_piece.x + 3, sel_piece.y))
	return moves

func is_qs_castle_legal(piece):
	if (!player_node.get_player(piece.color).in_check):
		return false
	if (is_square_attacked_by(Vector2(2, piece.y)) || is_square_attacked_by(Vector2(3, piece.y))):
		return false
	for i in range(1, 4):
		if (get_piece(Vector2(i, piece.y)) != null):
			return false
	return true

func is_ks_castle_legal(piece):
	if (!player_node.get_player(piece.color).in_check):
		return false
	if (is_square_attacked_by(Vector2(5, piece.y)) || is_square_attacked_by(Vector2(6, piece.y))):
		return false
	for i in range(5, 7):
		if (get_piece(Vector2(i, piece.y)) != null):
			return false
	return true

func is_square_attacked_by(square, color):
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
	for i in range(piece_list.size()):
		if (piece_list[i].color == color && piece_list[i].type == Piece.KING):
			king = piece_list[i]
			break
	for i in set:
		if (piece_list[i] == king || piece_list[i].captured):
			continue
		var moves = get_valid_moves(piece_list[i])
		for j in range(moves.size()):
			for k in range(moves[j].size()):
				if (moves[j][k].x == king.x && moves[j][k].y == king.y):
					return true
	return false
	
func is_checkmate(color):
	# check all possible moves for checkmate
	if (player_node.get_active_player().in_check):
		var set
		set = get_color_range(color)
		for i in set:
			var piece = piece_list[i]
			if (piece.captured):
				continue
			var moves = get_valid_moves(piece)
			for x in range(moves.size()):
				for y in range(moves[x].size()):
					var tmpX = piece.x
					var tmpY = piece.y
					piece.x = moves[x][y].x
					piece.y = moves[x][y].y
					if (!is_player_in_check(player_node.player_turn)):
						print(piece.toString())
						piece.x = tmpX
						piece.y = tmpY
						return false
					piece.x = tmpX
					piece.y = tmpY
		return true
	return false

func _create_pieces():
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
	
	for i in range(32):
		piece_list[i].captured = false
	
