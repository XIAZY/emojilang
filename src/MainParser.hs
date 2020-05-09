module MainParser where

import           Control.Monad
import qualified StmtParser                    as SP
import qualified StmtDef                       as SD
import           ParserLib
import qualified EmojiUtils                    as EU
import qualified Data.Text                     as T

mainParser :: Parser SD.Stmt
mainParser = whitespaces *> SP.stmts <* eof

runStringParser :: Parser a -> String -> Maybe a
runStringParser p inputString = runParser p (EU.getEmoji inputString)

runParser :: Parser a -> [T.Text] -> Maybe a
runParser (MkParser sf) input = fmap snd (sf input)
