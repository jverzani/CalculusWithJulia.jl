
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


1, 1.0, 1//1, 1 + 0im


alert("""
Heads up, the difference between `1` and `1.0` is subtle (and even more so, as `1.` will parse as `1.0`).
""")


1 + 1.25 + 3//2


sqrt(2) * sqrt(2) - 2, sin(pi)


2^62, 2^63


sqrt(-1.0)


sqrt(-1.0 + 0im)


note("""
At one point, `Julia` had an issue with a third type of power:
integer bases and negative integer exponents. For example `2^(-1)`. This is now special cased. Historically, the desire to keep a predictable type for the output (integer) led to defining this case as a domain error.
""")


alert("""
You can discover more about the range of floating point values provided by calling a few different functions.

- `typemax(0.0)` gives the largest value for the type (`Inf` in this case).

- `prevfloat(Inf)` gives the largest finite one, in general `prevfloat` is the next smallest floating point value.

- `nextfloat(-Inf)`, similarly,  gives the smallest finite floating point value, and in general returns the next largest floating point value.

- `nextfloat(0.0)` gives the closest positive value to 0.

- `eps()`  gives the distance to the next floating point number bigger than `1.0`. This is sometimes referred to as machine precision.

""", title="More on floating point", label="More on the range of floating point values")


x = 1.23


6.23 * 10.0^23


x = 6.23e23


4e30 * 3e40, 3e40 / 4e30


0/0, Inf/Inf, Inf - Inf, 0 * Inf


1/0, Inf + Inf, 1 * Inf


0^0, Inf^0


sqrt(2)*sqrt(2) - 2


1/10 + 2/10 == 3/10


1/10 + (2/10 + 3/10) == (1/10 + 2/10) + 3/10


1.0 - cos(1e-8)


1//2, 2//1, 6//4


1//10 + 2//10 == 3//10


(1//10 + 2//10) + 3//10 == 1//10 + (2//10 + 3//10)


(1//2 + 1//3 * 1//4 / 1//5) ^ 6


(1//2)^(1//2)   # the first parentheses are necessary as `^` will be evaluated before `//`.


using DataFrames
attributes = ["construction", "exact", "wide range", "has infinity", "has `-0`", "fast", "closed under"]
integer = [q"1", "true", "false", "false", "false", "true", "`+`, `-`, `*`, `^` (non-negative exponent)"]
rational = ["`1//1`", "true", "false", "false", "false", "false", "`+`, `-`, `*`, `/` (non zero denominator),`^` (integer power)"]
float = [q"1.0", "not usually", "true", "true", "true", "true", "`+`, `-`, `*`, `/` (possibly `NaN`, `Inf`),`^` (non-negative base)"]
d = DataFrame(Attributes=attributes, Integer=integer, Rational=rational, FloatingPoint=float)
table(d)


1 + 2im, 3 + 4.0im


sqrt(-2 + 0im)


a,b,c = 1,2,3  ## x^2 + 2x + 3
discr = b^2 - 4a*c
(-b + sqrt(discr + 0im))/(2a), (-b - sqrt(discr + 0im))/(2a)


choices = ["Integer", "Rational", "Floating point", "Complex", "None, an error occurs"]
ans = 3
radioq(choices, ans, keep_order=true)


ans = 3
radioq(choices, ans, keep_order=true)


ans = 2
radioq(choices, ans, keep_order=true)


ans = 3
radioq(choices, ans, keep_order=true)


ans = 1
radioq(choices, ans, keep_order=true)


ans = 4
radioq(choices, ans, keep_order=true)


ans = 3
radioq(choices, ans, keep_order=true)


ans = 3
radioq(choices, ans, keep_order=true)


yesnoq(true)


yesnoq(false)


a, b = 2, -1
a^b


yesnoq(false)

