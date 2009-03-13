#!/usr/bin/env runhaskell

module Main where

import Language.NesC.Parser
import Language.NesC.Graph

import Text.ParserCombinators.Parsec

import System.IO
import System.Environment
import System.Console.GetOpt

import Control.Monad

main :: IO ()
main = do
  liftM (parse configuration "stdin") getContents >>=
       either
       (hPrint stderr)
       (putStr . graphConfiguration)

-- ++ "\nThis program treats stdin as a NesC configuration file and outputs to stdout a directed graph in DOT format of its wirings.\nExample: " ++ name ++ " < MainAppC.nc | dot -Tpng > MainAppC.png"

data Option = Help deriving (Show)

options :: [OptDescr Option]
options = [ Option "h" ["help"] (NoArg Help) "usage information"
          ]

usage :: String -> String
usage = ("Usage: " ++)
