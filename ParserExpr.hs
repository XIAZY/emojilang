module ParserExpr where

import ExprDef
import ParserLib

import Control.Applicative
import qualified Data.Text as T

mainParser :: Parser Expr
mainParser = whitespaces *> expr <* eof

expr :: Parser Expr
expr = binary

binary :: Parser Expr
binary = chainl1 operand op where
    operand = unary
    op = (do
            operator [T.pack "➕"]
            return (Binary Add)
         ) <|> (do
            operator [T.pack "➖"]
            return (Binary Sub))

unary :: Parser Expr
unary = (do
            operator [T.pack "➖"]
            i <- unary
            return (Unary Neg i))
        <|> atom

atom :: Parser Expr
atom = fmap LitInt natural