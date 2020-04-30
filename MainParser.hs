module MainParser where

import qualified StmtParser as SP
import qualified StmtDef as SD
import ParserLib

mainParser :: Parser SD.Stmt
mainParser = whitespaces *> SP.stmts <* eof