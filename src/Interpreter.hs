module Interpreter where

import qualified StmtDef                       as SD
import qualified ExprDef                       as ED
import qualified Data.Map                      as M
import           Control.Monad
import           Control.Applicative            ( liftA2 )
import InterpValues as IV
import qualified Data.Text                     as T

-- TODO: this is so ugly! rewrite this and InterpValues.hs using monads

runFreshInterp :: Maybe SD.Stmt -> Maybe IV.Value
runFreshInterp (Just stmt) = retval where
  retval = val (interp stmt M.empty)
  val (IV.RetVal _ ret) = ret 
  

eval :: ED.Expr -> M.Map IV.Identifier IV.Value -> IV.Value
eval (ED.Identifier i)       clo = ret (M.lookup (IV.Identifier i) clo) where
  ret (Just a) = a
  ret Nothing = error "var not found"
eval (ED.Integer i) _ = IV.VInt i

eval (ED.Relational op e1 e2) closure = delegate v1 v2 where
  v1 = eval e1 closure
  v2 = eval e2 closure
  delegate (IV.VInt i1) (IV.VInt i2) = IV.VBool (relOp i1 i2)
  relOp = case op of
    ED.Lt -> (<)
    ED.Le -> (<=)
    ED.Gt -> (>)
    ED.Ge -> (>=)
  
eval (ED.Binary binOp e1 e2) closure = delegate v1 v2 where
  v1 = eval e1 closure
  v2 = eval e2 closure
  delegate (IV.VInt i1) (IV.VInt i2) = IV.VInt (intOp i1 i2)
  intOp = case binOp of
    ED.Add  -> (+)
    ED.Sub  -> (-)
    ED.Mult -> (*)
    ED.Div  -> div
  
eval (ED.Equality eqOp e1 e2) closure = delegate v1 v2
 where
  v1 = eval e1 closure
  v2 = eval e2 closure
  op = case eqOp of
    ED.Eq -> (==)
    _     -> (/=)
  delegate i1 i2 = IV.VBool (op i1 i2)

eval (ED.Postfix body indicies) closure = extractReturn (evalPostfix vFunc args closure) where
  args = map toVal indicies
  toVal index = eval index closure
  vFunc = eval body closure
  extractReturn (IV.RetVal _ (Just ret)) = ret
  evalPostfix (IV.VFunc params body) args clo = interp body newclo where
    newclo = substi params args closure
    substi [] [] clo = clo
    substi [param] [arg] clo = M.insert param arg clo
    substi (p:ps) (a:as) clo = next (substi [p] [a] clo) where
      next nextclo = substi ps as nextclo



interp :: SD.Stmt -> M.Map IV.Identifier IV.Value -> IV.RetVal
interp (SD.Return expr) closure = IV.RetVal closure (Just val) where
  val = eval expr closure
interp (SD.Statements stmts) closure = run stmts closure
 where
  run []       clo = RetVal clo Nothing
  run [s     ] clo = interp s clo
  run (r@(SD.Return s) : _) clo = run [r] clo
  run (s : xs) clo = next(run [s] clo)
    where
      next (IV.RetVal cloout _) = run xs cloout
      
interp (SD.ExprStmt (ED.Assignment (ED.Identifier k) v)) closure = 
  IV.RetVal (M.insert key val closure) Nothing
  where
    key = IV.Identifier k
    val = eval v closure

interp (SD.ExprStmt e) closure = IV.RetVal closure (Just (eval e closure))
interp (SD.Func name params stmts) closure = IV.RetVal (M.insert fname vfunc closure) Nothing where
  fname = toIVIdentifer name
  vfunc = IV.VFunc (map toIVIdentifer params) stmts

interp (SD.If cond todo elze) closure = run (eval cond closure) where
  run c = case c of
    IV.VBool True -> interp todo closure
    _               -> case elze of
      (Just s) -> interp s closure
      _        -> IV.RetVal closure Nothing

interp this@(SD.While cond todo) closure = run (eval cond closure) where
  run c = case c of
    IV.VBool True -> interp this (getclo (interp todo closure))
    _               -> IV.RetVal closure Nothing
  getclo (IV.RetVal clo _) = clo

toIVIdentifer :: ED.Expr -> IV.Identifier
toIVIdentifer (ED.Identifier i) = IV.Identifier i
toIVIdentifer _ = error "not an identifer"
