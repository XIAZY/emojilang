module EmojiUtils where

import qualified Data.Text as Text
import qualified Data.Text.ICU as ICU
import qualified Data.Map as Map

-- emoji are quite complicated. they can take any number of unicode 
-- codepoints. use icu to break them


getBreaks :: String -> [ICU.Break ()]
getBreaks input = ICU.breaks (ICU.breakCharacter ICU.Current) (Text.pack input)

-- get emoji from string
getEmoji :: String -> [Text.Text]
getEmoji input = map ICU.brkBreak (getBreaks input)

length :: String -> Int
length input = Prelude.length (getBreaks input)

-- digits
digits :: Map.Map Text.Text Int
digits = Map.fromList (map makeDigitMap [0..9])
    where makeDigitMap i = ((makeDigitEmoji i), i)
          makeDigitEmoji i = Text.pack ((show i) ++ "\8419\65039")

isDigit :: Text.Text -> Bool
isDigit t = case (Map.lookup t digits) of
                Nothing -> False
                Just a -> True
