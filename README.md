# emojilang
抽象话编程语言

Short version:

~~Toy~~ Programming language using solely emoji

Long version:

Most programming languages use English keywords. While it is true that English is the de-facto international language, it is an extra burden for programmers who don't speak English well.

Emojilang solves this problem! No matter what language you speak, we all use  the same Emoji to express ourselves. Everyone can code in Emojilang, even illiterate ones!

Emojilang is implemented using pure Haskell. We use the [Stack](https://github.com/commercialhaskell/stack) build tool for software engineering purposes, as it handles build process and package management elegantly.

Emojilang is licensed under MIT.

# OKRs
Emojilang is meant to be a dynamically typed language (at least for now). The short term goal is to implement its parser and interpreter.

If everything's successful, I would like to implement an LLVM IR generator or other cool things like running on WebAssembly as a long term goal. However it is still too early to think of these cool features and there are quite a few foreseeable technical challenges.

No compatibility is guaranteed.

## EBNF (as for now)
```
<stmt> ::= <simple_stmt> | <compound_stmt>
<simple_stmt> ::= <expr_stmt> | <return_stmt>
<expr_stmt> ::= {<expr> "😎"}
<compound_stmt> ::= <if> | <loop> | <func>
<return_stmt> ::= "⤴️" <conditional> "😎"
<if> ::= "🤔" <conditional> "⏬" <stmt> "⏫" ["😱" "⏬" <stmt> "⏫"]
       | <conditional> "🐴" "⏬" <stmt> "⏫" ["😱" "⏬" <stmt> "⏫"]
       // these two are absolutely the same. just here for internationalization!
<loop> ::= "🔁" <conditional> "⏬" <stmt> "⏫"
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
✔️ Implementing parser to generate syntax tree.
🏗️ Implementing interpreter to interpret the syntax tree

Most of the above syntax is already working, actively adding more syntax for real world uses.

Quick Demo
```
➜  emojilang git:(master) stack build
emojilang-0.1.0.0: unregistering (local file changes: README.md)
emojilang> configure (lib + exe)
Configuring emojilang-0.1.0.0...
emojilang> build (lib + exe)
Preprocessing library for emojilang-0.1.0.0..
Building library for emojilang-0.1.0.0..
Preprocessing executable 'emojilang-exe' for emojilang-0.1.0.0..
Building executable 'emojilang-exe' for emojilang-0.1.0.0..
emojilang> copy/register
Installing library in /Users/xia/Desktop/emojilang/.stack-work/install/x86_64-osx/b3d3d0865f1718b15b894e480712c20f16b1bb044abb42f8942327709b5e7176/8.8.3/lib/x86_64-osx-ghc-8.8.3/emojilang-0.1.0.0-I3SZgBakQf8BwhFOsUlvWI
Installing executable emojilang-exe in /Users/xia/Desktop/emojilang/.stack-work/install/x86_64-osx/b3d3d0865f1718b15b894e480712c20f16b1bb044abb42f8942327709b5e7176/8.8.3/bin
Registering library for emojilang-0.1.0.0..

➜  emojilang git:(master) stack exec emojilang-exe src/examples/fibonacci.elang
Just (Statements [Func (Identifier ["\129518"]) [Identifier ["\128290"]] (Statements [ExprStmt (Assignment (Identifier ["#\65039\8419","1\65039\8419"]) (Integer 0)),ExprStmt (Assignment (Identifier ["#\65039\8419","2\65039\8419"]) (Integer 1)),ExprStmt (Assignment (Identifier ["\128260"]) (Integer 2)),ExprStmt (Assignment (Identifier ["\128160"]) (Integer 1)),If (Equality Eq (Identifier ["\128290"]) (Integer 0)) (Statements [Return (Integer 0)]) Nothing,If (Equality Eq (Identifier ["\128290"]) (Integer 1)) (Statements [Return (Integer 1)]) Nothing,While (Relational Le (Identifier ["\128260"]) (Identifier ["\128290"])) (Statements [ExprStmt (Assignment (Identifier ["\128160"]) (Binary Add (Identifier ["#\65039\8419","1\65039\8419"]) (Identifier ["#\65039\8419","2\65039\8419"]))),ExprStmt (Assignment (Identifier ["#\65039\8419","1\65039\8419"]) (Identifier ["#\65039\8419","2\65039\8419"])),ExprStmt (Assignment (Identifier ["#\65039\8419","2\65039\8419"]) (Identifier ["\128160"]))]),Return (Identifier ["\128160"])]),ExprStmt (Postfix (Identifier ["\129518"]) [Integer 114514])])
```
