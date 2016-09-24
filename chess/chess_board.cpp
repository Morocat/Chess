#include "chess_board.h"

#include <iostream>

ChessBoard::ChessBoard() {

	createPieces();
	resetPieces();
	updateBoardState();
}

Piece* (*ChessBoard::getBoardState())[8] {
	return boardState;
}

Piece ChessBoard::getPiece(int x, int y) {
	return *boardState[x][y];
}

void ChessBoard::_bind_methods() {
	ObjectTypeDB::bind_method("get_piece", &ChessBoard::getPiece);
}

void ChessBoard::clearBoardState() {
	for (char i = 0; i < 8; i++)
		for (char j = 0; j < 8; j++)
			boardState[i][j] = 0;
}

void ChessBoard::updateBoardState() {
	clearBoardState();
	for (char i = 0; i < 32; i++)
		boardState[pieceList[i]->x][pieceList[i]->y] = pieceList[i];
}

void ChessBoard::createPieces() {
	for (char c = 0; c < 17; c += 16)
		for (char i = 0; i < 8; i++) {
			pieceList[i + c] = new Pawn;
		}
	for (char c = 0; c < 17; c += 16)
		for (char i = 8; i < 10; i++) {
			pieceList[i + c] = new Bishop;
		}
	for (char c = 0; c < 17; c += 16)
		for (char i = 10; i < 12; i++) {
			pieceList[i + c] = new Knight;
		}
	for (char c = 0; c < 17; c += 16)
		for (char i = 12; i < 14; i++) {
			pieceList[i + c] = new Rook;
		}
	for (char c = 14; c < 32; c += 16) {
		pieceList[c] = new Queen;
		pieceList[c + 1] = new King;
	}
	for (char i = 0; i < 32; i++) {
		if (i < 16)
			pieceList[i]->color = Piece::WHITE;
		else
			pieceList[i]->color = Piece::BLACK;
	}
}

void ChessBoard::resetPieces() {
	char i, j;

	// pawns
	for (j = 0; j < 17; j += 16)
		for (i = 0; i < 8; i++)
			pieceList[i + j]->x = i;

	for (i = 0; i < 17; i += 16) {
		// bishops
		pieceList[8 + i]->x = 2;
		pieceList[9 + i]->x = 5;

		// knights
		pieceList[10 + i]->x = 1;
		pieceList[11 + i]->x = 6;

		// rooks
		pieceList[12 + i]->x = 0;
		pieceList[13 + i]->x = 7;

		// king/queen
		pieceList[14 + i]->x = 3;
		pieceList[15 + i]->x = 4;
	}
	// White
	for (i = 0; i < 8; i++)
		pieceList[i]->y = 6;
	for (i = 8; i < 16; i++)
		pieceList[i]->y = 7;

	//Black
	for (i = 16; i < 24; i++)
		pieceList[i]->y = 1;
	for (i = 24; i < 32; i++)
		pieceList[i]->y = 0;

	for (i = 0; i < 32; i++)
		if (i < 16)
			pieceList[i]->color = Piece::WHITE;
		else
			pieceList[i]->color = Piece::BLACK;
}