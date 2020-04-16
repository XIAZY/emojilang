module EmojiUtils where

import Data.Text
import Data.Text.ICU

getBreaks :: String -> [Break ()]
getBreaks input = breaks (breakCharacter Current) (pack input)

length :: String -> Int
length input = Prelude.length (getBreaks input)