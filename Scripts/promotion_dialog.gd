extends PopupDialog

const Piece = preload("res://Scripts/piece.gd").Piece

const BISHOP_WHITE_IMG = preload("res://img/bishop_white.png")
const BISHOP_BLACK_IMG = preload("res://img/bishop_black.png")
const KNIGHT_WHITE_IMG = preload("res://img/knight_white.png")
const KNIGHT_BLACK_IMG = preload("res://img/knight_black.png")
const ROOK_WHITE_IMG = preload("res://img/rook_white.png")
const ROOK_BLACK_IMG = preload("res://img/rook_black.png")
const QUEEN_WHITE_IMG = preload("res://img/queen_white.png")
const QUEEN_BLACK_IMG = preload("res://img/queen_black.png")

var img_bishop
var img_knight
var img_rook
var img_queen

var bishop_rect
var knight_rect
var rook_rect
var queen_rect

var player_node
var color

func _ready():
	var root = get_tree().get_current_scene()
	player_node = root.get_node("logic/player")
	
	img_bishop = get_node("bishop")
	img_knight = get_node("knight")
	img_rook = get_node("rook")
	img_queen = get_node("queen")
	
	bishop_rect = Rect2(img_bishop.get_pos(), img_bishop.get_item_rect().size)
	knight_rect = Rect2(img_knight.get_pos(), img_knight.get_item_rect().size)
	rook_rect = Rect2(img_rook.get_pos(), img_rook.get_item_rect().size)
	queen_rect = Rect2(img_queen.get_pos(), img_queen.get_item_rect().size)
	set_process(false)

func _process(delta):
	if (Input.is_action_just_pressed("ui_select")):
		var mouse_pos = get_local_mouse_pos()
		if (bishop_rect.has_point(mouse_pos)):
			player_node.promote_pawn(Piece.BISHOP)
		elif (knight_rect.has_point(mouse_pos)):
			player_node.promote_pawn(Piece.KNIGHT)
		elif (rook_rect.has_point(mouse_pos)):
			player_node.promote_pawn(Piece.ROOK)
		elif (queen_rect.has_point(mouse_pos)):
			player_node.promote_pawn(Piece.QUEEN)

func set_color(color):
	self.color = color

func _on_promotion_dialog_about_to_show():
	if (color == Piece.WHITE):
		img_bishop.set_texture(BISHOP_WHITE_IMG)
		img_knight.set_texture(KNIGHT_WHITE_IMG)
		img_rook.set_texture(ROOK_WHITE_IMG)
		img_queen.set_texture(QUEEN_WHITE_IMG)
	else:
		img_bishop.set_texture(BISHOP_BLACK_IMG)
		img_knight.set_texture(KNIGHT_BLACK_IMG)
		img_rook.set_texture(ROOK_BLACK_IMG)
		img_queen.set_texture(QUEEN_BLACK_IMG)

	set_process(true)

func _on_promotion_dialog_popup_hide():
	set_process(false)
