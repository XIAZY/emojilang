module ParserExpr where

import ExprDef
import ParserLib

import Control.Applicative
import qualified Data.Text as T

mainParser :: Parser Expr
mainParser = whitespaces *> expr <* eof

expr :: Parser Expr
expr = conditional

conditional :: Parser Expr
conditional = logicalOr

logicalOr :: Parser Expr
logicalOr = chainl1 operand op where
    operand = logicalAnd 
    op = (do
        operator [T.pack "🔥"]
        return (Conditional LogicalOr))

logicalAnd :: Parser Expr
logicalAnd = chainl1 operand op where
    operand = equality
    op = (do
        operator [T.pack "📦"]
        return (Conditional LogicalAnd))

equality :: Parser Expr
equality = (do
        i <- relational
        operator [T.pack "🙆"]
        j <- relational
        return (Equality Eq i j)
      ) <|> (do
        i <- relational
        operator [T.pack "🙅"]
        j <- relational
        return (Equality Ne i j)
      ) <|> relational

relational :: Parser Expr
relational = (do
                i <- adds
                operator [T.pack "↖️"]
                j <- adds
                return (Relational Gt i j)
            ) <|> (do
                i <- adds
                operator [T.pack "↖️", T.pack "⬅️"]
                j <- adds
                return (Relational Ge i j)
            ) <|> (do
                i <- adds
                operator [T.pack "↗️"]
                j <- adds
                return (Relational Lt i j)
            ) <|> (do
                i <- adds
                operator [T.pack "➡️", T.pack "↗️"]
                j <- adds
                return (Relational Le i j)) <|> adds

adds :: Parser Expr
adds = chainl1 operand op where
    operand = muls
    op = (do
            operator [T.pack "➕"]
            return (Binary Add)
         ) <|> (do
            operator [T.pack "➖"]
            return (Binary Sub)
         )

muls :: Parser Expr
muls = chainl1 operand op where
    operand = unary
    op = (do
            operator [T.pack "✖️"]
            return (Binary Mult)
         ) <|> (do
             operator [T.pack "➗"]
             return (Binary Div)
         )

unary :: Parser Expr
unary = (do
            operator [T.pack "➖"]
            i <- unary
            return (Unary Neg i))
        <|> atom

atom :: Parser Expr
atom = literals
            <|> (openParen *> expr <* closeParen)

literals :: Parser Expr
literals = fmap LitInt natural
                <|> (openBracket *> list <* closeBracket)
                <|> fmap Boolean boolean
                
list :: Parser Expr
list = fmap List (listL atom (operator [(T.pack "🖋️")]))