--  Boolean Tests

b3 = parseExp "if (3==6) -2 else -7"
b4 = parseExp "3*(8 + 5)"
b5 = parseExp "3 + 8 * 2"

b6  = parseExp "if (3 > 3*(8 + 5)) 1 else 0"
b7  = parseExp "2 + (if (3 <= 0) 9 else -5)"
bE1 = parseExp "if (3) 5 else 8"
bE2 = parseExp "3 + true"
bE3 = parseExp "3 || true"
bE4 = parseExp "-true"
--  Declare Tests
t1 = parseExp ("4")
t2 = parseExp ("-4 - 6")
t3 = parseExp ("var x = 3; x")
t4 = parseExp ( "var x = 3; var y = x*x; x")
t5 = parseExp ("var x = 3; var x = x*x; x")
t6 = parseExp ("var x = 3; var y = x*x; y")
t7 = parseExp ("2 + (var x =2; x)")
--  First Class Function Tests
pow = parseExp "function power(n, m) { if (m == 0) 1 else n*power(n, m-1) } power(3, 4)"

facFC = parseExp ("var fac = function(n) { if (n==0) 1 else n * fac(n-1) };" ++
                "fac(5)")

p0 = parseExp ("var foo = function(x) { 99 };" ++
               "foo(1 / 0)")

p1 = parseExp ("var T = function(a) { function(b) { a } };"++
               "var F = function(a) { function(b) { b } };"++
               "var not = function(b) { b(F)(T) };"++
               "not(F)")
               
p2 = parseExp (
      "var x = 5;"++
      "var f = function(y) { x - y };"++
      "var x = f(9);"++
      "f(x)")

p3 = parseExp (
      "var x = 5;"++
      "var f = function(y) { var y = x * y; function(x) { x + y } };"++
      "var g = f(2);"++
      "g(5)")

p4 = parseExp (
      "var comp = function(f) { function(g) { function(x) { f(g(x)) }}};"++
      "var inc = function(x) { x + 1 };"++
      "var square = function(x) { x * x };"++
      "var f = comp(inc)(square);"++
      "f(5)")

p5 = parseExp (
      "var map = function(f) { function(x) { function(y) { f(x) + f(y) }}};"++
      "var g = function(x) { x + 1 };"++
      "map(g)(3)(4)")

