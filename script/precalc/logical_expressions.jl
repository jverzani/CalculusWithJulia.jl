
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


x, y = 1, 2
x^2 + y^2 <= 1


alert("The use of `==` is necessary, as `=` is used for assignment.")


!true


a,b,c = 1,2,3
a < b, a + c < b + c


a,b,c = 3,2,1
a < b, a + c < b + c


alert(""" Well, almost... When `Inf` or `NaN` are involved, this may not hold, for example `1 + Inf < 2 + Inf` is actually `false`. """)


a,b,c = rand(3)   # 3 random numbers in (0,1)
a < b, c*a < c*b


a,b = rand(2)
a < b, -a > -b


a,b = rand(2)
a < b, 1/a > 1/b


x = -1; exp(x) >= 1 + x
x =  0; exp(x) >= 1 + x
x =  1; exp(x) >= 1 + x


a, b = rand(2)
(exp(b) - exp(a)) / (b-a) > exp((a+b)/2)


a, b = rand(2)
h = 2 / (1/a + 1/b)
g = (a * b) ^ (1 / 2)
q = sqrt((a^2 + b^2) / 2)
h <= g, g <= q


x = 18
abs(x - 5) < 7


-7 < x - 5 < 7


(-7 < x - 5) & (x - 5 < 7)


(x - 5 < -7) | (x - 5 > 7)


alert("""
The
[short circuit operators](http://julia.readthedocs.org/en/latest/manual/control-flow/#man-short-circuit-evaluation)
are `&&` and `||`. For simple Boolean values, they perform a related
task, though have a more general usage.
""")


A,B = true, false  ## also true, true; false, true; and false, false
!(A & B) == !A | !B


(x - 5 < -7) | (x - 5 > 7)


x - 5 < -7 | x - 5 > 7


(x - 5 < ( (-7 | x) - 5)) > 7


true + true + false, false * 1000


(x > 0) * x


(x < -10)*(-10) + (x >= -10)*(x < 10) * x + (x>=10)*10


choices = [
"`e^pi` is greater than `pi^e`",
"`e^pi` is equal to `pi^e`",
"`e^pi` is less than `pi^e`"
]
ans = 1
radioq(choices, ans)


ans = (sin(1000) > 0)
yesnoq(ans)


choices = [
L"-1/a < -1/b",
L"-1/a > -1/b",
L"-1/a \geq -1/b"]
ans = 3
radioq(choices, ans)


choices = ["Yes, it is always true.",
           "It can sometimes be true, though not always.",
	   L"It is never true, as $1/a$ is negative and $1/b$ is positive"]
ans = 3
radioq(choices, ans)


using CalculusWithJulia    # loads the `SpecialFunctions` package
airyai(0)


choices = ["`airyai($i) < 0`" for i in -1:-1:-5]
ans = 3
radioq(choices, ans, keep_order=true)


choices = ["`x^x <= (1/e)^(1/e)`",
           "`x^x == (1/e)^(1/e)`",
           "`x^x >= (1/e)^(1/e)`"]
ans = 3
radioq(choices, ans)


choices = ["`(x+y)^p < x^p + y^p`",
           "`(x+y)^p == x^p + y^p`",
           "`(x+y)^p > x^p + y^p`"]
ans = 1
radioq(choices, ans)


choices = ["`a^a + b^b <= a^b + b^a`",
           "`a^a + b^b >= a^b + b^a`",
	   "`a^b + b^a <= 1`"]
ans = 2
radioq(choices, ans)


val = abs(3-2) < 1/2
yesnoq(val)


choices = [L"-b < x - a < b",
         L" -b < x-a \text{ and } x - a < b",
         L" x - a < -b \text{ or } x - a > b"]
ans = 3
radioq(choices, ans)


x = pi + 0.2 * rand()
abs(x - pi) < 1/10, abs(sin(x) - sin(pi)) < 1/10


booleanq(true)


x = 12
val = (abs(x -3) + abs(x-9) > 12)
yesnoq(val)


choices = ["`!(false & false) == !false & !false`",
           "`!(false & false) == false !& false`",
	   "`!(false & false) == !false | !false`"]
ans = 3
radioq(choices, ans)


choices = ["`Inf < 3.0` and `3.0 <= Inf`",
           "`NaN < 3.0` and `3.0 <= NaN`"]
ans = 2
radioq(choices, ans)


yesnoq(true)


true & missing, true | missing


choices = ["If `missing` were `true` or `false`, the answer would always be `true`",
"Since the second value is \"`missing`\", only the first is used. So `false | missing` would also be `false`"]
ans = 1
radioq(choices, ans)


choices = ["If `missing` were `true` the answer would be `true` and if it were `false` the answer would be `false`, so the answer is not known, hence also \"`missing`\"",
"Since the second value is \"`missing`\" all such answers would be missing."]
ans = 1
radioq(choices, ans)

