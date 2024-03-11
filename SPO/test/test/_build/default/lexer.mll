{
open Parser
open Ast
}


rule token = parse
  | [' ' '\t']    { token lexbuf } (* Ignore white spaces *)
  | "+"           { PLUS }
  (* | "<"           { LESS } *)
  | ['0'-'9']+ as num { INT (int_of_string num) } (* Recognize integers *)
  | eof           { EOF }