module Main where

import           MainParser
import           System.Environment
import           System.IO

main :: IO ()
main = do
    (filepath : _) <- getArgs
    h              <- openFile filepath ReadMode
    hSetEncoding h utf8
    content <- hGetContents h
    print (runStringParser mainParser content)
