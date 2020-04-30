module ParserExpr where

import           ExprDef
import           ParserLib

import           Control.Applicative
import qualified Data.Text                     as T

expr :: Parser Expr
expr = assignment

assignment :: Parser Expr
assignment = (do
    k <- identifiers
    charToken (T.pack "🖊️")
    Assignment k <$> conditional) <|> conditional

conditional :: Parser Expr
conditional = logicalOr

logicalOr :: Parser Expr
logicalOr = chainl1 operand op  where
    operand = logicalAnd
    op      = do
        charToken (T.pack "🔥")
        return (Conditional LogicalOr)

logicalAnd :: Parser Expr
logicalAnd = chainl1 operand op  where
    operand = equality
    op      = do
        charToken (T.pack "📦")
        return (Conditional LogicalAnd)

equality :: Parser Expr
equality =
    (do
            i <- relational
            charToken (T.pack "🙆")
            Equality Eq i <$> relational
        )
        <|> (do
                i <- relational
                charToken (T.pack "🙅")
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
literals = fmap Integer natural <|> fmap Boolean boolean <|> lists <|> identifiers <|> strings

identifiers :: Parser Expr
identifiers = fmap
    Identifier
    (ParserLib.identifier [])

lists :: Parser Expr
lists =
    (  openBracket
        *> fmap List (ParserLib.list literals (charToken (T.pack "🔨")))
        <* closeBracket
        )
        <|> (do
                openBracket
                closeBracket
                return (List [])
            )

strings :: Parser Expr
strings = do
            charToken (T.pack "🔠")
            s <- ParserLib.string
            charToken (T.pack "🔡")
            return (String s)