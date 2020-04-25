module StmtParser where

import           StmtDef
import qualified ParserExpr as PE
import           ParserLib

import           Control.Applicative
import qualified Data.Text                     as T


stmt :: Parser Stmt
stmt = fmap ExprStmt (listL PE.expr (operator [T.pack "😎"]))