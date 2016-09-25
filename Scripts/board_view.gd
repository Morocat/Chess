extends Sprite

const Board = preload("res://Scripts/board.gd")
const Piece = preload("res://Scripts/piece.gd").Piece
const Common = preload("res://common_lib.gd")

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

const BOARD_WIDTH = 800
const BOARD_HEIGHT = 800

const MOVE_SPEED = 500
const MOVE_RES = 5

var tile_rect_map = Array()
var tile_rect_map_scaled = Array()
var sprite_list = Array()
var body_list = Array()

var tile_size
var tile_size_scaled

var update_pieces = false
var display_moves = false
var clear_moves = false
var movesVect

var piece_speed = Array()

func _ready():
	var screen_rect = get_viewport().get_rect().size
	var board_rect = get_item_rect().size
	tile_size = Vector2(board_rect.width / 8, board_rect.height / 8) # 100x75
	tile_size_scaled = Vector2(screen_rect.width / 8, screen_rect.height / 8)
	for x in range(8):
		tile_rect_map.append([])
		tile_rect_map[x].resize(8)
		tile_rect_map_scaled.append([])
		tile_rect_map_scaled[x].resize(8)
		for y in range(8):
			tile_rect_map[x][y] = Rect2(BOARD_WIDTH / 8 * x, BOARD_HEIGHT / 8 * y, BOARD_WIDTH / 8, BOARD_HEIGHT / 8)
			tile_rect_map_scaled[x][y] = Rect2(tile_size_scaled.x * x, tile_size_scaled.y * y, tile_size_scaled.x, tile_size_scaled.y)
	set_scale(Vector2(screen_rect.width / board_rect.width, screen_rect.height / board_rect.height))
	set_pos(Vector2(0, 0))
	set_fixed_process(true)

func _fixed_process(delta):
	for i in range(Board.piece_list.size()):
		var piece = Board.piece_list[i]
		var body_pos = body_list[i].get_pos()
		var view_pos = tile_rect_map_scaled[piece.x][piece.y].pos

		if (body_pos.x != view_pos.x || body_pos.y != view_pos.y):
			# if the body is close enough, set position and stop movement
			if (Common.is_in_range(body_pos.x, view_pos.x, MOVE_RES) && Common.is_in_range(body_pos.y, view_pos.y, MOVE_RES)):
				body_list[i].set_pos(view_pos)
				piece_speed[i] = Vector2(0, 0)
				body_list[i].set_linear_velocity(piece_speed[i])
				for j in range(Board.piece_list.size()):
					var p = Board.piece_list[j]
					if (p.captured):
						sprite_list[j].hide()
						continue
					else:
						sprite_list[j].show()
				continue
			
			if (piece_speed[i].x == 0 && piece_speed[i].y == 0):
				var x = view_pos.x - body_pos.x
				var y = view_pos.y - body_pos.y
				var h = sqrt( pow(x, 2) + pow(y, 2) )
				
				var dx = lerp(0, 1, x / h)
				var dy = lerp(0, 1, y / h)
				piece_speed[i].x = dx * MOVE_SPEED
				piece_speed[i].y = dy * MOVE_SPEED
			body_list[i].set_linear_velocity(piece_speed[i])

func setup_sprites(root):
	var view = root.get_node("board_control/Viewport")
	for i in range(32):
		piece_speed.append(Vector2(0, 0))
		
		body_list.append(RigidBody2D.new())
		view.add_child(body_list[i])
		#body_list[i].set_owner(view)
		
		sprite_list.append(Sprite.new())
		body_list[i].add_child(sprite_list[i])
		#sprite_list[i].set_owner(body_list[i])
		var x = Board.piece_list[i].x
		var y = Board.piece_list[i].y
		body_list[i].set_pos(Vector2(tile_rect_map_scaled[x][y].pos.x, tile_rect_map_scaled[x][y].pos.y))

func display_moves(mvsV):
	display_moves = true
	movesVect = mvsV
	update()

func clear_moves():
	clear_moves = true
	update()

func display_pieces():
	update_pieces = true
	update()

func get_board_square(coord):
	return Vector2(floor(coord.x / tile_size_scaled.x), floor(coord.y / tile_size_scaled.y))

func _on_board_draw():
	if (update_pieces):
		show_pieces()
		update_pieces = false
	if (display_moves):
		show_moves()
		display_moves = false
	if (clear_moves):
		hide_moves()
		clear_moves = false

func show_moves():
	for i in range(movesVect.size()):
		for j in range(movesVect[i].size()):
			var rect = tile_rect_map[movesVect[i][j].x][movesVect[i][j].y]
			draw_rect(rect, Color(0, 0, 2, .3))

func hide_moves():
	draw_rect(Rect2(0, 0, 0, 0), Color(0, 0, 0, 0))

func show_pieces():
	var root = get_tree().get_current_scene()
	for i in range(Board.piece_list.size()):
		var piece = Board.piece_list[i]
		var spr = sprite_list[i]
		var x = piece.x
		var y = piece.y
		spr.set_centered(false)
		spr.set_scale(Vector2(tile_rect_map_scaled[x][y].size.width / 100, tile_rect_map_scaled[x][y].size.height / 100))
		spr.set_texture(get_piece_img(piece.type, piece.color))

static func get_piece_img(type, color):
	if (type == Piece.PAWN):
		if (color == Piece.WHITE):
			return PAWN_WHITE_IMG
		else:
			return PAWN_BLACK_IMG
	elif (type == Piece.BISHOP):
		if (color == Piece.WHITE):
			return BISHOP_WHITE_IMG
		else:
			return BISHOP_BLACK_IMG
	elif (type == Piece.KNIGHT):
		if (color == Piece.WHITE):
			return KNIGHT_WHITE_IMG
		else:
			return KNIGHT_BLACK_IMG
	elif (type == Piece.ROOK):
		if (color == Piece.WHITE):
			return ROOK_WHITE_IMG
		else:
			return ROOK_BLACK_IMG
	elif (type == Piece.QUEEN):
		if (color == Piece.WHITE):
			return QUEEN_WHITE_IMG
		else:
			return QUEEN_BLACK_IMG
	elif (type == Piece.KING):
		if (color == Piece.WHITE):
			return KING_WHITE_IMG
		else:
			return KING_BLACK_IMG