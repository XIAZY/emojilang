module EmojiUtils where

import qualified Data.Text as Text
import qualified Data.Text.ICU as ICU

-- emoji are quite complicated. they can take any number of unicode 
-- codepoints. use icu to break them

type Emoji = [Text.Text]

getBreaks :: String -> [ICU.Break ()]
getBreaks input = ICU.breaks (ICU.breakCharacter ICU.Current) (Text.pack input)

-- get emoji from string
getEmoji :: String -> Emoji
getEmoji input = map ICU.brkBreak (getBreaks input)

length :: String -> Int
length input = Prelude.length (getBreaks input)