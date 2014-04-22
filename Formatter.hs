{-# LANGUAGE OverloadedStrings #-}
{- Formatter.hs

Pretty-prints the components of reaction systems to string.-}

module Formatter ( showSymbol
                 , showSpaceSymbols
                 , showPlusSymbols
                 , showListOfListsOfSymbols
                 ) where

import ReactionSystems
import qualified Data.Text.Lazy as Text
import qualified Data.Set as Set

-- | Pretty-print the supplied symbol.
showSymbol :: Symbol -> Text.Text
showSymbol = Text.pack . name

-- Pretty-print the supplied set of symbol as a list with the given
-- separator.
showSymbols :: Text.Text -> Symbols -> Text.Text
showSymbols _ ss | Set.null ss = "<empty>"
showSymbols sep ss | otherwise = (Text.intercalate sep . Set.toList . Set.map showSymbol) ss

-- | Pretty-print the supplied set of symbol as a space-separated
-- list.
showSpaceSymbols = showSymbols " "

-- | Pretty-print the supplied set of symbol as a plus-separated
-- list.
showPlusSymbols = showSymbols "+"

-- | Pretty-print a list of lists of symbols.
showListOfListsOfSymbols :: [Symbols] -> Text.Text
showListOfListsOfSymbols = Text.unlines . map showSpaceSymbols