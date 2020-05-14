module ExprDef where

import qualified Data.Text                     as T

data Expr = Integer Integer
          | Binary BinaryOp Expr Expr
          | Unary UnaryOp Expr
          | Equality EqOp Expr Expr
          | Relational RelationOp Expr Expr
          | Conditional LogicalOp Expr Expr
          | Boolean Bool
          | List [Expr]
          | Identifier [T.Text]
          | Assignment Expr Expr
          | String [T.Text]
          | Postfix Expr [Expr]
    deriving (Eq, Show, Ord)

data BinaryOp = Add | Sub | Mult | Div
    deriving (Eq, Show, Ord)

data UnaryOp = Neg
    deriving (Eq, Show, Ord)

data EqOp = Eq | Ne
    deriving (Eq, Show, Ord)

data RelationOp = Lt | Le | Gt | Ge
    deriving (Eq, Show, Ord)

data LogicalOp = LogicalAnd | LogicalOr
    deriving (Eq, Show, Ord)
