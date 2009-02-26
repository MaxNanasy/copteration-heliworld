#!/usr/bin/runhaskell

-- Usage  : ./Main.hs InputConfFile OutputGraphFile [dotOptions]
-- Example: ./Main.hs MainAppC.nc   MainAppC.png     -Tpng
-- This program takes a NesC configuration file and outputs a directed graph of its wirings generated through the dot program.

module Main where

import Language.NesC.Parser
import Language.NesC.Graph

import Text.ParserCombinators.Parsec

import System.IO
import System.Process
import System.Environment

main :: IO ()
main = do
  inFile : outFile : dotArgs <- getArgs
  (dotIn, dotOut, _, _) <- runInteractiveProcess "dot" dotArgs Nothing Nothing
  Right conf <- parseFromFile configuration inFile
  hPutStr dotIn (graphConfiguration conf)
  hGetContents dotOut >>= writeFile outFile
