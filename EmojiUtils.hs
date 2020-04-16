module EmojiUtils where

import Data.Text
import Data.Text.ICU

-- emoji are quite complicated. they can take any number of unicode 
-- codepoints. use icu to break them

type Emoji = [Text]

getBreaks :: String -> [Break ()]
getBreaks input = breaks (breakCharacter Current) (pack input)

-- get emoji from string
getEmoji :: String -> Emoji
getEmoji input = Prelude.map brkBreak (getBreaks input)

length :: String -> Int
length input = Prelude.length (getBreaks input)