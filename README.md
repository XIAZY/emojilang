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
➜  emojilang git:(master) ghc MainParser.hs 
[1 of 7] Compiling EmojiUtils       ( EmojiUtils.hs, EmojiUtils.o )
[2 of 7] Compiling ExprDef          ( ExprDef.hs, ExprDef.o )
[3 of 7] Compiling ParserLib        ( ParserLib.hs, ParserLib.o )
[4 of 7] Compiling ParserExpr       ( ParserExpr.hs, ParserExpr.o )
[5 of 7] Compiling StmtDef          ( StmtDef.hs, StmtDef.o )
[6 of 7] Compiling StmtParser       ( StmtParser.hs, StmtParser.o )
[7 of 7] Compiling Main             ( MainParser.hs, MainParser.o )
Linking MainParser ...

➜  emojilang git:(master) ./MainParser fibonacci.elang 
Just (Statements [Func (Identifier ["\127877"]) [Identifier ["#\65039\8419"]] (Statements [ExprStmt (Assignment (Identifier ["\128290","1\65039\8419"]) (Integer 0)),ExprStmt (Assignment (Identifier ["\128290","2\65039\8419"]) (Integer 1)),ExprStmt (Assignment (Identifier ["\128260"]) (Integer 2)),ExprStmt (Assignment (Identifier ["\128160"]) (Integer 1)),While (Relational Le (Identifier ["\128260"]) (Identifier ["#\65039\8419"])) (Statements [ExprStmt (Assignment (Identifier ["\128160"]) (Binary Add (Identifier ["\128290","1\65039\8419"]) (Identifier ["\128290","2\65039\8419"]))),ExprStmt (Assignment (Identifier ["\128290","1\65039\8419"]) (Identifier ["\128290","2\65039\8419"])),ExprStmt (Assignment (Identifier ["\128290","2\65039\8419"]) (Identifier ["\128160"]))])])])
```
