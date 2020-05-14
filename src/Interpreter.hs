module Interpreter where

import           State
import qualified StmtDef                       as SD
import qualified ExprDef                       as ED
import qualified Data.Map                      as M
import Control.Monad

run :: SD.Stmt -> M.Map ED.Var ED.Expr -> [M.Map ED.Var ED.Expr]
run stmt s0 = map fst (unSM (interp stmt) s0)

runFresh :: Maybe SD.Stmt -> [M.Map ED.Var ED.Expr]
runFresh (Just stmt) = run stmt M.empty

eval :: StateMonad m => ED.Expr -> m ED.Expr
eval (ED.Identifier var) = get var

interp :: (StateMonad m) => SD.Stmt -> m ()
interp (SD.ExprStmt (ED.Assignment k v)) = set k v
interp (SD.ExprStmt expr) = do
                                e <- eval expr
                                return ()
interp (SD.Statements stmts) = run stmts
    where
        run [] = return ()
        run [s] = interp s
        run (s:xs) = interp s *> run xs
