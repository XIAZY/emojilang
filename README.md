# emojilang
抽象话编程语言

Programming language using solely emoji

## EBNF (as for now)
<expr> ::= <cmp>
<cmp> ::= <adds> "👀" <adds> | <adds>
<adds> ::= <muls> {("➕" | "➖") <muls>}
<muls> ::= <atom> {("✖️" | "➗") <atom>}
<atom> ::= <bool> | <digit> | "👉" <expr> "👈">
<bool> ::= "👍" | "👎"
<digit> ::= "0️⃣"|"1️⃣"|"2️⃣"|"3️⃣"|"4️⃣"|"5️⃣"|"6️⃣"|"7️⃣"|"8️⃣"|"9️⃣"

# Current state
Implementing parser to generate syntax tree.

Most of above syntax is already working, actively adding more syntax for real world uses.

Quick Demo
```
*ParserExpr> runStringParser mainParser "1️⃣1️⃣4️⃣5️⃣1️⃣4️⃣👀👉5️⃣ ➕4️⃣4️⃣➗7️⃣👈"
Just (Cmp Eq (LitInt 114514) (Binary Add (LitInt 5) (Binary Div (LitInt 44) (LitInt 7))))
```