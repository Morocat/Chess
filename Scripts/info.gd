extends Control

const Player = preload("res://Scripts/player.gd")
const Piece = preload("res://Scripts/piece.gd").Piece

var player_node
var board_node

# Child Nodes
var label_turn
var label_check

func _ready():
	var root = get_tree().get_current_scene()
	player_node = root.get_node("logic/player")
	board_node = root.get_node("logic/board")
	
	label_turn = get_node("Viewport/player_turn")
	label_turn.set_text("Player Turn: WHITE")
	label_check = get_node("Viewport/check_state")
	label_check.set_text("Check Label")
	pass

func _on_draw():
	if (player_node.player_turn == Piece.WHITE):
		label_turn.set_text("Player turn: WHITE")
	else:
		label_turn.set_text("Player turn: BLACK")
	
	if(player_node.player_white.in_checkmate):
		label_check.set_text("WHITE in checkmate!")
	elif(player_node.player_black.in_checkmate):
		label_check.set_text("BLACK in checkmate!")
	elif(player_node.player_white.in_check):
		label_check.set_text("WHITE in check!")
	elif(player_node.player_black.in_check):
		label_check.set_text("BLACK in check!")
	else:
		label_check.set_text("")
