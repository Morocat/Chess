#ifndef PIECE_H_
#define PIECE_H_

#include "core/object_type_db.h"
#include "scene/main/node.h"
#include "settings.h"

class Piece: public Node {
#if (DEBUG == 0)
OBJ_TYPE(Piece, Node);
#endif
public:
	Piece(){
		captured = false;
	}
	~Piece(){}
	const static char WHITE = 0;
	const static char BLACK = 1;

	const static char PAWN = 0;
	const static char BISHOP = 1;
	const static char KNIGHT = 2;
	const static char ROOK = 3;
	const static char QUEEN = 4;
	const static char KING = 5;

	char color;

	// board coordinates
	char x, y;
	bool captured;

};

class King : public Piece {
	OBJ_TYPE(King, Piece);
public:
	King(){}
	~King(){}
};

class Queen : public Piece {
	OBJ_TYPE(Queen, Piece);
public:
	Queen(){}
	~Queen(){}
};

class Rook : public Piece {
	OBJ_TYPE(Rook, Piece);
public:
	Rook(){}
	~Rook(){}
};

class Knight : public Piece {
	OBJ_TYPE(Knight, Piece);
public:
	Knight(){}
	~Knight(){}
};

class Bishop : public Piece {
	OBJ_TYPE(Bishop, Piece);
public:
	Bishop(){}
	~Bishop(){}
};

class Pawn : public Piece {
	OBJ_TYPE(Pawn, Piece);
public:
	Pawn(){}
	~Pawn(){}
};

#endif /* PIECE_H_ */