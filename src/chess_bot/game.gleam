import chess_bot/board
import chess_bot/piece
import gleam/int
import gleam/option.{type Option}
import gleam/result
import gleam/string

pub type ParseError {
  InvalidColor
  Piece(piece.ParseError)
  NotInt
}

pub type Game {
  Model(
    color_to_move: piece.Colour,
    board: board.Board,
    en_passant: Option(String),
    castle: Option(String),
    half_moves: Int,
    moves: Int,
  )
}

pub fn from_fen(fen) {
  let assert [
    fen_board,
    fen_to_move,
    fen_castle,
    fen_en_passant,
    fen_half_move,
    fen_moves,
  ] = string.split(fen, " ")

  use board <- result.try(board.from_fen(fen_board) |> result.map_error(Piece))
  use color <- result.try(from_fen_to_move(fen_to_move))
  let castle = dash_to_none(fen_castle)
  let en_passant = dash_to_none(fen_en_passant)
  use half_moves <- result.try(
    int.parse(fen_half_move) |> result.replace_error(NotInt),
  )
  use moves <- result.try(int.parse(fen_moves) |> result.replace_error(NotInt))

  Ok(Model(color, board, castle, en_passant, half_moves, moves))
}

fn dash_to_none(dash_or_string) {
  case dash_or_string {
    "-" -> option.None
    otherwise -> option.Some(otherwise)
  }
}

fn from_fen_to_move(fen_move) {
  case fen_move {
    "w" -> Ok(piece.White)
    "b" -> Ok(piece.Black)
    _ -> Error(InvalidColor)
  }
}
