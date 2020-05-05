module Main where

import           Control.Monad
import qualified StmtParser                    as SP
import qualified StmtDef                       as SD
import           ParserLib
import           System.Environment

mainParser :: Parser SD.Stmt
mainParser = whitespaces *> SP.stmts <* eof

main = do
    (filepath:_) <- getArgs
    content <- readFile filepath
    putStr (show (runStringParser mainParser content))
