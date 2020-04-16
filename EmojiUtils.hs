module EmojiUtils where

import Data.Text
import Data.Text.ICU

getBreaks :: String -> [Break ()]
getBreaks input = breaks (breakCharacter Current) (pack input)

getTexts :: String -> [Text]
getTexts input = Prelude.map brkBreak (getBreaks input)

length :: String -> Int
length input = Prelude.length (getBreaks input)