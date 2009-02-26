module Language.NesC.Graph (graphConfiguration) where

import Language.NesC.Types

import Control.Monad.Writer.Lazy

graphConfiguration :: Configuration -> String
graphConfiguration (Configuration name componentDeclarations wirings) = "digraph " ++ name ++ "\n{\n" ++ concatMap graphComponentDeclaration componentDeclarations ++ concatMap graphWiring wirings ++ "}\n"

graphComponentDeclaration :: ComponentDeclaration -> String
graphComponentDeclaration (CD (CI name _) Nothing)  = name ++ ";\n"
graphComponentDeclaration (CD (CI _ _) (Just name)) = name ++ ";\n"

graphWiring :: Wiring -> String
graphWiring ((Component a _) :-> (Component b _)) = a ++ " -> " ++ b ++ ";\n"
