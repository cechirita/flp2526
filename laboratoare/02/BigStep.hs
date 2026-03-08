module BigStep ( bsStmt ) where

import Syntax ( AExpr(..), BExpr(..), Stmt(..) )
import State ( get, set, State )
import Configurations ( Conf(..), Conf1(..) )
import Parser ( aconf, bconf, parseFirst, sconf, Parser ) -- for testing purposes

{- big-step semantics for arithmetic expressions

Examples:

>>> testExpr "< 5 , >"
< 5 >

>>> testExpr "< x , a |-> 3, x |-> 4 >"
< 4 >

>>> testExpr "< x + a, a |-> 3, x |-> 4 >"
< 7 >

>>> testExpr "< x - a, a |-> 3, x |-> 4 >"
< 1 >

>>> testExpr "< x * a, a |-> 3, x |-> 4 >"
< 12 >
-}
bsExpr :: Conf AExpr -> Conf1 Integer
bsExpr = undefined

{- big-step semantics for boolean expressions

Examples:
>>> testBExpr "< true, >"
< True >

>>> testBExpr "< false, >"
< False >

>>> testBExpr "< x == a, a |-> 3, x |-> 4 >"
< False >

>>> testBExpr "< a <= x, a |-> 3, x |-> 4 >"
< True >

>>> testBExpr "< !(a <= x), a |-> 3, x |-> 4 >"
< False >

>>> testBExpr "< true && false, >"
< False >

>>> testBExpr "< true || false, >"
< True >
-}
bsBExpr :: Conf BExpr -> Conf1 Bool
bsBExpr = undefined

{- big-step semantics for statements

Examples:

>>> testStmt "< skip, >"
<  >

>>> testStmt "< x := x + 1, a |-> 3, x |-> 4 >"
< x |-> 5, a |-> 3 >

>>> testStmt "< x := x + 1; a := x + a, a |-> 3, x |-> 4 >"
< a |-> 8, x |-> 5 >

>>> testStmt "< if a <= x then max := x else max := a, a |-> 3, x |-> 4 >"
< max |-> 4, a |-> 3, x |-> 4 >

>>> testStmt "< while a <= x do x := x - a, a |-> 7, x |-> 33 >"
< x |-> 5, a |-> 7 >
-}
bsStmt :: Conf Stmt -> Conf1 State
bsStmt = undefined


-- Below are the functions used for a nice testing experience
-- they combine running the actual function being tested with parsing
-- to allow specifying the input configuration as a string
--
-- These, together with the Show instances in the Configurations, State, and Syntax modules
-- make the input and output look closer to how it would look on paper.

test :: Show c => (c -> c') -> Parser c -> String -> c'
test f p s = f c
  where
    c = case parseFirst p s of
      Right c -> c
      Left err -> error ("parse error: " ++ err)

testExpr :: String -> Conf1 Integer
testExpr = test bsExpr aconf

testBExpr :: String -> Conf1 Bool
testBExpr = test bsBExpr bconf

testStmt :: String -> Conf1 State
testStmt = test bsStmt sconf
