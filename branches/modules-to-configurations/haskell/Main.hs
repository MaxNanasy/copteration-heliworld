#!/usr/bin/env runhaskell

module Main (main) where

import Language.NesC.Parser
import Language.NesC.Graph

import Text.ParserCombinators.Parsec

import System.IO
import System.Environment
import System.Console.GetOpt

import Control.Monad

main :: IO ()
main = do
  name <- getProgName
  options@(opts, _, _) <- liftM (getOpt Permute possibleOptions) getArgs
  let (toPrint, proceed) = handleOptions name options
  maybe (return ()) putStr toPrint
  when proceed $
       liftM (parse configuration "stdin") getContents >>=
             either
             (hPrint stderr)
             (putStr . graphConfiguration (elem Ports opts))

description :: String
description = "Treats stdin as a NesC configuration file and outputs to stdout a directed graph in DOT format of its wirings.\n"

data Option = Help | Ports deriving (Show, Eq)

possibleOptions :: [OptDescr Option]
possibleOptions = [ Option "h" ["help" ] (NoArg Help ) "usage information"
          , Option "p" ["ports"] (NoArg Ports) "display ports"
          ]

usage :: String -> String
usage name = usageInfo ("Usage: " ++ name ++ " [OPTION]...\n" ++ description) possibleOptions

handleOptions :: String -> ([Option], [String], [String]) -> (Maybe String, Bool)
handleOptions _name ([]           , []   , []          ) =
    (Nothing                                                                          , True )
handleOptions  name (options@(_:_), []   , []          ) =
    if elem Help options then
         (Just $ usage name                                                           , False)
    else (Nothing                                                                     , True )
handleOptions  name (_            , (_:_), []          ) =
    (Just $ "Error: No arguments expected.\n\n" ++ usage name                         , False)
handleOptions  name (_            , _    , errors@(_:_)) =
    (Just $ "Error:\n\n" ++ concatMap ((name ++ ": ") ++) errors ++ "\n" ++ usage name, False)
