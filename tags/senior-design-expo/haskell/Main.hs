#!/usr/bin/runhaskell

-- Usage  : ./Main.hs
-- Example: ./Main.hs < MainAppC.nc | dot -Tpng > MainAppC.png
-- This program treats its stdin as a NesC configuration file and outputs a directed graph in "dot" format of its wirings.

module Main where

import Language.NesC.Parser
import Language.NesC.Graph

import Text.ParserCombinators.Parsec

import System.IO

import Control.Monad

main :: IO ()
main = do
  Right conf <- liftM (parse configuration "stdin") getContents
  putStr $ graphConfiguration conf
