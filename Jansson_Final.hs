{-# OPTIONS_GHC -fwarn-missing-signatures #-}
{-# OPTIONS_GHC -fno-warn-tabs #-}
module Final where

import Prelude hiding (LT, GT, EQ)
import System.IO
import Base
import Data.Maybe
import Data.List
import Operators
import RecursiveFunctionsAST
import RecursiveFunctionsParse
import Test.Hspec
import Control.Exception (evaluate,AsyncException(..))
-- import GHC.Err
-- Uncomment the following if you choose to do Problem 3.
{-
import System.Environment
import System.Directory (doesFileExist)
import System.Process
import System.Exit
import System.Console.Haskeline
--        ^^ This requires installing haskeline: cabal update && cabal install haskeline
-}


--
-- The parsing function, parseExp :: String -> Exp, is defined for you.
--

facvar   = parseExp ("var fac = function(n) { if (n==0) 1 else n * fac(n-1) };" ++
                   "fac(5)")

facrec   = parseExp ("rec fac = function(n) { if (n==0) 1 else n * fac(n-1) };" ++
                   "fac(5)")

exp1     = parseExp "var a = 3; var b = 8; var a = b, b = a; a + b"
exp2     = parseExp "var a = 3; var b = 8; var a = b; var b = a; a + b"
exp3     = parseExp "var a = 2, b = 7; (var m = 5 * a, n = b - 1; a * n + b / m) + a"
exp4     = parseExp "var a = 2, b = 7; (var m = 5 * a, n = m - 1; a * n + b / m) + a"
-- N.b.,                                                  ^^^ is a free occurence of m (by Rule 2)

-----------------
-- The evaluation function for the recursive function language.
-----------------

eval :: Exp -> Env -> Value
eval (Literal v) env                = v
eval (Unary op a) env               = unary  op (eval a env)
eval (Binary op a b) env            = binary op (eval a env) (eval b env)
eval (If a b c) env                 = let BoolV test = eval a env
                                      in if test then  eval b env else eval c env
eval (Variable x) env               = fromJust x (lookup x env)
  where fromJust x (Just v)         = v
        fromJust x Nothing          = error ("Variable " ++ x ++ " unbound!")
eval (Function x body) env          = ClosureV x body env
-----------------------------------------------------------------
eval (Declare decls body) env = eval body newEnv              -- This clause needs to be changed. this is the solution if we only have one tuple
  where vars         = map fst decls                          -- First map should return variables
        expressions  = map snd decls                          -- Second map should return expressions to be evaluated
        values       = map (\x -> eval x env) expressions     -- Put eval lamba in underscore (Step 1)
        newEnv       = zip vars values ++ env                 -- Combine variables and values in to list of tuples (Step 2)

-----------------------------------------------------------------
eval (RecDeclare x exp body) env    = eval body newEnv
  where newEnv = (x, eval exp newEnv) : env
eval (Call fun arg) env = eval body newEnv
  where ClosureV x body closeEnv    = eval fun env
        newEnv = (x, eval arg env) : closeEnv

-- Use this function to run your eval solution.
execute :: Exp -> Value
execute exp = eval exp []
-- Example usage: execute exp1

{-

Hint: it may help to remember that:
   map :: (a -> b) -> [a] -> [b]
   concat :: [[a]] -> [a]
when doing the Declare case.

-}

freeByRule1 :: [String] -> Exp -> [String]
freeByRule1 vars expressions = free vars expressions []
  where
    free :: [String] -> Exp -> [String] -> [String]
    free seen (Literal _)       acc        = []
    free seen (Unary _ e)       acc        = []
    free seen (Binary _ e1 e2)  acc        = []
    free seen (If t e1 e2)      acc        = []
    free seen (Variable x)      acc        = []
    free seen (Declare bs body) acc        = undefined
    free seen (Call e1 e2)      acc        = []

freeByRule2 :: [String] -> Exp -> [String]
freeByRule2 = undefined

---- Problem 3.

repl :: IO ()
repl = do
         putStr "RecFun> "
         iline <- getLine
         process iline

process :: String -> IO ()
process "quit" = return ()
process iline  = do
  putStrLn (show v ++ "\n")
  repl
   where e = parseExp iline
         v = eval e []

-- Tests
test_prob1::IO ()
test_prob1 = hspec $ do
  describe "" $ do
    context "1" $ do
      it "Test exp1" $ do
        execute exp1 `shouldBe` IntV 11
    context "" $ do
      it "Test exp2" $ do
        execute exp2 `shouldBe` IntV 16
    context "" $ do
      it "Test exp3" $ do
        execute exp3 `shouldBe` IntV 14
    -- context "" $ do
    --   it "Test exp4" $ do
    --     execute exp4 `shouldThrow` anyException
