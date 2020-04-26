# emojilang
抽象话编程语言

Short version:
~~Toy~~ Programming language using solely emoji

Long version:
Most programming languages use English keywords. While it is true that English is the de-facto international language, it is extra burden to programmers who don't speak English well.

Emojilang solves this problem! No matter what language you speak, we all use same Emoji to express ourselves. Everyone can code in Emojilang, even illiterate ones!

## EBNF (as for now)
```
<stmt> ::= <simple_stmt>>
<simple_stmt> ::= <expr_stmt>
<expr_stmt> ::= {<expr> "😎"}

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

Most of the above syntax is already working, actively adding more syntax for real world uses.

Quick Demo
```
*StmtParser> runStringParser stmt "😀🤏1️⃣1️⃣4️⃣5️⃣1️⃣4️⃣😎😀↖️⬅️👉5️⃣➕4️⃣4️⃣➗7️⃣👈🙅🤜👍🖋️🤜🤛🖋️😀🤛"
Just (ExprStmt [Assignment (Identifier ["\128512"]) (Integer 114514),Equality Ne (Relational Ge (Identifier ["\128512"]) (Binary Add (Integer 5) (Binary Div (Integer 44) (Integer 7)))) (List [Boolean True,List [],Identifier ["\128512"]])])
```
