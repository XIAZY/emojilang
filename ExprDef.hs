module ExprDef where

data Expr = LitInt Integer
          | Binary BinaryOp Expr Expr
          | Unary UnaryOp Expr
    deriving (Eq, Show)


data BinaryOp = Add | Sub | Mult | Div
    deriving (Eq, Show)

data UnaryOp = Neg
    deriving (Eq, Show)