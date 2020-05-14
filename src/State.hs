module State where

import           Control.Applicative
import qualified ExprDef                       as ED
import qualified Data.Map                      as M

data State a = MkSM (M.Map ED.Expr ED.Expr -> [(M.Map ED.Expr ED.Expr, a)])

unSM :: State a -> (M.Map ED.Expr ED.Expr -> [(M.Map ED.Expr ED.Expr, a)])
unSM (MkSM f) = f

class (Monad m, Alternative m) => StateMonad m where
    get :: ED.Expr -> m ED.Expr
    set :: ED.Expr -> ED.Expr -> m ()

instance StateMonad State where
    get x = MkSM
        (\m ->
            let res = M.lookup x m
            in  case res of
                    (Just expr) -> [(m, expr)]
                    Nothing     -> error "variable not found"
        )
    set x v = MkSM (\m -> [(M.insert x v m, ())])

instance Monad State where
    return a = MkSM (\s -> [(s, a)])
    MkSM f >>= k = MkSM (\s0 -> f s0 >>= bind)
        where bind (s1, a) = unSM (k a) s1

instance Applicative State where
    pure = return
    p <*> q = p >>= \f -> q >>= \a -> return (f a)

instance Functor State where
    fmap f p = p >>= \a -> return (f a)

instance Alternative State where
    empty = MkSM (\s -> [])
    MkSM f <|> MkSM g = MkSM (\a -> concat [f a, g a])
