type binop = Add | Mul

type expr = 
        | Const of int
        | Binop of binop * expr * expr

let rec expr_to_string e = match e with
        | Const c -> string_of_int c
        | Binop (Add, e1, e2) ->  "(" ^ expr_to_string e1 ^ " + " ^ expr_to_string e2 ^ ")"
        | Binop (Mul, e1, e2) ->  "(" ^ expr_to_string e1 ^ " * " ^ expr_to_string e2 ^ ")"

let rec interp e = match e with
        | Const c -> c
        | Binop (Add, e1, e2) -> interp e1 + interp e2
        | Binop (Mul, e1, e2) -> interp e1 * interp e2
        
let _ = print_string "I print \n"
let equation = Binop (Mul, Const 2, Binop (Add, Const 1, Const 1 ))
let _ = expr_to_string equation
let _ = print_string (expr_to_string equation)
let _ = print_string "\n"
let _ = print_string (string_of_int (interp equation))
