
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
nothing


imgfile = "figures/calculator.png"
caption = "Screenshot of a calculator provided by the Google search engine."
ImageFile(imgfile, caption)


x = sqrt(2)
y = 42


x


x = 2


top = 1 + 2*3^4
bottom = 5 - 6/7
top/bottom


g = 9.8
v0 = 200
theta = 45
k = 1/2
x = 100
a = v0 * cosd(theta)
(g/(k*a) + tand(theta))* x + (g/k^2) * log(1 - k/a*x)


x = 3
-16*x^2 + 32*x - 12


-16x^2 + 32x - 12


x = x^2


x = 2
x = x - (x^2 - 2) / (2x)


note("""
The `varinfo` function will list the variables currently defined in the
main workspace. There is no mechanism to delete a single variable.
""")


alert("""
**Shooting oneselves in the foot.** `Julia` allows us to locally
redefine variables that are built in, such as the value for `pi` or
the function object assigned to `sin`. For example, this is a
perfectly valid command `sin=3`. However, it will overwrite the
typical value of `sin` so that `sin(3)` will be an error. The
binding to `sin` occurs in the `Main` module. This shadows that
value of `sin` bound in the `Base` module. Even if redefined in
`Main`, the value in base can be used by fully qualifying the name,
as in `Base.sin(pi)`. This uses the convention
`module_name.variable_name` to look up a binding in a module.
""")


value_1 = 1
a_long_winded_variable_name = 2
sinOfX = sind(45)
__private = 2     # a convention


ϵ = 1e-10


θ = 45; v₀ = 200


alert("""
There is even support for tab-completion of
[emojis](https://github.com/JuliaLang/julia/blob/master/stdlib/REPL/src/emoji_symbols.jl)
such as `\\:snowman:[tab]` or `\\:koala:[tab]`

""")


a = 1; b = 2; c=3


a, b, c = 1, 2, 3


a, b = b, a


x0, y0 = 1, 2
x1, y1 = 4, 6
m = (y1 - y0) / (x1 - x0)


a,b,c = 10, 2.3, 8;
numericq((a-b)/(a-c))


x = 4
y =- 100 - 2x - x^2
numericq(y, 0.1)


a = 3.2; b=2.3
a^b - b^a


a = 3.2; b=2.3;
val = a^b - b^a;
numericq(val)


p, q = 0.25, 0.2
top = p - q
bottom = sqrt(p*(1-p))
ans = top/bottom


p, q = 0.25, 0.2;
top = p - q;
bottom = sqrt(p*(1-p));
ans = top/bottom;
numericq(ans)


x = 3
val = (x^2 - 2x - 8)/(x^2 - 9x - 20)
numericq(val)


choices = [
q"5degreesbelowzero",
q"some_really_long_name_that_is_no_fun_to_type",
q"aMiXeDcAsEnAmE",
q"fahrenheit451"
]
ans = 1
radioq(choices, ans)


choices = [q"pi", q"oo", q"E", q"I"]
ans = 1
radioq(choices, ans)


δ = 1/10


choices=[
q"\delta[tab] = 1/10",
q"delta[tab] = 1/10",
q"$\\delta$ = 1/10"]
ans = 1
radioq(choices, ans)


choices = [
q"a=1, b=2, c=3",
q"a,b,c = 1,2,3",
q"a=1; b=2; c=3"]
ans = 1
radioq(choices, ans)


x = y = z = 3


choices = ["Assign all three variables at once to a value of 3",
"Create 3 linked values that will stay synced when any value changes",
"Throw an error"
]
ans = 1
radioq(choices, ans)

