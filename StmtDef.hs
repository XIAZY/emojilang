module StmtDef where

import qualified ExprDef as ED

data Stmt = ExprStmt [ED.Expr]
    deriving (Eq, Show)