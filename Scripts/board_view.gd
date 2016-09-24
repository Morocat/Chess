extends Sprite

const Board = preload("res://Scripts/board.gd")
const Piece = preload("res://Scripts/piece.gd").Piece

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

var tile_rect_map = Array()
var tile_rect_map_scaled = Array()
var sprite_list = Array()

var tile_size
var tile_size_scaled

var update_pieces = false
var display_moves = false
var clear_moves = false
var movesVect

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

func setup_sprites(root):
	#var root = get_tree().get_current_scene()
	for i in range(32):
		sprite_list.append(Sprite.new())
		root.add_child(sprite_list[i])
		sprite_list[i].set_owner(root)

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
		if (piece.captured):
			spr.hide()
			continue
		var x = piece.x
		var y = piece.y
		spr.set_centered(false)
		spr.set_pos(Vector2(tile_rect_map_scaled[x][y].pos.x, tile_rect_map_scaled[x][y].pos.y))
		spr.set_scale(Vector2(tile_rect_map_scaled[x][y].size.width / 100, tile_rect_map_scaled[x][y].size.height / 100))
		if (piece.type == Piece.PAWN):
			if (piece.color == Piece.WHITE):
				spr.set_texture(PAWN_WHITE_IMG)
			else:
				spr.set_texture(PAWN_BLACK_IMG)
		if (piece.type == Piece.BISHOP):
			if (piece.color == Piece.WHITE):
				spr.set_texture(BISHOP_WHITE_IMG)
			else:
				spr.set_texture(BISHOP_BLACK_IMG)
		if (piece.type == Piece.KNIGHT):
			if (piece.color == Piece.WHITE):
				spr.set_texture(KNIGHT_WHITE_IMG)
			else:
				spr.set_texture(KNIGHT_BLACK_IMG)
		if (piece.type == Piece.ROOK):
			if (piece.color == Piece.WHITE):
				spr.set_texture(ROOK_WHITE_IMG)
			else:
				spr.set_texture(ROOK_BLACK_IMG)
		if (piece.type == Piece.QUEEN):
			if (piece.color == Piece.WHITE):
				spr.set_texture(QUEEN_WHITE_IMG)
			else:
				spr.set_texture(QUEEN_BLACK_IMG)
		if (piece.type == Piece.KING):
			if (piece.color == Piece.WHITE):
				spr.set_texture(KING_WHITE_IMG)
			else:
				spr.set_texture(KING_BLACK_IMG)