import chess_bot/board
import chess_bot/game
import chess_bot/piece
import gleam/option
import glearray
import gleeunit/should

pub fn parse_empty_game_board_test() {
  let empty_board = board.make_empty_board()

  game.from_fen("8/8/8/8/8/8/8/8 w - - 0 1")
  |> should.equal(
    Ok(game.Model(piece.White, empty_board, option.None, option.None, 0, 1)),
  )
}

pub fn insert_piece_test() {
  let empty_board = board.make_empty_board()
  let assert Ok(board_with_c6_queen) =
    board.set_piece_at_algebraic_coordinate(
      empty_board,
      piece.get_piece(piece.White, piece.Queen),
      "c6",
    )

  let assert Ok(board_with_c6_queen_from_fen) =
    game.from_fen("8/8/8/8/8/2Q5/8/8 w - - 0 1")

  glearray.length(board_with_c6_queen_from_fen.board) |> should.equal(64)

  glearray.length(board_with_c6_queen) |> should.equal(64)

  board_with_c6_queen_from_fen
  |> should.equal(game.Model(
    piece.White,
    board_with_c6_queen,
    option.None,
    option.None,
    0,
    1,
  ))
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

pub fn parse_colour_test() {
  let empty_board = board.make_empty_board()

  game.from_fen("8/8/8/8/8/8/8/8 b - - 0 1")
  |> should.equal(
    Ok(game.Model(piece.Black, empty_board, option.None, option.None, 0, 1)),
  )
}

pub fn parse_castle_test() {
  game.from_fen("8/8/8/8/8/8/8/8 w KQkq - 0 1")
  |> should.equal(Ok(
    game.empty_game()
    |> game.set_castle(option.Some("KQkq")),
  ))
}

pub fn parse_en_passant_test() {
  game.from_fen("8/8/8/8/8/8/8/8 b - c6 0 1")
  |> should.equal(Ok(
    game.empty_game()
    |> game.set_colour(piece.Black)
    |> game.set_en_passant(option.Some("c6")),
  ))
}
