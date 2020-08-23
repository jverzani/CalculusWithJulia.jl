
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


note("""

**Thanks to Euler (1707-1783):** The formal idea of a function is a relatively modern concept in mathematics.  According to [Dunham](http://www.maa.org/sites/default/files/pdf/upload_library/22/Ford/dunham1.pdf),
  Euler defined a function as an "analytic expression composed in any way
  whatsoever of the variable quantity and numbers or constant
  quantities." He goes on to indicate that as Euler matured, so did
  his notion of function, ending up closer to the modern idea of a
  correspondence not necessarily tied to a particular formula or
  “analytic expression.” He finishes by saying: "It is fair to say
  that we now study functions in analysis because of him."

""")


f(x) = cos(x)
g(x) = x^2 - x
h(x) = sqrt(x)


f(pi), g(2), h(4)


note(""" The equals sign in the definition of a function above is an *assignment*. Assignment restricts the expressions available on the *left*-hand side to a) a variable name, b) an indexing assignment, as in `xs[1]`, or c) a function assignment following this form `function_name(args...)`. Whereas function definitions and usage in `Julia` mirrors standard math notation; equations in math are not so mirrored in `Julia`. In mathematical equations, the left-hand of an equation is typically a complicated algebraic expression. Not so with `Julia`, where the left hand side of the equals sign is prescribed and quite limited.
""")


h(-1)


x = -40
y = 5/9 * (x - 32)


f(x) = 5/9 * (x - 32)
f(72)				## room temperature


if x < 0
  -1
elseif x > 0
   1
end


if x < 0
  -1
elseif x > 0
   1
else
   0
end


f(x) = x >= 0 ? x : -x


f(x) = x > 10 ? x : 10.0


cellplan(x) = x < 500 ? 20.0 : 20.0 + 0.05 * (x-500)


alert("""

Type stability. These last two definitions used `10.0` and `20.0`
instead of the integers `10` and `20` for the answer. Why the extra
typing? When `Julia` can predict the type of the output from the type
of inputs, it can be more efficient. So when possible, we help out and
ensure the output is always the same type.

""")


h(t) = 0 <= t <= sqrt(10/16) ? 10.0 - 16t^2 : error("t is not in the domain")


s(x) = x < 0 ? -1 : (x > 0 ? 1 : error("0 is not in the domain"))


function f(x)
  return x^2
end


note("""
The `return` keyword is not a function, so is not called with parentheses. An emtpy `return` statement will return a value of `nothing`.
""")


function f(x)
  g, v0, theta, k = 9.8, 200, 45, 1/2
  a = v0 * cosd(theta)

  (g/(k*a) + tand(theta))* x + (g/k^2) * log(1 - k/a*x)
end
f(100)


m, b = 2, 3
f(x) = m*x + b


f(0), f(2)


m, b = 3, 2


f(0)


f(x; m=1, b=0) = m*x + b


f(0)


f(0, m=3, b=2)


function f(x; g = 9.8, v0 = 200, theta = 45, k = 1/2)
  a = v0 * cosd(theta)
  (g/(k*a) + tand(theta))* x + (g/k^2) * log(1 - k/a*x)
end


Area(w, h) = w * h		                   # of a rectangle
Volume(r, h) = pi * r^2 * h	                   # of a cylinder
SurfaceArea(r, h) = pi * r * (r + sqrt(h^2 + r^2)) # of a right circular cone, including the base


alert("""
Multiple dispatch is very common in mathematics. For example, we learn different ways to add: integers (fingers, carrying), real numbers (align the decimal points), rational numbers (common denominators), complex numbers (add components), vectors (add components), polynomials (combine like monomials), ... yet we just use the same `+` notation for each operation. The concepts are related, the details different.
""")


methods(log, (Number,)) |> collect


Area(w, h) = w * h


h(w) = (20  - 2*w)/2


Area(w) = Area(w, h(w))


using CalculusWithJulia
using Plots
plot(Area, 0, 10)


f(x) = x^2 - 2x
g(x) = f(x -3)


function shift_right(f; c=0)
  function(x)
    f(x - c)
  end
end


f(x) = x^2 - 2x
l = shift_right(f, c=3)


shift_right(f; c=0) = x -> f(x-c)


alert("""

Generic versus anonymous functions. Julia has two types of functions,
generic ones, as defined by `f(x)=x^2` and anonymous ones, as defined
by `x -> x^2`. One gotcha is that `Julia` does not like to use the
same variable name for the two types.  In general, Julia is a dynamic
language, meaning variable names can be reused with different types
of variables. But generic functions take more care, as when a new
method is defined it gets added to a method table. So repurposing the
name of a generic function for something else is not allowed. Similarly,
repurposing an already defined variable name for a generic function is
not allowed. This comes up when we use functions that return functions
as we have different styles that can be used: When we defined `l =
shift_right(f, c=3)` the value of `l` is assigned an anonymous
function. This binding can be reused to define other variables.
However, we could have defined the function `l` through `l(x) =
shift_right(f, c=3)(x)`, being explicit about what happens to the
variable `x`. This would have made `l` a generic function. Meaning, we
get an error if we tried to assign a variable to `l`, such as an
expression like `l=3`. We generally employ the latter style, even though
it involves a bit more typing, as we tend to stick to generic
functions for consistency.

""")


function secant(f, a, b)
   m = (f(b) - f(a)) / (b-a)
   x -> f(a) + m * (x - a)
end


f(x) = x^2 - 2
a,b = 1, 2
secant(f,a,b)(3/2)


function secant_intersection(f, a, b)
   # solve 0 = f(b) + m * (x-b) where m is the slope of the secant line
   # x = b - f(b) / m
   m = (f(b) - f(a)) / (b - a)
   b - f(b) / m
end


f(x) = x^2 - 2
a, b = 1, 2
c = secant_intersection(f, a, b)


plot(f, a, b, linewidth=5, legend=false)
plot!(zero, a, b)
plot!([a, b], f.([a,b]))
scatter!([c], [f(c)])


f(c)


a, b = b, c
c = secant_intersection(f, a, b)
f(c)


a, b = b, c
c = secant_intersection(f, a, b)
f(c)                 # like 1e-3
a, b = b, c
c = secant_intersection(f, a, b)
f(c)                 # like -6e-6
a, b = b, c
c = secant_intersection(f, a, b)
f(c)                 # like -8e-10
a, b = b, c
c = secant_intersection(f, a, b)
f(c)                 # pretty close now


a, b = 1, 2
c = secant_intersection(f, a, b)

p = plot(f, a, b, linewidth=5, legend=false)
plot!(p, zero, a, b)

plot!(p, [a,b], f.([a,b]));
scatter!(p, [c], [f(c)])

a, b = b, c
c = secant_intersection(f, a, b)
plot!(p, [a,b], f.([a,b]));
scatter!(p, [c], [f(c)])


a, b = b, c
c = secant_intersection(f, a, b)
plot!(p, [a,b], f.([a,b]));
scatter!(p, [c], [f(c)])
p


choices = [
"Domain is all real numbers, range is all real numbers",
"Domain is all real numbers, range is all non-negative numbers",
"Domain is all non-negative numbers, range is all real numbers",
"Domain is all non-negative numbers, range is all non-negative numbers"
]
ans = 2
radioq(choices, ans)


choices = [
"Domain is all real numbers, range is all real numbers",
L"Domain is all real numbers except $2$, range is all real numbers except $0$",
L"Domain is all non-negative numbers except $0$, range is all real numbers except $2$",
L"Domain is all non-negative numbers except $-2$, range is all non-negative numbers except $0$"
]
ans = 2
radioq(choices, ans)


choices = [
L"f(x) = 2^x",
L"f(x) = 1/x^2",
L"f(x) = |x|",
L"f(x) = \sqrt{x}"]
ans = 1
radioq(choices, ans)


choices = [q"f = sin(x + pi/3)",
q"function f(x) = sin(x + pi/3)",
q"f(x)  = sin(x + pi/3)",
q"f: x -> sin(x + pi/3)",
q"f x = sin(x + pi/3)"]
ans = 3
radioq(choices, ans)


choices = [q"f(x) = (1 + x^2)^(-1)",
q"function f(x) = (1 + x^2)^(-1)",
q"f(x) := (1 + x^2)^(-1)",
q"f[x] =  (1 + x^2)^(-1)",
q"def f(x): (1 + x^2)^(-1)"
]
ans = 1
radioq(choices, ans)


f(x) = x < 500 ? 30.0 : 30 + 0.10 * (x-500)


booleanq(true, labels=["Yes", "No"])


f(x) = x < 0 ? x : 0.0


yesnoq(false)


f(x; mu=0, sigma=1) = 1/sqrt(2pi*sigma) * exp(-(1/2)*(x-mu)^2/sigma)


booleanq(true, labels=["Yes", "No"])


numericq(0)


numericq(70)


numericq(70)


A(w, h) = w*h


B(w, h=5) = w*h


C(x, mu=0, sigma=1) = 1/sqrt(2pi*sigma) * exp(-(1/2)*(x-mu)^2/sigma)


numericq(70)


numericq(70)


numericq(0)


choices = ["Yes, this will work just as it does for keyword arguments",
"No, there will be an error that the function does not accept keyword arguments"]
ans = 2
radioq(choices, ans)


klamp(x, a, b) = x < a ? a : (x > b ? b : x)


choices = [
"If `x` is in `[a,b]` it returns `x`, otherwise it returns `a` when `x` is less than `a` and `b` when  `x` is greater than `b`.",
"If `x` is in `[a,b]` it returns `x`, otherwise it returns `NaN`",
"`x` is the larger of the minimum of `x` and `a` and the value of `b`, aka `max(min(x,a),b)`"
]
ans = 1
radioq(choices, ans)


(sin ∘ cos)(pi/4)


choices = [
L"You still get $0.649...$",
"You get a `MethodError`, as `cos(pi/4)` is evaluated as a number and `∘` is not defined for functions and numbers",
"You get a `generic` function, but this won't be callable. If tried, it will give an method error."
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
"It is `0.6663667453928805`, the same as `cos(sin(1))`",
"It is `0.5143952585235492`, the same as `sin(cos(1))`",
"It gives an error"]
ans = 1
radioq(choices, ans, keep_order=true)


fn = !iseven
fn(3)


booleanq(fn(3))


secant_intersection(f, a, b) = b - f(b) * (b - a) / (f(b) - f(a))  # rewritten
f(x) = x^2 - 2
a, b = 1//1, 2//1
c = secant_intersection(f, a, b)


choices = [q"4//3", q"7//5", q"58//41", q"816//577"]
ans = 3
radioq(choices, ans, keep_order=true)


val = f(58/41)
numericq(val)


choices = [L"about $8$ parts in $100$", L"about $1$ parts in $100$", L"about $4$ parts in $10,000$", L"about $2$ parts in $1,000,000$"]
ans = 3
radioq(choices, ans, keep_order=true)


choices = ["Just use `f = h - g`",
"Define `f(x) = h(x) - g(x)`",
"Use `x -> h(x) - g(x)` when the difference is needed"
]
ans = 1
radioq(choices, ans)

