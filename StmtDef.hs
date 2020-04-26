module StmtDef where

import qualified ExprDef as ED

data Stmt = ExprStmt [ED.Expr]
          | If ED.Expr Stmt
          | Test ED.Expr
    deriving (Eq, Show)