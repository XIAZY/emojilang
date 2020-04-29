module StmtParser where

import           StmtDef
import qualified ParserExpr                    as PE
import           ParserLib

import           Control.Applicative
import qualified Data.Text                     as T


stmt :: Parser Stmt
stmt = simple <|> compound

simple :: Parser Stmt
simple = fmap ExprStmt (statements PE.expr (charToken (T.pack "😎")))

compound :: Parser Stmt
compound = ifStmt

ifStmt :: Parser Stmt
ifStmt =
    (ifs >>= \i@(If c s _) -> elses >>= \e -> return (If c s (Just e))) <|> ifs

ifs :: Parser Stmt
ifs =
    (do
            charToken (T.pack "🤔")
            c <- PE.conditional
            openBlock
            s <- stmt
            closeBlock
            return (If c s Nothing)
        )
        <|> (do
                c <- PE.conditional
                charToken (T.pack "🐴")
                openBlock
                s <- stmt
                closeBlock
                return (If c s Nothing)
            )

elses :: Parser Stmt
elses =
    do
        charToken (T.pack "😱")
        openBlock
        e <- stmt
        closeBlock
        return e
