import chess_bot/piece
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import glearray

pub const size = 8

pub type Board =
  glearray.Array(Square)

pub type Square =
  option.Option(piece.Piece)

pub fn from_fen(fen_board) {
  let board = glearray.new()

  string.replace(fen_board, "/", "")
  |> string.split("")
  |> list.try_fold(board, fen_char_to_square)
}

fn fen_char_to_square(board, fen_char) {
  result.map(int.parse(fen_char), fn(number) {
    push_num(board, option.None, number)
  })
  |> result.try_recover(fn(_) {
    piece.fen_char_to_piece(fen_char)
    |> result.map(fn(piece) { glearray.copy_push(board, option.Some(piece)) })
  })
}

pub fn push_num(array, item, number) {
  case number {
    0 -> array
    _ -> glearray.copy_push(array, item) |> push_num(item, number - 1)
  }
}
