module ExprDef where

data Expr = LitInt Integer
          | Binary BinaryOp Expr Expr
          | Unary UnaryOp Expr
          | Equality EqOp Expr Expr
          | Relational RelationOp Expr Expr
          | Conditional LogicalOp Expr Expr
          | Boolean Bool
    deriving (Eq, Show)

data BinaryOp = Add | Sub | Mult | Div
    deriving (Eq, Show)

data UnaryOp = Neg
    deriving (Eq, Show)

data EqOp = Eq | Ne
    deriving (Eq, Show)

data RelationOp = Lt | Le | Gt | Ge
    deriving (Eq, Show)

data LogicalOp = LogicalAnd | LogicalOr
    deriving (Eq, Show)
