-- copyright notice
-- code here is hugely inspired and modified from Prof Albert Lai's code at the University of Toronto

module ParserLib where

import           Control.Applicative
import           Data.Char
import           Data.Functor
import           Data.List
import qualified Data.Text                     as T
import           EmojiUtils

data Parser a = MkParser ([T.Text] -> Maybe ([T.Text], a))

unParser :: Parser a -> [T.Text] -> Maybe ([T.Text], a)
unParser (MkParser sf) = sf

runStringParser :: Parser a -> String -> Maybe a
runStringParser p inputString = runParser p (EmojiUtils.getEmoji inputString)

runParser :: Parser a -> [T.Text] -> Maybe a
runParser (MkParser sf) input = fmap snd (sf input)

instance Functor Parser where
    -- fmap :: (a -> b) -> Parser a -> Parser b
  fmap f (MkParser sf) = MkParser sfb
   where
    sfb inp = case sf inp of
      Nothing        -> Nothing
      Just (rest, a) -> Just (rest, f a)
                  -- OR: fmap (\(rest, a) -> (rest, f a)) (sf inp)

instance Applicative Parser where
    -- pure :: a -> Parser a
  pure a = MkParser (\inp -> Just (inp, a))

  -- liftA2 :: (a -> b -> c) -> Parser a -> Parser b -> Parser c
  -- Consider the 1st parser to be stage 1, 2nd parser stage 2.
  liftA2 op (MkParser sf1) p2 = MkParser g
   where
    g inp = case sf1 inp of
      Nothing          -> Nothing
      Just (middle, a) -> case unParser p2 middle of
        Nothing        -> Nothing
        Just (rest, b) -> Just (rest, op a b)

instance Monad Parser where
    -- return :: a -> Parser a
  return = pure

  -- (>>=) :: Parser a -> (a -> Parser b) -> Parser b
  MkParser sf1 >>= k = MkParser g
   where
    g inp = case sf1 inp of
      Nothing        -> Nothing
      Just (rest, a) -> unParser (k a) rest

instance Alternative Parser where
    -- empty :: Parser a
  empty = MkParser (\_ -> Nothing)

  -- (<|>) :: Parser a -> Parser a -> Parser a
  MkParser sf1 <|> p2 = MkParser g
   where
    g inp = case sf1 inp of
      Nothing -> unParser p2 inp
      j       -> j        -- the Just case

  -- many :: Parser a -> Parser [a]
  -- 0 or more times, maximum munch, collect the answers into a list.
  -- Can use default implementation. And it goes as:
  many p = some p <|> pure []
  -- How to make sense of it: To repeat 0 or more times, first try 1 or more
  -- times!  If that fails, then we know it's 0 times, and the answer is the
  -- empty list.

  -- some :: Parser a -> Parser [a]
  -- 1 or more times, maximum munch, collect the answers into a list.
  -- Can use default implementation. And it goes as:
  some p = liftA2 (:) p (many p)
    -- How to make sense of it: To repeat 1 or more times, do 1 time, then 0 or
    -- more times!  Use liftA2 to chain up and collect answers.

-- character level parser

-- | Read a character and return. Failure if input is empty.
anyChar :: Parser T.Text
anyChar = MkParser sf
 where
  sf []       = Nothing
  sf (c : cs) = Just (cs, c)

-- | Read a character and check against the given character.
char :: T.Text -> Parser T.Text
char wanted = MkParser sf
 where
  sf (c : cs) | c == wanted = Just (cs, c)
  sf _                      = Nothing

-- | Read a character and check against the given predicate.
satisfy :: (T.Text -> Bool) -> Parser T.Text
satisfy pred = MkParser sf
 where
  sf (c : cs) | pred c = Just (cs, c)
  sf _                 = Nothing

-- | Expect the input to be empty.
eof :: Parser ()
eof = MkParser sf
 where
  sf [] = Just ([], ())
  sf _  = Nothing

-- | Space or tab or newline (unix and windows).
whitespace :: Parser T.Text
whitespace = satisfy (\c -> c `elem` ws)
  where ws = Prelude.map T.pack ["\t", "\n", "\r", " "]

-- -- | Consume zero or more whitespaces, maximum munch.
whitespaces :: Parser [T.Text]
whitespaces = many whitespace

-- | One or more operands separated by an operator. Apply the operator(s) in a
-- right-associating way.
chainr1
  :: Parser a               -- ^ operand parser
  -> Parser (a -> a -> a)   -- ^ operator parser
  -> Parser a               -- ^ whole answer
chainr1 getArg getOp = liftA2
  link
  getArg
  (optional (liftA2 (,) getOp (chainr1 getArg getOp)))
 where
  link x Nothing        = x
  link x (Just (op, y)) = op x y

-- | One or more operands separated by an operator. Apply the operator(s) in a
-- left-associating way.
chainl1
  :: Parser a               -- ^ operand parser
  -> Parser (a -> a -> a)   -- ^ operator parser
  -> Parser a               -- ^ whole answer
chainl1 getArg getOp = liftA2 link getArg (many (liftA2 (,) getOp getArg))
  where link = foldl (\accum (op, y) -> op accum y)

-- token level primitives

natural :: Parser Integer
natural =
  fmap EmojiUtils.read (some (satisfy EmojiUtils.isDigit)) <* whitespaces

-- | Read something that looks like an operator, then skip trailing spaces.
anyOperator :: Parser [T.Text]
anyOperator = some (satisfy EmojiUtils.isOperator) <* whitespaces

-- | Read the wanted operator, then skip trailing spaces.
operator :: [T.Text] -> Parser [T.Text]
operator wanted =
  anyOperator >>= \sym -> if sym == wanted then return wanted else empty

-- | Open and close parentheses.
openParen, closeParen :: Parser T.Text
openParen = (char (T.pack "👉")) <* whitespaces
closeParen = (char (T.pack "👈")) <* whitespaces

openBracket, closeBracket :: Parser T.Text
openBracket = (char (T.pack "🤜")) <* whitespaces
closeBracket = (char (T.pack "🤛")) <* whitespaces

boolean :: Parser Bool
boolean = satisfy isBoolean
  >>= \c -> if c == (T.pack "👍") then return True else return False

listL :: Parser a -> Parser b -> Parser [a]
listL getArg getOp = liftA2 (:) getArg (many (getOp *> getArg))
