# emojilang
抽象话编程语言

Programming language using solely emoji

## EBNF (as for now)
<expr> ::= <adds>
<adds> ::= <muls> {("➕" | "➖") <muls>}
<muls> ::= <atom> {("✖️" | "➗") <atom>}
<atom> ::= <bool> | <digit> | "🤜" <expr> "🤛">
<bool> ::= "👍" | "👎"
<digit> ::= "0️⃣"|"1️⃣"|"2️⃣"|"3️⃣"|"4️⃣"|"5️⃣"|"6️⃣"|"7️⃣"|"8️⃣"|"9️⃣"