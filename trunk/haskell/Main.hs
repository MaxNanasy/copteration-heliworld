#!/usr/bin/env runhaskell

module Main (main) where

import Language.NesC.Parser
import Language.NesC.Graph

import Text.ParserCombinators.Parsec

import System.IO
import System.Environment
import System.Console.GetOpt
import System.Console.ParseArgs

import Control.Monad

main :: IO ()
main = do
  args <- parseArgsIO ArgsComplete possibleArgs
  if (gotArg args Help)
    then putStrLn $ usage args
    else do hSetBuffering stdin LineBuffering
            liftM (parse configuration "stdin") getContents >>= either
                      (hPrint stderr)
                      (putStr . graphConfiguration (gotArg args Ports))

data Option = Help | Ports deriving (Eq, Ord, Show)

possibleArgs :: [Arg Option]
possibleArgs = [ Arg { argIndex = Help , argName = Just "help" , argAbbr = Just 'h', argData = Nothing, argDesc = "usage information" }
               , Arg { argIndex = Ports, argName = Just "ports", argAbbr = Just 'p', argData = Nothing, argDesc = "display ports"     }
               ]

usage :: Ord a => Args a -> String
usage args = argsUsage args ++ description

description :: String
description = "Treats stdin as a NesC configuration file and outputs to stdout a directed graph in DOT format of its wirings.\n"
