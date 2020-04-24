module ParserExpr where

import           ExprDef
import           ParserLib

import           Control.Applicative
import qualified Data.Text                     as T

mainParser :: Parser Expr
mainParser = whitespaces *> expr <* eof

expr :: Parser Expr
expr = conditional

conditional :: Parser Expr
conditional = logicalOr

logicalOr :: Parser Expr
logicalOr = chainl1 operand op  where
    operand = logicalAnd
    op =
        (do
            operator [T.pack "🔥"]
            return (Conditional LogicalOr)
        )

logicalAnd :: Parser Expr
logicalAnd = chainl1 operand op  where
    operand = equality
    op =
        (do
            operator [T.pack "📦"]
            return (Conditional LogicalAnd)
        )

equality :: Parser Expr
equality =
    (do
            i <- relational
            operator [T.pack "🙆"]
            Equality Eq i <$> relational
        )
        <|> (do
                i <- relational
                operator [T.pack "🙅"]
                Equality Ne i <$> relational
            )
        <|> relational

relational :: Parser Expr
relational =
    (do
            i <- adds
            operator [T.pack "↖️"]
            Relational Gt i <$> adds
        )
        <|> (do
                i <- adds
                operator [T.pack "↖️", T.pack "⬅️"]
                Relational Ge i <$> adds
            )
        <|> (do
                i <- adds
                operator [T.pack "↗️"]
                Relational Lt i <$> adds
            )
        <|> (do
                i <- adds
                operator [T.pack "➡️", T.pack "↗️"]
                Relational Le i <$> adds
            )
        <|> adds

adds :: Parser Expr
adds = chainl1 operand op  where
    operand = muls
    op =
        (do
                operator [T.pack "➕"]
                return (Binary Add)
            )
            <|> (do
                    operator [T.pack "➖"]
                    return (Binary Sub)
                )

muls :: Parser Expr
muls = chainl1 operand op  where
    operand = unary
    op =
        (do
                operator [T.pack "✖️"]
                return (Binary Mult)
            )
            <|> (do
                    operator [T.pack "➗"]
                    return (Binary Div)
                )

unary :: Parser Expr
unary =
    (do
            operator [T.pack "➖"]
            Unary Neg <$> unary
        )
        <|> atom

atom :: Parser Expr
atom = literals <|> (openParen *> expr <* closeParen)

literals :: Parser Expr
literals = fmap Integer natural 
            <|> fmap Boolean boolean 
            <|> list

list :: Parser Expr
list =
    (  openBracket
        *> fmap List (listL literals (operator [(T.pack "🖋️")]))
        <* closeBracket
        )
        <|> (do
                openBracket
                closeBracket
                return (List [])
            )
