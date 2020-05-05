# emojilang
抽象话编程语言

Short version:
~~Toy~~ Programming language using solely emoji

Long version:
Most programming languages use English keywords. While it is true that English is the de-facto international language, it is an extra burden for programmers who don't speak English well.

Emojilang solves this problem! No matter what language you speak, we all use  the same Emoji to express ourselves. Everyone can code in Emojilang, even illiterate ones!

## EBNF (as for now)
```
<stmt> ::= <simple_stmt> | <compound_stmt>
<simple_stmt> ::= <expr_stmt>
<expr_stmt> ::= {<expr> "😎"}
<compound_stmt> ::= <if> | <while> | <func>
<if> ::= "🤔" <conditional> "⏬" <stmt> "⏫" ["😱" "⏬" <stmt> "⏫"]
       | <conditional> "🐴" "⏬" <stmt> "⏫" ["😱" "⏬" <stmt> "⏫"]
       // these two are absolutely the same. just here for internationalization!
<while> ::= "🔁" <conditional> "⏬" <stmt> "⏫"
<func> ::= "🔣" <identifier> "👉"[<identifier> {"🔨" <identifier>}] "👈" "⏬" <stmt> "⏫"

<expr> ::= <assignment>
<assignment> ::= <conditional>
               | <identifier> "️🖊️" <conditional>
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
<muls> ::= <unary>
         | <muls> "✖️" <unary> 
         | <muls> "➗" <unary>
<unary> ::= <postfix>
          | "➖" <unary>
<postfix> ::= <atoms>
            | <postfix> "👉" [<assignment> {"🔨"<assignment>}]  "👈"
<atoms> ::= <digits>
             | <bool>
             | <list>
             | <identifier>
             | "🔤" <string> "🔤" // escape symbol is "📌"
             | "👉" <expr> "👈"
<bool> ::= "👍" | "👎"
<digits> ::= "0️⃣"|"1️⃣"|"2️⃣"|"3️⃣"|"4️⃣"|"5️⃣"|"6️⃣"|"7️⃣"|"8️⃣"|"9️⃣"
<list> ::= "🤜" [<literals> {"🔨"<literals>}] "🤛" // yes it takes empty and nested list
```

# Current state
Implementing parser to generate syntax tree.

Most of the above syntax is already working, actively adding more syntax for real world uses.

Quick Demo
```
➜  emojilang git:(master) cat example.elang 
🔣🎅👉👈⏬🤔👉0️⃣🙆😀👈⏬😀🖊️➖➖1️⃣1️⃣4️⃣5️⃣1️⃣4️⃣😎😀↖️⬅️👉5️⃣➕4️⃣4️⃣➗7️⃣👈🙅🤜👍🔨🤜🤛🔨🔠📌📌📌🔡🖊️🤔🔨🤛📌🔠🔡🔨🔠🔡🤛😎⏫😱⏬🤔😄⏬🔁😄⏬😃😎⏫⏫😱⏬🤔😄⏬😃😎⏫⏫⏫⏫🎅👉👈😎
➜  emojilang git:(master) ghc MainParser.hs 
[1 of 7] Compiling EmojiUtils       ( EmojiUtils.hs, EmojiUtils.o )
[2 of 7] Compiling ExprDef          ( ExprDef.hs, ExprDef.o )
[3 of 7] Compiling ParserLib        ( ParserLib.hs, ParserLib.o )
[4 of 7] Compiling ParserExpr       ( ParserExpr.hs, ParserExpr.o )
[5 of 7] Compiling StmtDef          ( StmtDef.hs, StmtDef.o )
[6 of 7] Compiling StmtParser       ( StmtParser.hs, StmtParser.o )
[7 of 7] Compiling Main             ( MainParser.hs, MainParser.o )
Linking MainParser ...
➜  emojilang git:(master) ./MainParser example.elang 
Just (Statements [Func (Identifier ["\127877"]) [] (Statements [If (Equality Eq (Integer 0) (Identifier ["\128512"])) (Statements [ExprStmt (Assignment (Identifier ["\128512"]) (Unary Neg (Unary Neg (Integer 114514)))),ExprStmt (Equality Ne (Relational Ge (Identifier ["\128512"]) (Binary Add (Integer 5) (Binary Div (Integer 44) (Integer 7)))) (List [Boolean True,List [],String ["\128204","\128289","\128394\65039","\129300","\128296","\129307","\128288"],String []]))]) (Just (Statements [If (Identifier ["\128516"]) (Statements [While (Identifier ["\128516"]) (Statements [ExprStmt (Identifier ["\128515"])])]) (Just (Statements [If (Identifier ["\128516"]) (Statements [ExprStmt (Identifier ["\128515"])]) Nothing]))]))]),ExprStmt (Postfix (Identifier ["\127877"]) [])])
```
