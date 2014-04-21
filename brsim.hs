{- brsim.hs

A Basic Reaction Systems Simulator. -}

import qualified System.Console.Argument as Arg
import System.Console.Command
import System.Console.Program

-- | The possible reaction description formats.
data ReactionFormat = Plain -- ^ A reaction is given as three lists of symbol names.
                    | Arrow -- ^ A reaction is given in a notation similar to the chemical one.
                    deriving (Eq, Ord, Show, Read)

reactionFormat = Arg.Type { Arg.parser = \val -> case val of
                               "plain" -> Right $ Plain
                               "arrow" -> Right $ Arrow
                               str -> Left $ "Unknown reaction format: " ++ show str
                          , Arg.name = "reaction format"
                          , Arg.defaultValue = Just Arrow
                          }

reactionFormatOpt = Arg.option ['f'] ["format"] reactionFormat Arrow
                    "The format of the reaction description.\n\
\    The default value of this argument is \"arrow\", in which case the rules should be\n\
\    specified using a notation similar to the chemical notation:\n\n\
\        <left hand side> -> <right hand side> | <list of inhibitors>\n\n\
\    For example, a reaction which consumes a and b, produces c and d, and is inhibited\n\
\    by e and f, can be written as follows:\n\n\
\        a+b->c+d|e f\n\n\
\    If the value of this argument is \"plain\", the rules are specified as lists of\n\
\    reactants, inhibitors, and products respectively.  Thus, the same reaction can be\n\
\    written in the following way:\n\n\
\        a b, e f, c d"

run = Command { name = "run"
              , action = withNonOption Arg.file $
                         \rsFile ->
                         withOption reactionFormatOpt $
                         \format -> io $ do
                           putStrLn $ "Read " ++ show rsFile ++ " in format " ++ show format ++ "."
              , description = "Run the simulation of the reaction system\
\given in FILE.\n"
              }

brsimCommand = Command { name = "brsim"
                       , action = io $ do
                         putStrLn "ERROR: No reaction system specified.  Showing usage information.\n"
                         showUsage brsimCommands
                       , description = "A Basic Reaction System Simulator."
                       }

brsimCommands :: Commands
brsimCommands = Node brsimCommand [Node run []]

main :: IO ()
main = single brsimCommands
