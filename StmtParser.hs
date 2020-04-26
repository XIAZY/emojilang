module StmtParser where

import           StmtDef
import qualified ParserExpr as PE
import           ParserLib

import           Control.Applicative
import qualified Data.Text                     as T


stmt :: Parser Stmt
stmt = simple <|> compound

simple :: Parser Stmt
simple = fmap ExprStmt (statements PE.expr (operator [T.pack "😎"]))

compound :: Parser Stmt
compound = ifStmt

ifStmt :: Parser Stmt
ifStmt = (do
            charToken (T.pack "🤔")
            e <- PE.conditional 
            openBlock
            s <- stmt
            closeBlock
            return (If e s)
         ) <|> (do
             e <- PE.conditional
             charToken (T.pack "🐴")
             openBlock 
             s <- stmt
             closeBlock 
             return (If e s))