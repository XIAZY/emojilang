# emojilang
抽象话编程语言

Programming language using solely emoji

## EBNF (as for now)
```
<expr> ::= <conditional>
<assignment> ::= <conditional>
               | <identifier> "🤏" <conditional>
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
<unary> ::= <atoms>
          | "➖" <atoms>
<atoms> ::= <literals> 
          | "👉" <expr> "👈">
<literals> ::= <digits>
             | <bool>
             | <list>
             | <identifier>
<bool> ::= "👍" | "👎"
<digits> ::= "0️⃣"|"1️⃣"|"2️⃣"|"3️⃣"|"4️⃣"|"5️⃣"|"6️⃣"|"7️⃣"|"8️⃣"|"9️⃣"
<list> ::= "🤜" [<literals> {"🖋️"<literals>}] "🤛" // yes it takes empty and nested list
```

# Current state
Implementing parser to generate syntax tree.

Most of above syntax is already working, actively adding more syntax for real world uses.

Quick Demo
```
*ParserExpr> runStringParser mainParser "1️⃣1️⃣4️⃣5️⃣1️⃣4️⃣↖️⬅️👉5️⃣➕4️⃣4️⃣➗7️⃣👈🙅🤜👍🖋️🤜🤛🖋️😀🤛"
Just (Equality Ne (Relational Ge (Integer 114514) (Binary Add (Integer 5) (Binary Div (Integer 44) (Integer 7)))) (List [Boolean True,List [],Identifier ["\128512"]]))
```
