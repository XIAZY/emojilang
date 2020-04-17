module ParserExpr where

import ExprDef
import ParserLib

import Control.Applicative
import qualified Data.Text as T

mainParser :: Parser Expr
mainParser = whitespaces *> expr <* eof

expr :: Parser Expr
expr = cmp

cmp :: Parser Expr
cmp = (do
        i <- adds
        operator [T.pack "👀"]
        j <- adds
        return (Cmp Eq i j)) <|> adds

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
atom = fmap LitInt natural
            <|> (openParen *> expr <* closeParen)