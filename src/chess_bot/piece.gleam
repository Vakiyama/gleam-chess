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
