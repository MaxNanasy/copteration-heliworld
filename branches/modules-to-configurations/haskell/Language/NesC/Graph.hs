module Language.NesC.Graph (graphConfiguration) where

import Language.NesC.Types

import Data.List
import Data.Maybe

graphConfiguration :: Bool -> Configuration -> String
graphConfiguration ports (Configuration name componentDeclarations wirings) = "digraph " ++ name ++ "\n{\n" ++ concatMap graphComponentDeclaration componentDeclarations ++ concatMap (graphWiring ports) wirings ++ "}\n"

graphComponentDeclaration :: ComponentDeclaration -> String
graphComponentDeclaration (CD imp@(CI name _)  Nothing     ) = name ++ " [label=\"" ++ graphComponentImport imp ++ "\"];\n"
graphComponentDeclaration (CD imp             (Just asName)) = asName ++ " [label=\"" ++ asName ++ "\\n(" ++ graphComponentImport imp ++ ")\"];\n"

graphComponentImport :: ComponentImport -> String
graphComponentImport (CI name  Nothing   ) = name
graphComponentImport (CI name (Just args)) = name ++ " (" ++ (concat . intersperse ", ") args ++ ")"

graphWiring :: Bool -> Wiring -> String
graphWiring False wiring                                         = graphWire wiring ++ ";\n"
graphWiring True  wiring@((Component a a') :-> (Component b b')) = graphWire wiring ++ "[taillabel=\"" ++ fromMaybe "" a' ++ "\", headlabel=\"" ++ fromMaybe "" b' ++ "\"];\n"

graphWire :: Wiring -> String
graphWire ((Component a a') :-> (Component b b')) = a ++ " -> " ++ b
