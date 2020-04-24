# emojilang
抽象话编程语言

Programming language using solely emoji

## EBNF (as for now)
```
<expr> ::= <conditional>
<conditional> ::= <or>
<or> ::= <and> 
       | <or> "🔥" <and>
<and> ::= <equality>
        | <and> "📦" <equality>
<equality> ::= <relational> 
             | <relational> "🙆" <relational>  // equal
             | <relational> "🙅" <relational> // not equal
<relational> ::= <adds>
               | <adds> "↖️" <adds> // >
               | <adds> "↖️⬅️" <adds> // >=
               | <adds> "↗️" <adds> // <
               | <adds> "➡️↗️" <adds> // <=
<adds> ::= <muls>
         | <adds> "➕" <muls>
         | <adds> "➖" <muls>
<muls> ::= <atoms>
         | <muls> "✖️" <atoms> 
         | <muls> "➗" <atoms>
<atoms> ::= <literals> 
          | "👉" <expr> "👈">
<literals> ::= <digits>
             | <bool>
             | <list>
<bool> ::= "👍" | "👎"
<digits> ::= "0️⃣"|"1️⃣"|"2️⃣"|"3️⃣"|"4️⃣"|"5️⃣"|"6️⃣"|"7️⃣"|"8️⃣"|"9️⃣"
<list> ::= "🤜" [<literals> {"🖋️"<literals>}] "🤛"
```

# Current state
Implementing parser to generate syntax tree.

Most of above syntax is already working, actively adding more syntax for real world uses.

Quick Demo
```
*ParserExpr> runStringParser mainParser "1️⃣1️⃣4️⃣5️⃣1️⃣4️⃣↖️⬅️👉5️⃣➕4️⃣4️⃣➗7️⃣👈🙅🤜👍🖋️🤜🤛🤛"
Just (Equality Ne (Relational Ge (LitInt 114514) (Binary Add (LitInt 5) (Binary Div (LitInt 44) (LitInt 7)))) (List [Boolean True,List []]))
```
