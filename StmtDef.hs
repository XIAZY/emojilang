module StmtDef where

import qualified ExprDef as ED

data Stmt = ExprStmt [ED.Expr]
          | If ED.Expr Stmt (Maybe Stmt)
    deriving (Eq, Show)