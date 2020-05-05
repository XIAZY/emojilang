module Main where

import           Control.Monad
import qualified StmtParser                    as SP
import qualified StmtDef                       as SD
import           ParserLib
import           System.Environment
import           System.IO

mainParser :: Parser SD.Stmt
mainParser = whitespaces *> SP.stmts <* eof

main = do
    (filepath : _) <- getArgs
    h              <- openFile filepath ReadMode
    hSetEncoding h utf8
    content <- hGetContents h
    print (runStringParser mainParser content)
