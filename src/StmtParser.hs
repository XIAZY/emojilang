module StmtParser where

import           StmtDef
import qualified ParserExpr                    as PE
import           ParserLib

import           Control.Applicative
import qualified Data.Text                     as T

stmts :: Parser Stmt
stmts = fmap Statements (many stmt)

stmt :: Parser Stmt
stmt = simple <|> compound

simple :: Parser Stmt
simple =
    (do
            e <- PE.expr
            charToken (T.pack "😎")
            return (ExprStmt e)
        )
        <|> returnStmt

compound :: Parser Stmt
compound = ifStmt <|> whileStmt <|> funcStmt

returnStmt :: Parser Stmt
returnStmt = do
    charToken (T.pack "⤴️")
    ret <- PE.conditional
    charToken (T.pack "😎")
    return (Return ret)

ifStmt :: Parser Stmt
ifStmt =
    (ifs >>= \i@(If c s _) -> elses >>= \e -> return (If c s (Just e))) <|> ifs

ifs :: Parser Stmt
ifs =
    (do
            charToken (T.pack "🤔")
            c <- PE.conditional
            openBlock
            s <- stmts
            closeBlock
            return (If c s Nothing)
        )
        <|> (do
                c <- PE.conditional
                charToken (T.pack "🐴")
                openBlock
                s <- stmts
                closeBlock
                return (If c s Nothing)
            )

elses :: Parser Stmt
elses = do
    charToken (T.pack "😱")
    openBlock
    e <- stmts
    closeBlock
    return e

whileStmt :: Parser Stmt
whileStmt = do
    charToken (T.pack "🔁")
    c <- PE.conditional
    openBlock
    s <- stmts
    closeBlock
    return (While c s)

funcStmt :: Parser Stmt
funcStmt = do
    charToken (T.pack "🔣")
    c <- PE.identifiers
    charToken (T.pack "👉")
    p <- ParserLib.list PE.identifiers (charToken (T.pack "🔨"))
    charToken (T.pack "👈")
    openBlock
    s <- stmts
    closeBlock
    return (Func c p s)
