import chess_bot/piece
import gleam/option
import glearray

pub const size = 8

pub type Board =
  glearray.Array(String)

pub type Square =
  option.Option(piece.Piece)
