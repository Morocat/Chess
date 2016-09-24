
# Abstract class
class Piece:
	const WHITE = false
	const BLACK = true
	
	const PAWN = 0
	const BISHOP = 1
	const KNIGHT = 2
	const ROOK = 3
	const QUEEN = 4
	const KING = 5
	
	const VALID_MOVE = 1
	const INVALID_MOVE = 1
	
	var color
	var type
	
	# board coordinates
	var x
	var y
	
	var captured = false
	var hasMoved = false
	
	func toString():
		return str("Piece Type: ", type, "\nColor: ", color, "\nXY: ", x, ",", y, "\nCaptured: ", captured)

class King extends Piece:
	
	func _init(clr):
		type = KING
		color = clr
	
	func get_moves():
		var moves = Array()
		for i in range(9):
			moves.append([])
		moves[1].append(Vector2(x - 1, y))
		moves[2].append(Vector2(x - 1, y - 1))
		moves[3].append(Vector2(x, y - 1))
		moves[4].append(Vector2(x + 1, y - 1))
		moves[5].append(Vector2(x + 1, y))
		moves[6].append(Vector2(x + 1, y + 1))
		moves[7].append(Vector2(x, y + 1))
		moves[8].append(Vector2(x - 1, y + 1))
		moves[0].append(Vector2(x, y))
		return moves

class Queen extends Piece:
	func _init(clr):
		type = QUEEN
		color = clr
		
	func get_moves():
		var moves = Array()
		for i in range(9):
			moves.append([])
		for i in range(1, 8):
			# straight
			moves[1].append(Vector2(x - i, y))
			moves[2].append(Vector2(x, y - i))
			moves[3].append(Vector2(x + i, y))
			moves[4].append(Vector2(x, y + i))
			# diagonal
			moves[5].append(Vector2(x - i, y - i))
			moves[6].append(Vector2(x - i, y + i))
			moves[7].append(Vector2(x + i, y - i))
			moves[8].append(Vector2(x + i, y + i))
		moves[0].append(Vector2(x, y))
		return moves

class Rook extends Piece:
	func _init(clr):
		type = ROOK
		color = clr
		
	func get_moves():
		var moves = Array()
		for i in range(5):
			moves.append([])
		for i in range(1, 8):
			moves[1].append(Vector2(x - i, y))
			moves[2].append(Vector2(x, y - i))
			moves[3].append(Vector2(x + i, y))
			moves[4].append(Vector2(x, y + i))
		moves[0].append(Vector2(x, y))
		return moves

class Knight extends Piece:
	func _init(clr):
		type = KNIGHT
		color = clr
		
	func get_moves():
		var moves = Array()
		for i in range(9):
			moves.append([])
		moves[1].append(Vector2(x - 2, y + 1))
		moves[2].append(Vector2(x - 2, y - 1))
		moves[3].append(Vector2(x - 1, y - 2))
		moves[4].append(Vector2(x + 1, y - 2))
		moves[5].append(Vector2(x + 2, y - 1))
		moves[6].append(Vector2(x + 2, y + 1))
		moves[7].append(Vector2(x + 1, y + 2))
		moves[8].append(Vector2(x - 1, y + 2))
		moves[0].append(Vector2(x, y))
		return moves

class Bishop extends Piece:
	func _init(clr):
		type = BISHOP
		color = clr
	
	func get_moves():
		var moves = Array()
		for i in range(5):
			moves.append([])
		for i in range(1, 8):
			moves[1].append(Vector2(x - i, y - i))
			moves[2].append(Vector2(x - i, y + i))
			moves[3].append(Vector2(x + i, y - i))
			moves[4].append(Vector2(x + i, y + i))
		moves[0].append(Vector2(x, y))
		return moves

class Pawn extends Piece:
	
	func _init(clr):
		type = PAWN
		color = clr
		
	func get_moves():
		var moves = Array()
		for i in range(4):
			moves.append([])
		if (color == WHITE):
			moves[1].append(Vector2(x - 1, y - 1))
			moves[2].append(Vector2(x, y - 1))
			moves[3].append(Vector2(x + 1, y - 1))
			if (!hasMoved):
				moves[2].append(Vector2(x, y - 2))
		else:
			moves[1].append(Vector2(x - 1, y + 1))
			moves[2].append(Vector2(x, y + 1))
			moves[3].append(Vector2(x + 1, y + 1))
			if (!hasMoved):
				moves[2].append(Vector2(x, y + 2))
		moves[0].append(Vector2(x, y))
		return moves
