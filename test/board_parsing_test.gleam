import chess_bot/board
import chess_bot/game
import chess_bot/piece
import gleam/option
import glearray
import gleeunit/should

pub fn parse_empty_game_board_test() {
  let empty_board = glearray.new() |> board.push_num(option.None, 64)

  game.from_fen("8/8/8/8/8/8/8/8 w - - 0 1")
  |> should.equal(
    Ok(game.Model(piece.White, empty_board, option.None, option.None, 0, 1)),
  )
}

pub fn parse_pieces_test() {
  let board_with_white_pawn =
    glearray.new()
    |> glearray.copy_push(option.Some(piece.Piece(piece.White, piece.Pawn)))
    |> board.push_num(option.None, 63)

  game.from_fen("P7/8/8/8/8/8/8/8 w - - 0 1")
  |> should.equal(
    Ok(game.Model(
      piece.White,
      board_with_white_pawn,
      option.None,
      option.None,
      0,
      1,
    )),
  )

  let board_with_black_pawn =
    glearray.new()
    |> glearray.copy_push(option.Some(piece.Piece(piece.Black, piece.Pawn)))
    |> board.push_num(option.None, 63)

  game.from_fen("p7/8/8/8/8/8/8/8 w - - 0 1")
  |> should.equal(
    Ok(game.Model(
      piece.White,
      board_with_black_pawn,
      option.None,
      option.None,
      0,
      1,
    )),
  )

  game.from_fen("8/8/8/8/8/8/8/8 w - - 0 1")
  |> should.not_equal(
    Ok(game.Model(
      piece.White,
      board_with_black_pawn,
      option.None,
      option.None,
      0,
      1,
    )),
  )
}

pub fn parse_color_test() {
  let empty_board = glearray.new() |> board.push_num(option.None, 64)

  game.from_fen("8/8/8/8/8/8/8/8 b - - 0 1")
  |> should.equal(
    Ok(game.Model(piece.Black, empty_board, option.None, option.None, 0, 1)),
  )
}

pub fn parse_castle_test() {
  let empty_board = glearray.new() |> board.push_num(option.None, 64)

  game.from_fen("8/8/8/8/8/8/8/8 b KQkq - 0 1")
  |> should.equal(
    Ok(game.Model(
      piece.Black,
      empty_board,
      option.Some("KQkq"),
      option.None,
      0,
      1,
    )),
  )
}

pub fn parse_en_passant_test() {
  let empty_board = glearray.new() |> board.push_num(option.None, 64)

  game.from_fen("8/8/8/8/8/8/8/8 b - c6 0 1")
  |> should.equal(
    Ok(game.Model(
      piece.Black,
      empty_board,
      option.None,
      option.Some("c6"),
      0,
      1,
    )),
  )
}
