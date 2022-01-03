module Main where

import           MainParser
import           System.Environment
import           System.IO
import Interpreter

main :: IO ()
main = do
    (filepath : _) <- getArgs
    h              <- openFile filepath ReadMode
    hSetEncoding h utf8
    content <- hGetContents h
    print (Interpreter.runFreshInterp (runStringParser mainParser content))
