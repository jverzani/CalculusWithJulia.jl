# Functions




A mathematical [function](http://en.wikipedia.org/wiki/Function_(mathematics)) is defined abstractly by

> **Function:** A function is a *relation* which assigns to each element in the domain a *single* element in the range. A **relation** is a set of ordered pairs, $(x,y)$. The set of first coordinates is the domain, the set of second coordinates the range of the relation.

That is, a function gives a correspondence between  values in its domain with  values in its range.

This definition is abstract, as functions can be very general. With
single-variable calculus, we generally specialize to real-valued
functions of a single variable (*univariate functions*). These
typically have the correspondence given by a rule, such as $f(x) =
x^2$ or $f(x) = \sqrt{x}$. The function's domain may be implicit (as in all $x$
for which the rule is defined) or may be explicitly given as part of the
rule. The function's range is then the image of its domain, or the set of all
$f(x)$ for each $x$ in the domain ($\{f(x): x \in \text{ domain}\}$).


Some examples of mathematical functions are:

$$~
f(x) = \cos(x), \quad g(x) = x^2 - x, \quad h(x) = \sqrt{x}, \quad
s(x) = \begin{cases} -1 & x < 0\\1&x>0\end{cases}.
~$$

For these examples, the domain of both $f(x)$ and $g(x)$ is all real
values of $x$, where as for $h(x)$ it is implicitly just the set of
non-negative numbers,
$[0, \infty)$. Finally, for $s(x)$, we can see that the domain is defined for every $x$ but $0$.

In general the range is harder to identify than the domain, and this is the case for these functions too. For $f(x)$ we know the $\cos$ function is trapped in $[-1,1]$
and it is intuitively clear than all values in that set are
possible. The function $h(x)$ would have range
$[0,\infty)$.  The $s(x)$ function is either $-1$ or $1$, so only has two possible values in its range.  What about $g(x)$? It is a parabola that opens upward, so any $y$ values below the $y$ value of its vertex will not appear in the range. In this case, the symmetry indicates that the vertex will be at $(1/2, -1/4)$, so the range is $[-1/4, \infty)$.


````
CalculusWithJulia.WeaveSupport.Alert("\n**Thanks to Euler (1707-1783):** Th
e formal idea of a function is a relatively modern concept in mathematics. 
 According to [Dunham](http://www.maa.org/sites/default/files/pdf/upload_li
brary/22/Ford/dunham1.pdf),\n  Euler defined a function as an \"analytic ex
pression composed in any way\n  whatsoever of the variable quantity and num
bers or constant\n  quantities.\" He goes on to indicate that as Euler matu
red, so did\n  his notion of function, ending up closer to the modern idea 
of a\n  correspondence not necessarily tied to a particular formula or\n  “
analytic expression.” He finishes by saying: \"It is fair to say\n  that we
 now study functions in analysis because of him.\"\n\n", Dict{Any,Any}(:cla
ss => "info"))
````





We will see that defining functions within `Julia` can be as simple a concept as Euler started with, but that the more abstract concept has a great advantage that is exploited in the design of the language.

## Defining simple mathematical functions

The notation `Julia` uses to define simple mathematical functions could not be more closely related to how they are written mathematically. For example, the functions $f(x)$, $g(x)$, and $h(x)$ above may be defined by:

````julia

f(x) = cos(x)
g(x) = x^2 - x
h(x) = sqrt(x)
````


````
h (generic function with 1 method)
````





The left-hand sign of the equals sign is still an assignment, though in this case an assignment to a function object which has a name and a specification of an argument, $x$ in each case above, though other *dummy variables* could be used. The right hand side is simply `Julia` code to compute the *rule* corresponding to the function.

Calling the function also follows standard math notation:

````julia

f(pi), g(2), h(4)
````


````
(-1.0, 2, 2.0)
````





For typical cases like the three above, there isn't really much new to learn.


````
CalculusWithJulia.WeaveSupport.Alert(" The equals sign in the definition of
 a function above is an *assignment*. Assignment restricts the expressions 
available on the *left*-hand side to a) a variable name, b) an indexing ass
ignment, as in `xs[1]`, or c) a function assignment following this form `fu
nction_name(args...)`. Whereas function definitions and usage in `Julia` mi
rrors standard math notation; equations in math are not so mirrored in `Jul
ia`. In mathematical equations, the left-hand of an equation is typically a
 complicated algebraic expression. Not so with `Julia`, where the left hand
 side of the equals sign is prescribed and quite limited.\n", Dict{Any,Any}
(:class => "info"))
````





### The domain of a function

Functions in `Julia` have an implicit domain, just as they do mathematically. In the case of $f(x)$ and $g(x)$, the right-hand side is defined for all real values of $x$, so the domain is all $x$. For $h(x)$ this isn't the case, of course. Trying to call $h(x)$ when $x < 0$ will give an error:

````julia

h(-1)
````


````
Error: DomainError with -1.0:
sqrt will only return a complex result if called with a complex argument. T
ry sqrt(Complex(x)).
````





The `DomainError` is one of many different error types `Julia` has, in this case it is quite apt: the value $-1$ is not in the domain of the function.




### Equations, functions, calling a function

Mathematically we tend to blur the distinction between the equation

$$~
y = 5/9 \cdot (x - 32)
~$$

and the function

$$~
f(x) = 5/9 \cdot (x - 32)
~$$

In fact, the graph of a function $f(x)$ is simply defined as the graph of the
equation $y=f(x)$. There is a distinction in `Julia` as a command such as

````julia

x = -40
y = 5/9 * (x - 32)
````


````
-40.0
````





will evaluate the righthand side with the value of `x` bound at the
time of assignment to `y`, whereas assignment to a function

````julia

f(x) = 5/9 * (x - 32)
f(72)				## room temperature
````


````
22.22222222222222
````





will create a function object which is called with a value of `x` at a later
time - the time the function is called. So the value of `x` defined when the function is created is not
important here (as the value of `x` used by `f` is passed in as an argument).



Within `Julia`, we make note of the distinction between a function
object versus a function call. In the definition `f(x)=cos(x)`, the
variable `f` refers to a function object, whereas the expression
`f(pi)` is a function call. This mirrors the math notation where an
$f$ is used when properties of a function are being emphasized (such
as $f \circ g$ for composition) and $f(x)$ is used when the values
related to the function are being emphasized (such as saying "the plot
of the equation $y=f(x)$).

Distinguishing these three related but different concepts (equations, function objects, and function calls) is important when modeling on the computer.

### Cases

The definition of $s(x)$ above has two cases:

$$~
s(x) = \begin{cases} -1 & s < 0\\ 1 & s > 0. \end{cases}
~$$

We learn to read this as "If $s$ is less than $0$, then the answer is
$-1$. If $s$ is greater than $0$ the answer is $1$." Often - but not
in this example - there is an "otherwise" case to catch those values
of $x$ that are not explicitly mentioned. As there is no such
"otherwise" case here, we can see that this function has no definition
when $x=0$. This function is often called the "sign" function and is
also defined by $\lvert x\rvert/x$. (`Julia`'s `sign` function actually
defines `sign(0)` to be `0`.)

How do we create conditional statements in `Julia`? Programming languages generally have "if-then-else" constructs to handle conditional evaluation. In `Julia`, the following code will handle the above condition:

````julia

if x < 0
  -1
elseif x > 0
   1
end
````




The "otherwise" case would be caught with an `else` addition. So, for example, this would implement `Julia`'s definition of `sign` (which also assigns $0$ to $0$):

````julia

if x < 0
  -1
elseif x > 0
   1
else
   0
end
````





The conditions for the `if` statements are expressions that evaluate to either `true` or `false`, such as generated by the Boolean operators `<`, `<=`, `==`, `!-`, `>=`, and `>`.


If familiar with `if` conditions, they are natural to use. However, for simpler cases of "if-else" `Julia` provides the more convenient *ternary* operator: `cond ? if_true : if_false`. (The name comes from the fact that there are three arguments specified.) The ternary operator checks the condition and if true returns the first expression, whereas if the condition is false the second condition is returned. Both expressions are evaluated. (The [short-circuit](http://julia.readthedocs.org/en/latest/manual/control-flow/#short-circuit-evaluation) operators can be used to avoid both evaluations.)

For example, here is one way to define an absolute value function:

````julia

f(x) = x >= 0 ? x : -x
````


````
f (generic function with 1 method)
````





The condition is `x >= 0` - or is `x` non-negative? If so, the value `x` is used, otherwise `-x` is used.


Here is a means to implement a function which takes the larger of `x` or `10`:

````julia

f(x) = x > 10 ? x : 10.0
````


````
f (generic function with 1 method)
````





(This could also utilize the `max` function: `f(x) = max(x, 10.0)`.)

Or similarly, a function to represent a cell phone plan where the first 500 minutes are 20 dollars and every additional minute is 5 cents:

````julia

cellplan(x) = x < 500 ? 20.0 : 20.0 + 0.05 * (x-500)
````


````
cellplan (generic function with 1 method)
````



````
CalculusWithJulia.WeaveSupport.Alert("\nType stability. These last two defi
nitions used `10.0` and `20.0`\ninstead of the integers `10` and `20` for t
he answer. Why the extra\ntyping? When `Julia` can predict the type of the 
output from the type\nof inputs, it can be more efficient. So when possible
, we help out and\nensure the output is always the same type.\n\n", Dict{An
y,Any}())
````





##### Example

The `ternary` operator can be used to define an explicit domain. For example, a falling body might have height given by $h(t) = 10 - 16t^2$. This model only applies for non-negative $t$ and non-negative $h$ values. So, in particular $0 \leq t \leq \sqrt{10/16}$. To implement this function we might have:

````julia

h(t) = 0 <= t <= sqrt(10/16) ? 10.0 - 16t^2 : error("t is not in the domain")
````


````
h (generic function with 1 method)
````





We might also have used `NaN` instead of an error, or $0$, as the
falling body would come to rest when it hits the ground.



#### Nesting ternary operators

The function `s(x)` isn't quite so easy to implement, as there isn't an "otherwise" case. We could use an `if` statement, but instead illustrate using a second, nested ternary operator:

````julia

s(x) = x < 0 ? -1 : (x > 0 ? 1 : error("0 is not in the domain"))
````


````
s (generic function with 1 method)
````





With nested ternary operators, the advantage over the `if` condition
is not very compelling, but for simple cases the ternary operator is
quite useful. (The extra parentheses around the expression when `x<0`
is not true are actually unnecessary, though added here for clarity.)

## Functions defined with the "function" keyword


For more complicated functions, say one with a few
steps to compute, an alternate form for defining a function can be
used:

```
function function_name(function_arguments)
  ...function_body...
end
```

The last value computed is returned unless the `function_body`
contains an explicit `return` statement.

For example, the following is a more verbose way to define $f(x) = x^2$:

````julia

function f(x)
  return x^2
end
````


````
f (generic function with 1 method)
````





The line `return x^2`, could have just been `x^2` as it is the last (and) only line evaluated.

````
CalculusWithJulia.WeaveSupport.Alert("The `return` keyword is not a functio
n, so is not called with parentheses. An emtpy `return` statement will retu
rn a value of `nothing`.\n", Dict{Any,Any}(:class => "info"))
````






##### Example


Imagine we have the following complicated function related to the trajectory of a [projectile](http://www.researchgate.net/publication/230963032_On_the_trajectories_of_projectiles_depicted_in_early_ballistic_woodcuts) with wind resistance:

$$~
	f(x) = \left(\frac{g}{k v_0\cos(\theta)} + \tan(\theta) \right) x + \frac{g}{k^2}\ln\left(1 - \frac{k}{v_0\cos(\theta)} x \right)
~$$

Here $g$ is the gravitational constant $9.8$ and $v_0$, $\theta$ and $k$ parameters, which we take to be $200$, $45$ degrees and $1/2$ respectively. With these values, the above function can be computed when $x=100$ with:

````julia

function f(x)
  g, v0, theta, k = 9.8, 200, 45, 1/2
  a = v0 * cosd(theta)

  (g/(k*a) + tand(theta))* x + (g/k^2) * log(1 - k/a*x)
end
f(100)
````


````
96.75771791632161
````





By using a multi-line function our work is much easier to look over for errors.

## Parameters, function context (scope), keyword arguments

Consider two functions implementing the slope-intercept form and point-slope form of a line:

$$~
f(x) = m \cdot x + b, \quad g(x) = y_0 + m \cdot (x - x_0).
~$$

Both functions use the variable $x$, but there is no confusion, as we learn that this is just a dummy variable to be substituted for and so could have any name. Both also share a variable $m$ for a slope. Where does that value come from? In practice, there is a context that gives an answer. Despite the same name, there is no expectation that the slope will be the same for each function if the context is different. So when parameters are involved, a function involves a rule and a context to give specific values to the parameters.



Something similar is also true with `Julia`.  Consider the example of writing a function to model a linear equation with slope $m=2$ and $y$-intercept $3$. A typical means to do this would be to define constants, and then use the familiar formula:

````julia

m, b = 2, 3
f(x) = m*x + b
````


````
f (generic function with 1 method)
````





This will work as expected. For example, $f(0)$ will be $b$  and $f(2)$ will be $7$:

````julia

f(0), f(2)
````


````
(3, 7)
````





All fine, but what if somewhere later the values for $m$ and $b$ were *redefined*:

````julia

m, b = 3, 2
````


````
(3, 2)
````





Now what happens with $f(0)$? When $f$ was defined `b` was $3$, but
now if we were to call `f`, `b` is 2. Which value will we get? More
generally, when `f` is being evaluated in what context does `Julia`
look up the bindings for the variables it encounters? It could be that
the values are assigned when the function is defined, or it could be
that the values for the parameters are resolved when the function is
called. If the latter, what context will be used?


Before discussing this, let's just see in this case:

````julia

f(0)
````


````
2
````





So the `b` is found from the currently stored value. This fact can be exploited. we can write template-like functions, such as `f(x)=mx+b` and reuse them just by updating the parameters separately.



How `Julia` resolves what a variable refers to is described in detail
in the manual page
[Scope of Variables](http://julia.readthedocs.org/en/latest/manual/variables-and-scoping/). In
this case, the function definition finds variables in the context of
where the function was defined, the main workspace. As seen, this
context can be modified after the function definition and prior to the
function call. It is only when `b` is needed, that the context is
consulted, so the most recent binding is retrieved.  Contexts (more
formally known as environments) allow the user to repurpose variable
names without there being name collision. For example, we typically
use `x` as a function argument, and different contexts allow this `x`
to refer to different values.


Mostly this works as expected, but at times it can be complicated to
reason about. In our example, definitions of the parameters can be
forgotten, or the same variable name may have been used for some other
purpose. The potential issue is with the parameters, the value for `x`
is straightforward, as it is passed into the function. However, we can
also pass the parameters, such as $m$ and $b$, as arguments.  For
parameters, we suggest using
[keyword](http://julia.readthedocs.org/en/latest/manual/functions/#keyword-arguments)
arguments. These allow the specification of parameters, but also give
a default value. This can make usage explicit, yet still
convenient. For example, here is an alternate way of defining a line
with parameters `m` and `b`:

````julia

f(x; m=1, b=0) = m*x + b
````


````
f (generic function with 1 method)
````





The right-hand side is identical to before, but the left hand side is
different. Arguments defined *after* a semicolon are keyword
arguments. They are specified as `var=value` (or `var::Type=value` to
restrict the type) where the value is used as the default, should a
value not be specified when the function is called.

Calling a function with keyword arguments can be identical to before:

````julia

f(0)
````


````
0
````





During this call, values for `m` and `b` are found from how the
function is called, not the main workspace. In this case, nothing is
specified so the defaults of $m=1$ and $b=0$ are used. Whereas, this
call will use the user-specified values for `m` and `b`:

````julia

f(0, m=3, b=2)
````


````
2
````





Keywords are used to mark the parameters whose values are to be changed from the default. Though one can use *positional arguments* for parameters - and there are good reasons to do so - using keyword arguments is a good practice if performance isn't paramount, as their usage is more explicit yet the defaults mean that a minimum amount of typing needs to be done.

##### Example

In the example for multi-line functions we hard coded many variables inside the body of the function. In practice it can be better to pass these in as parameters along the lines of:

````julia

function f(x; g = 9.8, v0 = 200, theta = 45, k = 1/2)
  a = v0 * cosd(theta)
  (g/(k*a) + tand(theta))* x + (g/k^2) * log(1 - k/a*x)
end
````


````
f (generic function with 1 method)
````







## Multiple dispatch

The concept of a function is of much more general use than its
restriction to mathematical functions of single real variable. A
natural application comes from describing basic properties of
geometric objects. The following function definitions likely will
cause no great concern when skimmed over:

````julia

Area(w, h) = w * h		                   # of a rectangle
Volume(r, h) = pi * r^2 * h	                   # of a cylinder
SurfaceArea(r, h) = pi * r * (r + sqrt(h^2 + r^2)) # of a right circular cone, including the base
````


````
SurfaceArea (generic function with 1 method)
````





The right-hand sides may or may not be familiar, but it should be
reasonable to believe that if push came to shove, the formulas could be looked
up. However, the left-hand sides are subtly different - they have two
arguments, not one. In `Julia` it is trivial to define functions with
multiple arguments - we just did.


Earlier we saw the `log` function can use a second argument to express
the base. This function is basically defined by `log(b,x)=log(x)/log(b)`. The `log(x)` value is the natural log, and this definition
just uses the change-of-base formula for logarithms.

But not so fast, on the left side is a function with two arguments and on the right side the functions have one argument - yet they share the same name. How does `Julia` know which to use? `Julia` uses the number, order, and *type* of the arguments passed to a function to determine which function definition to use. This is technically known as [multiple dispatch](http://en.wikipedia.org/wiki/Multiple_dispatch) or **polymorphism**. As a feature of the language, it can be used to greatly simplify the number of functions the user must learn. The basic idea is that many functions are "generic" in that they will work for many different scenarios.

````
CalculusWithJulia.WeaveSupport.Alert("Multiple dispatch is very common in m
athematics. For example, we learn different ways to add: integers (fingers,
 carrying), real numbers (align the decimal points), rational numbers (comm
on denominators), complex numbers (add components), vectors (add components
), polynomials (combine like monomials), ... yet we just use the same `+` n
otation for each operation. The concepts are related, the details different
.\n", Dict{Any,Any}())
````





`Julia` is similarly structured.  `Julia` terminology would be to call the operation "`+`" a *generic function* and the different implementations *methods* of "`+`". This allows the user to just need to know a smaller collection of generic concepts yet still have the power of detail-specific implementations.  To see how many different methods are defined in the base `Julia` language for the `+` operator, we can use the command `methods(+)`. As there are so many ($\approx 200$) and that number is growing, we illustrate how many different logarithm methods are implemented for "numbers:"

````julia

methods(log, (Number,)) |> collect
````


````
[1] log(x::Sym) in SymPy at /Users/verzani/julia/SymPy/src/mathfuns.jl:40
[2] log(x::ImplicitEquations.OInterval) in ImplicitEquations at /Users/verz
ani/.julia/packages/ImplicitEquations/H1dxT/src/intervals.jl:216
[3] log(a::Float16) in Base.Math at math.jl:1144
[4] log(a::Complex{Float16}) in Base.Math at math.jl:1145
[5] log(x::Float32) in Base.Math at special/log.jl:289
[6] log(x::Float64) in Base.Math at special/log.jl:253
[7] log(x::BigFloat) in Base.MPFR at mpfr.jl:656
[8] log(::Irrational{:ℯ}) in Base.MathConstants at mathconstants.jl:95
[9] log(z::Complex{T}) where T<:AbstractFloat in Base at complex.jl:563
[10] log(z::Complex{T}) where T<:IntervalArithmetic.Interval in IntervalAri
thmetic at /Users/verzani/.julia/packages/IntervalArithmetic/sRFlx/src/inte
rvals/complex.jl:100
[11] log(z::Complex) in Base at complex.jl:583
[12] log(d::ForwardDiff.Dual{T,V,N} where N where V) where T in ForwardDiff
 at /Users/verzani/.julia/packages/ForwardDiff/sdToQ/src/dual.jl:201
[13] log(a::IntervalArithmetic.Interval{T}) where T in IntervalArithmetic a
t /Users/verzani/.julia/packages/IntervalArithmetic/sRFlx/src/intervals/fun
ctions.jl:307
[14] log(xx::IntervalArithmetic.DecoratedInterval{T}) where T in IntervalAr
ithmetic at /Users/verzani/.julia/packages/IntervalArithmetic/sRFlx/src/dec
orations/functions.jl:349
[15] log(x::Real) in Base.Math at special/log.jl:395
[16] log(x::Unitful.AbstractQuantity{T,NoDims,U} where U where T) in Unitfu
l at /Users/verzani/.julia/packages/Unitful/hsM3B/src/quantities.jl:402
[17] log(x::ModelingToolkit.Expression) in ModelingToolkit at /Users/verzan
i/.julia/packages/ModelingToolkit/qfERv/src/function_registration.jl:62
````





(The arguments have *type annotations* such as `x::Float64` or
`x::BigFloat`. `Julia` uses these to help resolve which method should
be called for a given set of arguments. This allows for different
operations depending on the variable type. For example, in this case,
the `log` function for `Float64` values uses a fast algorithm, whereas
for `BigFloat` values an algorithm that can handle multiple precision
is used.)

##### Example. An application of composition and multiple dispatch

As mentioned `Julia`'s multiple dispatch allows multiple functions with the same name. The function that gets selected depends not just on the type of the arguments, but also on the number of arguments given to the function. We can exploit this to simplify our tasks. For example, consider this optimization problem:

> For all rectangles of perimeter 20, what is the one with largest area?

The start of this problem is to represent the area in terms of one variable. We see next that composition can simplify this task, which when done by hand requires a certain amount of algebra.

Representing the area of a rectangle in terms of two variables is easy, as the familiar formula of width times height applies:

````julia

Area(w, h) = w * h
````


````
Area (generic function with 1 method)
````





But the other fact about this problem - that the perimeter is $20$ - means that height depends on width. For this question, we can see that $P=2w + 2h$ so that - as a function - `h` depends on `w` as follows:

````julia

h(w) = (20  - 2*w)/2
````


````
h (generic function with 1 method)
````





By hand we would substitute this last expression into that for the area and simplify (to get $A=w\cdot (20-2 \cdot w)/2 = -w^2 + 10$). However, within `Julia` we can let *composition* do the substitution and leave the algebraic simplification for `Julia` to do:


````julia

Area(w) = Area(w, h(w))
````


````
Area (generic function with 2 methods)
````





This might seem odd, just like with `log`, we now  have two *different* but related
functions named `Area`. Julia will decide which to use based on the
number of arguments when the function is called. This setup allows both to
be used on the same line, as above. This usage style is not common with
computer languages, but is a feature of `Julia` which is built around
the concept of *generic* functions with multiple dispatch rules to
decide which rule to call.


For example, jumping ahead a bit, the `plot` function of `Plots` (loaded with the accompanying `CalculusWithJulia` package) expects functions of a single numeric
variable. Behind the scenes, then the function `A(w)` will be used in this graph:

````julia

using CalculusWithJulia
using Plots
plot(Area, 0, 10)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





From the graph, we can see that that width for maximum area is $w=5$ and so $h=5$ as well.





## Anonymous functions

Simple mathematical functions have a domain and range which are a subset of the real numbers, and generally have a concrete mathematical rule. However, the definition of a function is much more abstract. We've seen that functions for computer languages can be more complicated too, with, for example, the possibility of multiple input values. Things can get more abstract still.

Take for example, the idea of the shift of a function. The following mathematical definition of a new function $g$ related to a function $f$:

$$~
g(x) = f(x-c)
~$$

has an interpretation - the graph of $g$ will be the same as the graph of $f$ shifted to the right by $c$ units. That is $g$ is a transformation of $f$. From one perspective, the act of replacing $x$ with $x-c$ transforms a function into a new function. Mathematically, when we focus on transforming functions, the word [operator](http://en.wikipedia.org/wiki/Operator_%28mathematics%29) is sometimes used. This concept of transforming a function can be viewed as a certain type of function, in an abstract enough way. The relation would be just pairs of functions $(f,g)$ where $g(x) = f(x-c)$.

With `Julia` we can represent such operations. The simplest thing would be to do something like:

````julia

f(x) = x^2 - 2x
g(x) = f(x -3)
````


````
g (generic function with 1 method)
````





Then $g$ has the graph of $f$ shifted by 3 units to the right. Now `f` above refers to something in the main workspace, in this example a specific function. Better would be to allow `f` to be an argument of a function. So we need to do something like:

````julia

function shift_right(f; c=0)
  function(x)
    f(x - c)
  end
end
````


````
shift_right (generic function with 1 method)
````





That takes some parsing. In the body of the `shift_right` is the
definition of a function. But this function has no name-- it is
*anonymous*. But what it does should be clear - it subtracts $c$ from
$x$ and evaluates $f$ at this new value. Since the last expression
creates a function, this function is returned by `shift_right`.

So we could have done something more complicated like:

````julia

f(x) = x^2 - 2x
l = shift_right(f, c=3)
````


````
#4 (generic function with 1 method)
````





Then `l` is a function that is derived from `f`.

Anonymous functions can be created with the `function` keyword, but we will use the "arrow" notation, `arg->body` to create them, The above, could have been defined as:

````julia

shift_right(f; c=0) = x -> f(x-c)
````


````
shift_right (generic function with 1 method)
````





When the `->` is seen a function is being created.

````
CalculusWithJulia.WeaveSupport.Alert("\nGeneric versus anonymous functions.
 Julia has two types of functions,\ngeneric ones, as defined by `f(x)=x^2` 
and anonymous ones, as defined\nby `x -> x^2`. One gotcha is that `Julia` d
oes not like to use the\nsame variable name for the two types.  In general,
 Julia is a dynamic\nlanguage, meaning variable names can be reused with di
fferent types\nof variables. But generic functions take more care, as when 
a new\nmethod is defined it gets added to a method table. So repurposing th
e\nname of a generic function for something else is not allowed. Similarly,
\nrepurposing an already defined variable name for a generic function is\nn
ot allowed. This comes up when we use functions that return functions\nas w
e have different styles that can be used: When we defined `l =\nshift_right
(f, c=3)` the value of `l` is assigned an anonymous\nfunction. This binding
 can be reused to define other variables.\nHowever, we could have defined t
he function `l` through `l(x) =\nshift_right(f, c=3)(x)`, being explicit ab
out what happens to the\nvariable `x`. This would have made `l` a generic f
unction. Meaning, we\nget an error if we tried to assign a variable to `l`,
 such as an\nexpression like `l=3`. We generally employ the latter style, e
ven though\nit involves a bit more typing, as we tend to stick to generic\n
functions for consistency.\n\n", Dict{Any,Any}())
````





##### Example: the secant line

A secant line is a line through two points on the graph of a function. If we have a function $f(x)$, and two $x$-values $x=a$ and $x=b$, then we can find the slope between the points $(a,f(a))$ and $(b, f(b))$ with:

$$~
m = \frac{f(b) - f(a)}{b - a}.
~$$

The point-slope form a line then gives the equation of the tangent line as $y = f(a) + m \cdot (x - a)$.

To model this in `Julia`, we would want to turn the inputs `f`,`a`, `b` into a function that implements the secant line (functions are much easier to work with than equations). Here is how we can do it:

````julia

function secant(f, a, b)
   m = (f(b) - f(a)) / (b-a)
   x -> f(a) + m * (x - a)
end
````


````
secant (generic function with 1 method)
````





The body of the function nearly mirrors the mathematical treatment. The main difference is in place of $y = \dots$ we have a `x -> ...` to create an anonymous function.

To illustrate the use, suppose $f(x) = x^2 - 2$ and we have the secant line between $a=1$ and $b=2$. The value at $x=3/2$ is given by:

````julia

f(x) = x^2 - 2
a,b = 1, 2
secant(f,a,b)(3/2)
````


````
0.5
````





The last line employs double parentheses. The first pair, `secant(f,a,b)`, returns a function and the second pair, `(3/2)`, are used to call the returned function.

##### Example: the secant method for finding a solution to $f(x) = 0$.

This last example, shows how using functions to collect a set of computations for simpler reuse can be very helpful.

An old method for finding a zero of an equation is the [secant
method](https://en.wikipedia.org/wiki/Secant_method). We illustrate
the method with the function $f(x) = x^2 - 2$. In the last example we
saw how to create a function to evaluate the secant line between
$(a,f(a))$ and $(b, f(b))$ at any point. In this example, we define a
function to compute the $x$ coordinate of where the secant line
crosses the $x$ axis. This can be defined as follows:

````julia

function secant_intersection(f, a, b)
   # solve 0 = f(b) + m * (x-b) where m is the slope of the secant line
   # x = b - f(b) / m
   m = (f(b) - f(a)) / (b - a)
   b - f(b) / m
end
````


````
secant_intersection (generic function with 1 method)
````





We utilize this as follows. Suppose we wish to solve $f(x) = 0$ and we
have two "rough" guesses for the answer. In our example, we wish to
solve $f(x) = x^2 - 2$ and our "rough" guesses are $1$ and $2$. Call
these values $a$ and $b$. We *improve* our rough guesses by finding a
value $c$ which is the intersection point of the secant line.

````julia

f(x) = x^2 - 2
a, b = 1, 2
c = secant_intersection(f, a, b)
````


````
1.3333333333333335
````





In our example, we see that in trying to find an answer to $f(x) = 0$
( $\sqrt{2}\approx 1.414\dots$) our value found from the intersection
point is a better guess than either $a=1$ or $b=2$:

````
Plot{Plots.PlotlyBackend() n=4}
````





Still,  `f(c)` is not really close to $0$:

````julia

f(c)
````


````
-0.22222222222222188
````





*But* it is much closer than either $f(a)$ or $f(b)$, so it is an improvement. This suggests renaming $a$ and $b$ with the old $b$ and $c$ values and trying again we might do better still:

````julia

a, b = b, c
c = secant_intersection(f, a, b)
f(c)
````


````
-0.03999999999999959
````





Yes, now the function value at this new $c$ is even closer to $0$. Trying a few more times we see we just get closer and closer:

````julia

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
````


````
8.881784197001252e-16
````





Now our guess $c$ is basically the same as `sqrt(2)`. Repeating the above leads to only a slight improvement in the guess, as we are about as close as floating point values will allow.

Here we see a visualization with all these points. As can be seen, it
quickly converges at the scale of the visualization, as we can't see
much closer than `1e-2`.

````
Plot{Plots.PlotlyBackend() n=8}
````







In most cases, this method can fairly quickly find a zero provided two good starting points are used.



## Questions

##### Question

State the domain and range of $f(x) = |x + 2|$.

````
CalculusWithJulia.WeaveSupport.Radioq(["Domain is all non-negative numbers,
 range is all non-negative numbers", "Domain is all real numbers, range is 
all real numbers", "Domain is all non-negative numbers, range is all real n
umbers", "Domain is all real numbers, range is all non-negative numbers"], 
4, "", nothing, [1, 2, 3, 4], ["Domain is all non-negative numbers, range i
s all non-negative numbers", "Domain is all real numbers, range is all real
 numbers", "Domain is all non-negative numbers, range is all real numbers",
 "Domain is all real numbers, range is all non-negative numbers"], "", fals
e)
````





##### Question

State the domain and range of $f(x) = 1/(x-2)$.


````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"Domain is all real n
umbers except $2$, range is all real numbers except $0$", L"Domain is all n
on-negative numbers except $0$, range is all real numbers except $2$", "Dom
ain is all real numbers, range is all real numbers", L"Domain is all non-ne
gative numbers except $-2$, range is all non-negative numbers except $0$"],
 1, "", nothing, [1, 2, 3, 4], AbstractString[L"Domain is all real numbers 
except $2$, range is all real numbers except $0$", L"Domain is all non-nega
tive numbers except $0$, range is all real numbers except $2$", "Domain is 
all real numbers, range is all real numbers", L"Domain is all non-negative 
numbers except $-2$, range is all non-negative numbers except $0$"], "", fa
lse)
````





##### Question

Which of these functions has a domain of all real $x$, but a range of $x > 0$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$f(x) = 1/
x^2$", L"$f(x) = \sqrt{x}$", L"$f(x) = |x|$", L"$f(x) = 2^x$"], 4, "", noth
ing, [1, 2, 3, 4], LaTeXStrings.LaTeXString[L"$f(x) = 1/x^2$", L"$f(x) = \s
qrt{x}$", L"$f(x) = |x|$", L"$f(x) = 2^x$"], "", false)
````






###### Question

Which of these commands will make a function for $f(x) = \sin(x + \pi/3)$?

````
CalculusWithJulia.WeaveSupport.Radioq(["`f x = sin(x + pi/3)`", "`function 
f(x) = sin(x + pi/3)`", "`f(x)  = sin(x + pi/3)`", "`f = sin(x + pi/3)`", "
`f: x -> sin(x + pi/3)`"], 3, "", nothing, [1, 2, 3, 4, 5], ["`f x = sin(x 
+ pi/3)`", "`function f(x) = sin(x + pi/3)`", "`f(x)  = sin(x + pi/3)`", "`
f = sin(x + pi/3)`", "`f: x -> sin(x + pi/3)`"], "", false)
````





###### Question

Which of these commands will create a function for $f(x) = (1 + x^2)^{-1}$?

````
CalculusWithJulia.WeaveSupport.Radioq(["`f[x] =  (1 + x^2)^(-1)`", "`f(x) :
= (1 + x^2)^(-1)`", "`function f(x) = (1 + x^2)^(-1)`", "`def f(x): (1 + x^
2)^(-1)`", "`f(x) = (1 + x^2)^(-1)`"], 5, "", nothing, [1, 2, 3, 4, 5], ["`
f[x] =  (1 + x^2)^(-1)`", "`f(x) := (1 + x^2)^(-1)`", "`function f(x) = (1 
+ x^2)^(-1)`", "`def f(x): (1 + x^2)^(-1)`", "`f(x) = (1 + x^2)^(-1)`"], ""
, false)
````






###### Question

Will the following `Julia` commands create a function for

$$~
f(x) = \begin{cases}
30 & x < 500\\
30 + 0.10 \cdot (x-500) & \text{otherwise.}
\end{cases}
~$$

````julia

f(x) = x < 500 ? 30.0 : 30 + 0.10 * (x-500)
````


````
f (generic function with 1 method)
````



````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", true)
````






###### Question

The expression `max(0, x)` will be `0` if `x` is negative, but otherwise will take the value of `x`. Is this the same?

````julia

f(x) = x < 0 ? x : 0.0
````


````
f (generic function with 1 method)
````



````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````






###### Question

In statistics, the normal distribution has two parameters $\mu$ and $\sigma$ appearing as:

$$~
f(x; \mu, \sigma) = \frac{1}{\sqrt{2\pi\sigma}} e^{-\frac{1}{2}\frac{(x-\mu)^2}{\sigma}}.
~$$

Does this function implement this with the default values of $\mu=0$ and $\sigma=1$?

````julia

f(x; mu=0, sigma=1) = 1/sqrt(2pi*sigma) * exp(-(1/2)*(x-mu)^2/sigma)
````


````
f (generic function with 1 method)
````



````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", true)
````





What value of $\mu$ is used if the function is called as `f(x, sigma=2.7)`?

````
CalculusWithJulia.WeaveSupport.Numericq(0, 0, "", "[0.0, 0.0]", 0, 0, "", "
")
````






What value of $\mu$ is used if the function is called as `f(x, mu=70)`?

````
CalculusWithJulia.WeaveSupport.Numericq(70, 0, "", "[70.0, 70.0]", 70, 70, 
"", "")
````





What value of $\mu$ is used if the function is called as `f(x, mu=70, sigma=2.7)`?

````
CalculusWithJulia.WeaveSupport.Numericq(70, 0, "", "[70.0, 70.0]", 70, 70, 
"", "")
````






###### Question

`Julia` has keyword arguments (as just illustrated) but also
positional arguments. These are matched by how the function is
called. For example,

````julia

A(w, h) = w*h
````


````
A (generic function with 1 method)
````





when called as `A(10, 5)` will use 10 for `w` and `5` for `h`, as the
order of `w` and `h` matches that of `10` and `5` in the call.

This is clear enough, but in fact positional arguments can have
default values (then called
[optional](http://julia.readthedocs.org/en/latest/manual/functions/#optional-arguments))
arguments). For example,

````julia

B(w, h=5) = w*h
````


````
B (generic function with 2 methods)
````





Actually creates two functions: `B(w,h)` for when the call is, say, `B(10,5)` and `B(w)` when the call is `B(10)`.

Suppose a function `C` is defined by

````julia

C(x, mu=0, sigma=1) = 1/sqrt(2pi*sigma) * exp(-(1/2)*(x-mu)^2/sigma)
````


````
C (generic function with 3 methods)
````





This is *nearly* identical to the last question, save for a comma
instead of a semicolon after the `x`.

What value of `mu` is used by the call `C(1, 70, 2.7)`?

````
CalculusWithJulia.WeaveSupport.Numericq(70, 0, "", "[70.0, 70.0]", 70, 70, 
"", "")
````





What value of `mu` is used by the call `C(1, 70)`?

````
CalculusWithJulia.WeaveSupport.Numericq(70, 0, "", "[70.0, 70.0]", 70, 70, 
"", "")
````





What value of `mu` is used by the call `C(1)`?

````
CalculusWithJulia.WeaveSupport.Numericq(0, 0, "", "[0.0, 0.0]", 0, 0, "", "
")
````





Will the call `C(1, mu=70)` use a value of `70` for `mu`?

````
CalculusWithJulia.WeaveSupport.Radioq(["No, there will be an error that the
 function does not accept keyword arguments", "Yes, this will work just as 
it does for keyword arguments"], 1, "", nothing, [1, 2], ["No, there will b
e an error that the function does not accept keyword arguments", "Yes, this
 will work just as it does for keyword arguments"], "", false)
````





###### Question

This function mirrors that of the built-in `clamp` function:

````julia

klamp(x, a, b) = x < a ? a : (x > b ? b : x)
````


````
klamp (generic function with 1 method)
````





Can you tell what it does?

````
CalculusWithJulia.WeaveSupport.Radioq(["If `x` is in `[a,b]` it returns `x`
, otherwise it returns `a` when `x` is less than `a` and `b` when  `x` is g
reater than `b`.", "If `x` is in `[a,b]` it returns `x`, otherwise it retur
ns `NaN`", "`x` is the larger of the minimum of `x` and `a` and the value o
f `b`, aka `max(min(x,a),b)`"], 1, "", nothing, [1, 2, 3], ["If `x` is in `
[a,b]` it returns `x`, otherwise it returns `a` when `x` is less than `a` a
nd `b` when  `x` is greater than `b`.", "If `x` is in `[a,b]` it returns `x
`, otherwise it returns `NaN`", "`x` is the larger of the minimum of `x` an
d `a` and the value of `b`, aka `max(min(x,a),b)`"], "", false)
````






###### Question

`Julia` has syntax for the composition of  functions $f$ and $g$ using the Unicode operator `∘` entered as `\circ[tab]`.

The notation to call a composition follows the math notation, where parentheses are necessary to separate the act of composition from the act of calling the function:

$$~
(f \circ g)(x)
~$$


For example

````julia

(sin ∘ cos)(pi/4)
````


````
0.6496369390800625
````





What happens if you forget the extra parentheses and were to call `sin ∘ cos(pi/4)`?


````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"You still get $0.649
...$", "You get a `MethodError`, as `cos(pi/4)` is evaluated as a number an
d `∘` is not defined for functions and numbers", "You get a `generic` funct
ion, but this won't be callable. If tried, it will give an method error."],
 2, "", nothing, [1, 2, 3], AbstractString[L"You still get $0.649...$", "Yo
u get a `MethodError`, as `cos(pi/4)` is evaluated as a number and `∘` is n
ot defined for functions and numbers", "You get a `generic` function, but t
his won't be callable. If tried, it will give an method error."], "", false
)
````





###### Question

The [pipe](http://julia.readthedocs.org/en/latest/stdlib/base/#Base.|>) notation `ex |> f` takes the output of `ex` and uses it as the input to the function `f`. That is composition. What is the value of this expression `1 |> sin |> cos`?

````
CalculusWithJulia.WeaveSupport.Radioq(["It is `0.6663667453928805`, the sam
e as `cos(sin(1))`", "It is `0.5143952585235492`, the same as `sin(cos(1))`
", "It gives an error"], 1, "", nothing, [1, 2, 3], ["It is `0.666366745392
8805`, the same as `cos(sin(1))`", "It is `0.5143952585235492`, the same as
 `sin(cos(1))`", "It gives an error"], "", false)
````





###### Question

`Julia` has implemented this *limited* set of algebraic operations on functions: `∘` for *composition* and `!` for *negation*. (Read `!` as "not.") The latter is useful for "predicate" functions (ones that return either `true` or `false`. What is output by this command?

````julia

fn = !iseven
fn(3)
````



````
CalculusWithJulia.WeaveSupport.Radioq(["true", "false"], 1, "", nothing, [1
, 2], ["true", "false"], "", true)
````





###### Question

Generic functions in `Julia` allow many algorithms to work without change for different number types. For example, [3000](https://pdfs.semanticscholar.org/1ef4/ee58a159dc7e437e190ec2839fb9a654596c.pdf) years ago, floating point numbers wouldn't have been used to carry out the secant method computations, rather rational numbers would have been. We can see the results of using rational numbers with no change to our key function, just by starting with rational numbers for `a` and `b`:


````julia

secant_intersection(f, a, b) = b - f(b) * (b - a) / (f(b) - f(a))  # rewritten
f(x) = x^2 - 2
a, b = 1//1, 2//1
c = secant_intersection(f, a, b)
````


````
4//3
````





Now `c` is `4//3` and not `1.333...`. This works as the key operations
used: division, squaring, subtraction all have different
implementations for rational numbers that preserve this type.

Repeat the secant method two more times to find a better approximation for $\sqrt{2}$. What is the value of `c` found?

````
CalculusWithJulia.WeaveSupport.Radioq(["`4//3`", "`7//5`", "`58//41`", "`81
6//577`"], 3, "", nothing, [1, 2, 3, 4], ["`4//3`", "`7//5`", "`58//41`", "
`816//577`"], "", false)
````





How small is the value of $f(c)$ for this value?

````
CalculusWithJulia.WeaveSupport.Numericq(0.0011897679952408424, 0.001, "", "
[0.00019, 0.00219]", 0.0001897679952408424, 0.0021897679952408424, "", "")
````





How close is this answer to the true value of $\sqrt{2}$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"about $8$ 
parts in $100$", L"about $1$ parts in $100$", L"about $4$ parts in $10,000$
", L"about $2$ parts in $1,000,000$"], 3, "", nothing, [1, 2, 3, 4], LaTeXS
trings.LaTeXString[L"about $8$ parts in $100$", L"about $1$ parts in $100$"
, L"about $4$ parts in $10,000$", L"about $2$ parts in $1,000,000$"], "", f
alse)
````





(Finding a good approximation to $\sqrt{2}$ would be helpful to builders, for example, as it could be used to verify the trueness of a square room, say.)

###### Question

`Julia` does not have surface syntax for the *difference* of functions. This is a common thing to want when solving equations. The tools available solve $f(x)=0$, but problems may present as solving for $h(x) = g(x)$ or even $h(x) = c$, for some constant. Which of these solutions is **not** helpful if $h$ and $g$ are already defined?

````
CalculusWithJulia.WeaveSupport.Radioq(["Just use `f = h - g`", "Use `x -> h
(x) - g(x)` when the difference is needed", "Define `f(x) = h(x) - g(x)`"],
 1, "", nothing, [1, 2, 3], ["Just use `f = h - g`", "Use `x -> h(x) - g(x)
` when the difference is needed", "Define `f(x) = h(x) - g(x)`"], "", false
)
````


