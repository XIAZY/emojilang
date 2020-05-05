module Main where

import Control.Monad
import qualified StmtParser as SP
import qualified StmtDef as SD
import ParserLib

mainParser :: Parser SD.Stmt
mainParser = whitespaces *> SP.stmts <* eof

main = do
    input <- getContents 
    putStr (show (runStringParser mainParser input))