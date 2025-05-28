import chess_bot/board
import chess_bot/piece
import gleam/int
import gleam/option.{type Option}
import gleam/result
import gleam/string

pub type ParseError {
  InvalidColour
  InvalidFenString
  Piece(piece.ParseError)
  NotInt(String)
}

pub type Game {
  Model(
    colour_to_move: piece.Colour,
    board: board.Board,
    en_passant: Option(String),
    castle: Option(String),
    half_moves: Int,
    moves: Int,
  )
}

pub fn empty_game() {
  Model(piece.White, board.make_empty_board(), option.None, option.None, 0, 1)
}

pub fn set_colour(game, colour) {
  Model(..game, colour_to_move: colour)
}

pub fn set_board(game, board) {
  Model(..game, board:)
}

pub fn set_en_passant(game, en_passant) {
  Model(..game, en_passant:)
}

pub fn set_castle(game, castle) {
  Model(..game, castle:)
}

pub fn set_half_moves(game, half_moves) {
  Model(..game, half_moves:)
}

pub fn set_moves(game, moves) {
  Model(..game, moves:)
}

pub fn from_fen(fen) {
  case string.split(fen, " ") {
    [
      fen_board,
      fen_to_move,
      fen_castle,
      fen_en_passant,
      fen_half_move,
      fen_moves,
    ] -> {
      use board <- result.try(
        board.from_fen(fen_board) |> result.map_error(Piece),
      )
      use colour_to_move <- result.try(from_fen_to_move(fen_to_move))
      let castle = dash_to_none(fen_castle)
      let en_passant = dash_to_none(fen_en_passant)
      use half_moves <- result.try(
        int.parse(fen_half_move) |> result.replace_error(NotInt(fen_half_move)),
      )
      use moves <- result.map(
        int.parse(fen_moves) |> result.replace_error(NotInt(fen_moves)),
      )

      Model(colour_to_move:, board:, castle:, en_passant:, half_moves:, moves:)
    }
    _otherwise -> Error(InvalidFenString)
  }
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
    _ -> Error(InvalidColour)
  }
}
