module Interpreter where

import           State
import qualified StmtDef                       as SD
import qualified ExprDef                       as ED
import qualified Data.Map                      as M
import           Control.Monad
import           Control.Applicative            ( liftA2 )

runInterp :: SD.Stmt -> M.Map ED.Expr ED.Expr -> [M.Map ED.Expr ED.Expr]
runInterp stmt s0 = map fst (unSM (interp stmt) s0)

runFreshInterp :: Maybe SD.Stmt -> [M.Map ED.Expr ED.Expr]
runFreshInterp (Just stmt) = runInterp stmt M.empty

eval :: StateMonad m => ED.Expr -> m ED.Expr
eval var@(ED.Identifier _      ) = get var
eval (    ED.Binary binOp e1 e2) = liftA2 delegate v1 v2
 where
  v1 = eval e1
  v2 = eval e2
  delegate (ED.Integer i1) (ED.Integer i2) = ED.Integer (intOp i1 i2)
  -- technically we should use a monad here. but there are some technical difficulties
  -- turing Expr into a monad. Integer isnt the only constructor in it
  intOp = case binOp of
    ED.Add  -> (+)
    ED.Sub  -> (-)
    ED.Mult -> (*)
    ED.Div  -> div
eval a = return a

interp :: (StateMonad m) => SD.Stmt -> m ()
interp (SD.ExprStmt (ED.Assignment k v)) = eval v >>= set k
interp (SD.ExprStmt expr               ) = do
  e <- eval expr
  return ()
interp (SD.Statements stmts) = run stmts
 where
  run []       = return ()
  run [s     ] = interp s
  run (s : xs) = interp s *> run xs
