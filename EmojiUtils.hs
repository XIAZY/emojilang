module EmojiUtils where

import qualified Data.Text                     as Text
import qualified Data.Text.ICU                 as ICU
import qualified Data.Map                      as Map

-- emoji are quite complicated. they can take any number of unicode 
-- codepoints. use icu to break them


getBreaks :: String -> [ICU.Break ()]
getBreaks input = ICU.breaks (ICU.breakCharacter ICU.Current) (Text.pack input)

-- get emoji from string
getEmoji :: String -> [Text.Text]
getEmoji input = map ICU.brkBreak (getBreaks input)

length :: String -> Int
length input = Prelude.length (getBreaks input)

-- according to unicode documentation:
-- emoji_modification :=
--     \p{EMod}
--     | \x{FE0F} \x{20E3}?
--     | tag_modifier

-- digits
digits :: Map.Map Text.Text Int
digits = Map.fromList (map makeDigitMap [0 .. 9])
  where
    makeDigitMap i = ((makeDigitEmoji i), i)
    makeDigitEmoji i = Text.pack ((show i) ++ "\65039\8419")

isBoolean :: Text.Text -> Bool
isBoolean c | c == (Text.pack "👍") = True
            | c == (Text.pack "👎") = True
            | otherwise            = False

isDigit :: Text.Text -> Bool
isDigit t = case (Map.lookup t digits) of
    Nothing -> False
    Just a  -> True

getDigit :: Text.Text -> Maybe Int
getDigit i = Map.lookup i digits

read :: [Text.Text] -> Integer
read = foldl addup 0  where
    addup ten oneE = (ten * 10 + (getInt oneE))
    getInt e = case (getDigit e) of
        (Just d ) -> toInteger d
        Nothing -> error "non-digit emoji meet"

isOperator :: Text.Text -> Bool
isOperator c = c `elem` getEmoji "➕➖✖️➗🙆🙅↖️⬅️➡️↗️📦🔥🖋️"

isReserved :: Text.Text -> Bool
isReserved c = isOperator c || c `elem` getEmoji "🤜🤛👉👈"