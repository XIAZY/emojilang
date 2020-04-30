module StmtDef where

import qualified ExprDef as ED

data Stmt = ExprStmt [ED.Expr]
          | If ED.Expr Stmt (Maybe Stmt)
          | While ED.Expr Stmt
    deriving (Eq, Show)