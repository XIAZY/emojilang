module StmtDef where

import qualified ExprDef                       as ED

data Stmt = ExprStmt ED.Expr
          | If ED.Expr Stmt (Maybe Stmt)
          | While ED.Expr Stmt
          | Func ED.Expr [ED.Expr] Stmt
          | Statements [Stmt]
          | Return ED.Expr
    deriving (Eq, Show)
