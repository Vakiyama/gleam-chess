pub type Piece {
  Piece(colour: Colour, kind: Kind)
}

pub type Colour {
  White
  Black
}

pub type Kind {
  King
  Queen
  Bishop
  Knight
  Rook
  Pawn
}

pub type ParseError {
  InvalidPiece(String)
}

pub fn fen_char_to_piece(fen_char) {
  case fen_char {
    "K" -> Ok(Piece(White, King))
    "Q" -> Ok(Piece(White, Queen))
    "B" -> Ok(Piece(White, Bishop))
    "N" -> Ok(Piece(White, Knight))
    "R" -> Ok(Piece(White, Rook))
    "P" -> Ok(Piece(White, Pawn))
    "k" -> Ok(Piece(Black, King))
    "q" -> Ok(Piece(Black, Queen))
    "b" -> Ok(Piece(Black, Bishop))
    "n" -> Ok(Piece(Black, Knight))
    "r" -> Ok(Piece(Black, Rook))
    "p" -> Ok(Piece(Black, Pawn))
    _otherwise -> Error(InvalidPiece(fen_char))
  }
}
