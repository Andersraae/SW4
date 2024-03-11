(* ast.ml *)

(* Define the different node types in your AST *)
type expr =
  | Int of int
  | Add of expr * expr
  (* | Less of expr * expr *)
