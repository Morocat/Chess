extends Node

var board

#flags
var reset = false

func _ready():
	board = get_node("logic/board")
	board._create_pieces()
	board._reset()
	get_node("board_control/Viewport/board_view").setup_sprites(self)
	get_node("board_control/Viewport/board_view").show_pieces()
	get_node("info_control").reset()
	set_process(true)

func _process(delta):
	get_node("logic/player")._process_user_input()
	
	if (reset):
		board._create_pieces()
		board._reset()
		get_node("logic/player").reset()
		get_node("board_control/Viewport/board_view").show_pieces()
		get_node("info_control").reset()
		reset = false
	
