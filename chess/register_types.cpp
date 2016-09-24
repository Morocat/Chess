#include "register_types.h"
#include "core/object_type_db.h"

#include "chess_board.h"

void register_chess_types() {
	ObjectTypeDB::register_type<ChessBoard>();
}

void unregister_chess_types() {
   //nothing to do here
}