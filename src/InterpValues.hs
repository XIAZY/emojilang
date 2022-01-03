module InterpValues where

import           Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import qualified Data.Text                     as T
import qualified StmtDef

data Identifier = Identifier [T.Text]
    deriving (Eq, Show, Ord)

data Value = VInt Integer
           | VBool Bool
           | VFunc [Identifier] StmtDef.Stmt
           deriving (Eq, Show)

data RetVal = RetVal (Map Identifier Value) (Maybe Value)
    deriving (Eq, Show)