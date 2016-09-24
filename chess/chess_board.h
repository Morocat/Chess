#ifndef CHESS_BOARD_H_
#define CHESS_BOARD_H_

#include "scene/main/node.h"
#include "piece.h"
#include "core/object_type_db.h"
#include "settings.h"

#include <vector>
using namespace std;

class ChessBoard: public Node {
#if (DEBUG == 0)
OBJ_TYPE(ChessBoard, Node);
#endif

public:
	ChessBoard() ;
	~ChessBoard(){};
	Piece* (*getBoardState())[8];
	Piece getPiece(int x, int y);

	void updateBoardState();
	void resetPieces();

protected:
	static void _bind_methods();

private:

	Piece* boardState[8][8];
	Piece* pieceList[32];

	void createPieces();
	void clearBoardState();
};

#endif
