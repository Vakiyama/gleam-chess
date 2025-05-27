import chess_bot/piece
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import glearray

pub const size = 8

pub type ParseError {
  InvalidFile(String)
  InvalidRankChar(String)
  InvalidRankInt(Int)
  InvalidAlgebraicCoordinate(String)
  NotInt(String)
  InsertBoardError(index: Int)
}

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

pub fn file_to_int(file_char) {
  case file_char {
    "a" -> Ok(0)
    "b" -> Ok(1)
    "c" -> Ok(2)
    "d" -> Ok(3)
    "e" -> Ok(4)
    "f" -> Ok(5)
    "g" -> Ok(6)
    "h" -> Ok(7)
    invalid -> Error(InvalidFile(invalid))
  }
}

/// chess notation is 1 indexed, this converts
/// to 0 index and also from a char
pub fn rank_char_to_int(rank_char) {
  use val <- result.map(
    int.parse(rank_char)
    |> result.replace_error(NotInt(rank_char)),
  )

  val - 1
}

pub fn rank_int_to_int(rank_int) {
  case rank_int < 9 && rank_int != 0 {
    True -> Ok(rank_int - 1)
    False -> Error(InvalidRankInt(rank_int))
  }
}

/// coordinate is a 2 char string such as "e2", "h8"
pub fn set_piece_at_algebraic_coordinate(board, piece, coordinate) {
  let coordinate_result = case string.length(coordinate) {
    2 -> Ok(coordinate)
    _ -> Error(InvalidAlgebraicCoordinate(coordinate))
  }

  use coordinate <- result.try(coordinate_result)
  let assert [file_char, rank_char] = string.split(coordinate, "")

  use file <- result.try(file_to_int(file_char))
  use rank <- result.try(rank_char_to_int(rank_char))
  let index = file + 8 * rank

  use board <- result.map(
    glearray.copy_set(board, index, piece)
    |> result.replace_error(InsertBoardError(index)),
  )
  board
}

pub fn make_empty_board() {
  glearray.new() |> push_num(option.None, 64)
}
