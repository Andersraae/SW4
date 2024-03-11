
(* The type of tokens. *)

type token = 
  | PLUS
  | LESS
  | INT of (int)
  | EOF

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val main: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)

val expr: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.expr)
