extends Node

func _ready():
	var board = get_node("logic/board")
	board._initialize()
	board._create_pieces()
	board._reset()
	get_node("board_control/Viewport/board_view").setup_sprites(self)
	get_node("board_control/Viewport/board_view").show_pieces()
	set_process(true)

func _process(delta):
	get_node("logic/player")._process_user_input()
	
	
