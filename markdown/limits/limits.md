# Limits






An historic problem in the history of math was to find the area under
the graph of $f(x)=x^2$ between $[0,1]$.



There isn't a ready-made formula for the area of this
shape, as there is for a triangle or a square. However,
[Archimedes](http://en.wikipedia.org/wiki/The_Quadrature_of_the_Parabola)
found a method to compute areas enclosed by a parabola and line
segments that cross the parabola.

````
CalculusWithJulia.WeaveSupport.ImageFile("/var/folders/k0/94d1r7xd2xlcw_jkg
qq4h57w0000gr/T/jl_fx7HVO.gif", L"The first triangle has area $1/2$, the se
cond has area $1/8$, then $2$ have area $(1/8)^2$, $4$ have area $(1/8)^3$,
 ...
With some algebra, the total area then should be $1/2 \cdot (1 + (1/4) + (1
/4)^2 + \cdots) = 2/3$.
")
````





The figure illustrates a means to compute the area bounded by the
parabola, the line $y=1$ and the line $x=0$ using triangles. It
suggests that this area can be found by adding the following sum

$$~
A = 1/2 + 1/8 + 2 \cdot (1/8)^2 + 4 \cdot (1/8)^3 + \cdots
~$$

This value is $2/3$, so the area under the curve would be
$1/3$. Forget about this specific value - which through more modern machinery becomes uneventful - and focus for a minute on the
method: a problem is solved by a suggestion of an infinite process, in
this case the creation of more triangles to approximate the
unaccounted for area. This is the so-call method of
[exhaustion](http://en.wikipedia.org/wiki/Method_of_exhaustion) known
since the 5th century BC. Archimedes used this method to solve a wide
range of area problems related to basic geometric shapes, including a
more general statement of what we described above.

The $\cdots$ in the sum expression are the indication that this process continues and that
the answer is at the end of an *infinite* process. To make this line of
reasoning rigorous requires the concept of a limit. The concept of a
limit is then an old one, but it wasn't until the age of calculus
that it was formalized.

[Fermat](http://en.wikipedia.org/wiki/Adequality) in the 1600s
essentially took a limit to find the slope of a tangent line to a
polynomial curve. Newton in the late 1600s, exploited the idea in his
development of calculus (as did Leibniz). Yet it wasn't until the
1800s that
[Bolzano](http://en.wikipedia.org/wiki/Limit_of_a_function#History),
Cauchy and Weierstrass put the idea on a firm footing.


To make things more precise, we begin by discussing the limit of a univariate function as $x$ approaches $c$.

Informally, if a limit exists it is the value that $f(x)$ gets close to as $x$ gets close to - but not equal to - $c$.

The modern formulation is due to Weirstrass:

> The limit of $f(x)$ as $x$ approaches $c$ is $L$ if for every real $\epsilon > 0$,
> there exists a real $\delta > 0$ such that for all real $x$, $0 < \lvert x − c \rvert < \delta$
> implies $\lvert f(x) − L \rvert < \epsilon$. The notation used is $\lim_{x \rightarrow c}f(x) = L$.

We comment on this later.


Cauchy begins his incredibly influential
[treatise](http://gallica.bnf.fr/ark:/12148/bpt6k90196z/f25.image) on
calculus considering two examples, the limit as $x$ goes to $0$ of

$$~ \frac{\sin(x)}{x} \quad\text{and}\quad (1 + x)^{1/x}.  ~$$

These take the indeterminate forms $0/0$ and $1^\infty$, which are
found by just putting $0$ in for $x$. An expression does not need to
be defined at $c$, as these two aren't, to discuss its limit. Cauchy
illustrates two methods to approach the questions above. The first is
to pull out an inequality:

$$~
\frac{\sin(x)}{\sin(x)} > \frac{\sin(x)}{x} > \frac{\sin(x)}{\tan(x)}.
~$$

This bounds the expression $\sin(x)/x$ between $1$ and $\cos(x)$ and as $x$ gets close to $0$, the value of $\cos(x)$ "clearly" goes to $1$, hence $L$ must be $1$. This is an application of the squeeze theorem.

To discuss the case of $(1+x)^{1/x}$, Cauchy first resorts to log tables
to illustrate an approximate value. We can use `Julia` to find his
approximate value:

````julia

x = 1/10000
(1 + x)^(1/x)
````


````
2.7181459268249255
````





A table can show the progression to this value:

````julia

f(x) = (1 + x)^(1/x)
xs = [1/10^i for i in 1:5]
[xs f.(xs)]
````


````
5×2 Array{Float64,2}:
 0.1     2.59374
 0.01    2.70481
 0.001   2.71692
 0.0001  2.71815
 1.0e-5  2.71827
````





However viewed, this is an approximate value for the actual answer - which is $e$. Cauchy
demonstrates this value with a fair amount of work.

These two cases illustrate that though the definition of the limit
exists, the computation of a limit is generally found by other means
and the intuition of the value of the limit can be gained numerically.

### Indeterminate forms

First it should be noted that for most of the functions encountered, the concepts of a limit at a typical point $c$ is nothing more than just function evaluation at $c$. This is because, at a typical point, the functions are nicely behaved. However, most questions asked about limits find points that are not typical. For these, the result of evaluating the function at $c$ is typically undefined, and the value comes in one of several *indeterminate forms*: $0/0$, $\infty/\infty$, $0 \cdot \infty$, $\infty - \infty$, $0^0$, $1^\infty$, and $\infty^0$.

`Julia` can help - at times - identify these indeterminate forms, as many such operations produce `NaN`. For example:

````julia

0/0, Inf/Inf, 0 * Inf, Inf - Inf
````


````
(NaN, NaN, NaN, NaN)
````





However, the values with powers generally do not help, as the IEEE standard has `0^0` evaluating to 1:

````julia

0^0, 1^Inf, Inf^0
````


````
(1, 1.0, 1.0)
````





However, this can be unreliable, as floating point issues may mask the true evaluation. However, as a cheap trick it can work. So, the limit as $x$ goes to $1$ of $\sin(x)/x$ is simply found by evaluation:

````julia

x = 1
sin(x) / x
````


````
0.8414709848078965
````





But at $x=0$ we get an indicator that there is an issue with just evaluating the function:

````julia

x = 0
sin(x) / x
````


````
NaN
````





The above is really just a heuristic. For some functions this is just
not true. For example, the $f(x) = \sqrt{x}$ is only defined on $[0,
\infty)$ There is technically no limit at $0$, per se, as the function
is not defined around $0$. Other functions jump at values, and will
not have a limit, despite having well defined values. The `floor`
function is the function that rounds down to the nearest integer. At
integer values there will be a jump, even though the function is
defined.

## Graphical approaches to limits

Let's return to the function $f(x) = \sin(x)/x$. This function was studied by Euler as part of his solution to the [Basel](http://en.wikipedia.org/wiki/Basel_problem) problem. He knew that near $0$, $\sin(x) \approx x$, so the ratio is close to $1$ if $x$ is near $0$. Hence, the intuition is $\lim_{x \rightarrow 0} \sin(x)/x = 1$, as Cauchy wrote. We can verify this limit graphically two ways. First, a simple graph shows no issue at $0$:

````julia

using CalculusWithJulia  # loads SymPy
using Plots
f(x) = sin(x)/x
plot(f, -pi/2, pi/2)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The $y$ values of the graph seem to go to $1$ as the $x$ values get
close to 0. (That the graph looks defined at $0$ is due to the fact
that the points sampled to graph do not include $0$. Otherwise, since
`f(0)` is `NaN`, there would be no lines connecting to the value with
`x=0`.)

We can also verify Euler's intuition through this graph:

````julia

plot([sin, x -> x], -pi/2,  pi/2)
````


````
Plot{Plots.PlotlyBackend() n=2}
````





That the two are indistinguishable near $0$ makes it easy to see that their ratio should be going towards $1$.


The graphical approach to limits - plotting $f(x)$ around $c$ and
observing if the $y$ values seem to converge to an $L$ value when $x$
get close to $c$ - allows us to gather quickly if a function seems to
have a limit at $c$, though the precise value of $L$ may be hard to identify.

##### Example


Consider now the following limit

$$~
\lim_{x \rightarrow 2} \frac{x^2 - 5x + 6}{x^2 +x - 6}
~$$

Noting that this is a ratio of nice polynomial functions, we first
check whether there is anything to do:

````julia

f(x) = (x^2 - 5x + 6) / (x^2 + x - 6)
c = 2
f(c)
````


````
NaN
````





The `NaN` indicates that this function is indeterminate at $c=2$. A
quick plot gives us an idea that the limit exists and is roughly
$-0.2$:

````julia

c, delta = 2, 1
plot(f, c - delta, c + delta)
````


````
Plot{Plots.PlotlyBackend() n=1}
````






The graph looks "continuous." In fact, the value $c=2$ is termed a
*removable singularity* as redefining $f(x)$ to be $-0.2$ when
$x=2$ results in a "continuous" function.

As an aside, we can redefine `f` using the "ternary operator":

````julia

f(x) = x == 2.0 ? -0.2 :  (x^2 - 5x + 6) / (x^2 + x - 6)
````


````
f (generic function with 1 method)
````





This particular case is a textbook example: one can easily factor
$f(x)$ to get:

$$~
f(x) = \frac{(x-2)(x-3)}{(x-2)(x+3)}
~$$

Written in this form, we clearly see that this is the same function as
$g(x) = (x-3)/(x+3)$ when $x \neq 2$. The function $g(x)$ is
"continuous" at $x=2$. So were one to redefine $f(x)$ at $x=2$ to be
$g(2) = (2 - 3)/(2 + 3) = -0.2$ it would be made continuous, hence the
term removable singularity.



## Numerical approaches to limits

The investigation of $\lim_{x \rightarrow 0}(1 + x)^{1/x}$ by
evaluating the function at $1/10000$ by Cauchy can be done much more easily
nowadays. As does a graphical approach, a numerical approach can
give insight into a limit and often a good numeric estimate.

The basic idea is to create a sequence of $x$ values going towards $c$
and then investigate if the corresponding $y$ values are eventually near some
$L$.

Best, to see by example. Suppose we are asked to investigate

$$~
\lim_{x \rightarrow 25} \frac{\sqrt{x} - 5}{\sqrt{x - 16} - 3}.
~$$

We first define a function and check if there are issues at 25:

````julia

f(x) = (sqrt(x) - 5) / (sqrt(x-16) - 3)
c = 25
f(c)
````


````
NaN
````





So yes, an issue of the indeterminate form $0/0$. We investigate numerically by making a set of numbers getting close to $c$. This is most easily done making numbers getting close to $0$ and adding them to or subtracting them from $c$. Some natural candidates are negative powers of 10:

````julia

hs = [1/10^i for i in 1:8]
````


````
8-element Array{Float64,1}:
 0.1
 0.01
 0.001
 0.0001
 1.0e-5
 1.0e-6
 1.0e-7
 1.0e-8
````





We can add these to $c$ and then evaluate:

````julia

xs = c .+ hs
ys = f.(xs)
````


````
8-element Array{Float64,1}:
 0.6010616008415922
 0.6001066157341047
 0.6000106661569936
 0.6000010666430725
 0.6000001065281493
 0.6000000122568625
 0.5999999946709295
 0.6
````





To visualize, we can put in a table using `[xs ys]` notation:

````julia

[xs ys]
````


````
8×2 Array{Float64,2}:
 25.1     0.601062
 25.01    0.600107
 25.001   0.600011
 25.0001  0.600001
 25.0     0.6
 25.0     0.6
 25.0     0.6
 25.0     0.6
````





The $y$-values seem to be getting near $0.6$.

Since limits are defined by the expression $0 < \lvert x-c\rvert < \delta$, we should also look at values smaller than $c$. There isn't much difference (note the `.-` sign in `c .- hs`):

````julia

xs = c .- hs
ys = f.(xs)
[xs ys]
````


````
8×2 Array{Float64,2}:
 24.9     0.598928
 24.99    0.599893
 24.999   0.599989
 24.9999  0.599999
 25.0     0.6
 25.0     0.6
 25.0     0.6
 25.0     0.6
````





Same story. The numeric evidence supports a limit of $L=0.6$.

##### Example, the secant line

Let $f(x) = x^x$ and consider the ratio:

$$~
\frac{f(c + h) - f(c)}{h}
~$$

As $h$ goes to $0$, this will take the form $0/0$ in most cases, and
in the particular case of $f(x) = x^x$ and $c=1$ it will be. The
expression has a geometric interpretation of being the slope of the
secant line connecting the two points $(c,f(c))$ and $(c+h, f(c+h))$.

To look at the limit in this example, we have (recycling the values in `hs`):

````julia

c = 1
f(x) = x^x
ys = [(f(c + h) - f(c)) / h for  h in hs]
[hs ys]
````


````
8×2 Array{Float64,2}:
 0.1     1.10534
 0.01    1.01005
 0.001   1.001
 0.0001  1.0001
 1.0e-5  1.00001
 1.0e-6  1.0
 1.0e-7  1.0
 1.0e-8  1.0
````





The limit looks like $L=1$. A similar check on the left will confirm this numerically:

````julia

ys = [(f(c + h) - f(c)) / h for  h in -hs]
[-hs ys]
````


````
8×2 Array{Float64,2}:
 -0.1     0.904674
 -0.01    0.99005
 -0.001   0.999
 -0.0001  0.9999
 -1.0e-5  0.99999
 -1.0e-6  0.999999
 -1.0e-7  1.0
 -1.0e-8  1.0
````









### Issues with the numeric approach

The numeric approach often gives a good intuition as to the existence of a limit and its value. However, it can be misleading. Consider this limit question:

$$~
\lim_{x \rightarrow 0} \frac{1 - \cos(x)}{x^2}.
~$$

We can see that it is indeterminate of the form $0/0$:

````julia

f(x) = (1 - cos(x)) / x^2
f(0)
````


````
NaN
````





What is the value of $L$, if it exists? A quick attempt numerically yields:

````julia

c = 0
xs = c .+ hs
ys = [f(x) for x in xs]
[xs ys]
````


````
8×2 Array{Float64,2}:
 0.1     0.499583
 0.01    0.499996
 0.001   0.5
 0.0001  0.5
 1.0e-5  0.5
 1.0e-6  0.500044
 1.0e-7  0.4996
 1.0e-8  0.0
````





Hmm, the values in `ys` appear to be going to $0.5$, but then end up at
$0$. Is the limit $0$ or $1/2$? The answer is $1/2$. The last $0$ is
an artifact of floating point arithmetic. To investigate, we look more carefully at the two ratios:

````julia

y1s = [1 - cos(x) for x in xs]
y2s = [x^2 for x in xs]
[xs y1s y2s]
````


````
8×3 Array{Float64,2}:
 0.1     0.00499583   0.01
 0.01    4.99996e-5   0.0001
 0.001   5.0e-7       1.0e-6
 0.0001  5.0e-9       1.0e-8
 1.0e-5  5.0e-11      1.0e-10
 1.0e-6  5.00044e-13  1.0e-12
 1.0e-7  4.996e-15    1.0e-14
 1.0e-8  0.0          1.0e-16
````





Looking at the bottom of the second column reveals the error. The value of `1 - cos(1.0e-8)` is
`0` and not a value around `5e-17`, as would be expected from the pattern above it. This is because the smallest
floating point value less than `1.0` is more than `5e-17` units away,
so `cos(1e-8)` is evaluated to be `1.0`. There just isn't enough
granularity to get this close to $0$.

Not that we needed to. The answer would have been clear if we had
stopped with `x=1e-6`, say.

In general, some functions will frustrate the numeric approach. It is
best to be wary of results. At a minimum they should confirm what a quick
graph shows.

## Symbolic approach to limits

The `SymPy` package provides a `limit` function for finding the limit
of an expression in a given variable. It is loaded above, when the `CalculusWithJulia` package was loaded. The `limit` function's use requires the expression,
the variable and a value for $c$. (Similar to the three things in the
notation $\lim_{x \rightarrow c}f(x)$.)

For example, the limit at $0$ of $(1-\cos(x))/x^2$ is easily handled:

````julia

@vars x real=true
f(x) = (1 - cos(x)) / x^2
limit(f(x), x=>0)		# f(x) is a symbolic expression when x is
````


````
1/2
````





The pair notation (`x=>0`) is used to indicate the variable and the value it is going to.

As a convenience, there is also an "operator" version of `limit` for univariate functions, where only a function object and `c` need be specified:

````julia

limit(f, 0)
````


````
1/2
````





##### Examples

Find the [limits](http://en.wikipedia.org/wiki/L%27H%C3%B4pital%27s_rule):

$$~
\lim_{x \rightarrow 0} \frac{2\sin(x) - \sin(2x)}{x - \sin(x)}, \quad
\lim_{x \rightarrow 0} \frac{e^x - 1 - x}{x^2}, \quad
\lim_{\rho \rightarrow 0} \frac{x^{1-\rho} - 1}{1 - \rho}.
~$$

We have for the first:

````julia

limit( (2sin(x) - sin(2x)) / (x - sin(x)), x=>0)
````


````
6
````





The second is similarly done, though here we define a function for variety:

````julia

f(x) = (exp(x) - 1 - x) / x^2
limit(f, 0)
````


````
1/2
````





Finally, for the third we define a new variable and proceed:

````julia

@vars rho real=true
limit( (x^(1-rho) - 1) / (1 - rho), rho=>1)
````


````
log(x)
````





##### Example, floating point conversion issues

The [algorithm](http://www.cybertester.com/data/gruntz.pdf)
implemented in `SymPy` for symbolic limits is quite powerful. However,
some care must be exercised to avoid undesirable conversions from
exact values to floating point values.


To Illustrate, let's look at the limit as $x$ goes to $\pi/2$ of $f(x)
= \cos(x) / (x - \pi/2)$. We follow our past practice:

````julia

c = pi/2
f(x) = cos(x) / (x - pi/2)
f(c)
````


````
Inf
````





The value is not `NaN`, rather `Inf`. This is because `cos(pi/2)` is
not exactly $0$ as it should be, as `pi/2` is rounded. This minor
difference is important. If we try and correct for this by using `PI` we have:

````julia

limit(f(x), x=>PI/2)
````


````
0
````





The value is not right, as this simple graph suggests the limit is in fact $-1$:

````julia

plot(f, c - pi/4, c + pi/4)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The difference between `pi` and `PI` can be significant, and though
usually `pi` is silently converted to `PI`, it doesn't happen here as
the division by `2` happens first, which turns the symbol into an approximate
floating point number. Hence, `SymPy` is giving the correct answer for
the problem it is given, it just isn't the problem we wanted to look
at.

Trying again, being more aware of how `pi` and `PI` differ, we have:

````julia

f(x) = cos(x) / (x - PI/2)
limit(f(x), x => PI/2)
````


````
-1
````





## Rules for limits

The `limit` function doesn't compute limits from the definition,
rather it applies some known facts about functions within a set of
rules. Some of these rules are the following. Suppose the individual limits of $f$ and $g$ always exist below.

````
CalculusWithJulia.WeaveSupport.Table(4×2 DataFrame. Omitted printing of 2 c
olumns
│ Row │ │     │ ├─────┼
│ 1   │ │ 2   │ │ 3   │ │ 4   │ )
````






These, together with the fact that our basic algebraic functions have limits
that can be found by simple evaluation, mean that many limits are easy to
compute.

##### Example, composition

For example, consider for some non-zero $k$ the following limit:

$$~
\lim_{x \rightarrow 0} \frac{\sin(kx)}{x}.
~$$

This is clearly related to the function $f(x) = \sin(x)/x$, but is in fact the limit of the function $g(x) = k f(kx)$. This then follows:


$$~
\lim_{x \rightarrow 0} \frac{\sin(kx)}{x} = \lim_{x \rightarrow 0} k f(kx) = k \lim_{x \rightarrow 0} f(kx) = k\lim_{x \rightarrow 0} f(x) = k.
~$$

Why does the limit of $f(kx)$ at 0 equal the limit of $f(x)$ at 0?
Well, $f(kx)$ is a composition, $f(h(x))$ where $h(x) = kx$. The limit
of $h$ at 0 is 0, so this is a special case of the rule for
compositions.

Basically when taking a limit as $x$ goes to $0$ we can multiply $x$ by any constant and figure out the limit for that. (It is as though we "go to" $0$ faster or slower. but are still going to $0$. This can be generalized to any function $g(x)$ with a limit of $0$ at $0$: $\lim_{x \rightarrow 0}f(g(x)) = \lim_{x \rightarrow 0}f(x)$.)

##### Example, products

Consider this complicated limit found on this [Wikipedia](http://en.wikipedia.org/wiki/L%27H%C3%B4pital%27s_rule) page.

$$~
\lim_{x \rightarrow 1/2} \frac{\sin(\pi x)}{\pi x} \cdot \frac{\cos(\pi x)}{1 - (2x)^2}.
~$$

We know the first factor has a limit found by evaluation: $2/\pi$, so it is really just a constant. The second we can compute:

````julia

g(x) = cos(PI*x) / (1 - (2x)^2)
limit(g, 1//2)
````


````
0.25⋅π
````





Putting together, we would get $1/2$. Which we could have done directly in this case:

````julia

limit(sin(PI*x)/(PI*x) * g(x), x=>1//2)
````


````
0.500000000000000
````





##### Example, ratios

Consider again the limit of $\cos(\pi x) / (1 - (2x)^2)$ at $c=1/2$. A graph of both the top and bottom functions shows the indeterminate, $0/0$, form:

````julia

plot(cos(pi*x), 0.4, 0.6)
plot!(1 - (2x)^2)
````


````
Plot{Plots.PlotlyBackend() n=2}
````





However, following Euler's insight that $\sin(x)/x$ will have a limit
at $0$ of $1$ as $\sin(x) \approx x$, and $x/x$ has a limit of $1$ at
$c=0$, we can see that $\cos(\pi x)$ looks like $-\pi\cdot (x - 1/2)$
and $(1 - (2x)^2)$ looks like $-4(x-1/2)$ around $x=1/2$:

````julia

plot(cos(pi*x), 0.4, 0.6)
plot!(-pi*(x - 1/2))
````


````
Plot{Plots.PlotlyBackend() n=2}
````



````julia

plot(1 - (2x)^2, 0.4, 0.6)
plot!(-4(x - 1/2))
````


````
Plot{Plots.PlotlyBackend() n=2}
````





So around $c=1/2$ the ratio should look like $-\pi (x-1/2) / ( -4(x -	 1/2)) = \pi/4$, which indeed it does, as that is the limit.

This is the basis of L'Hôpital's rule, which we will return to once the derivative is discussed.



## Limits from the definition

The formal definition of a limit involves clarifying what it means for
$f(x)$ to be "close to $L$" when $x$ is "close to $c$". These are
quantified by the inequalities $0 < \lvert x-c\rvert < \delta$ and the $\lvert f(x) -
L\rvert < \epsilon$. The second does not have the restriction that it is
greater than $0$, as indeed $f(x)$ can equal $L$. The order is
important: it says for any idea of close for $f(x)$ to $L$, an idea of close must be found for $x$ to $c$.

The key is identifying a value for $\delta$  for a given value of $\epsilon$.

A simple case is the linear case. Consider the function $f(x) = 3x + 2$. Verify that the limit at $c=1$ is $5$.

We show "numerically" that $\delta = \epsilon/3$.

````julia

f(x) = 3x + 2
c, L = 1, 5
epsilon = rand()                 # some number in (0,1)
delta = epsilon / 3
xs = c .+ delta * rand(100)       # 100 numbers, c < x < c + delta
as = [abs(f(x) - L) < epsilon for x in xs]
all(as)                          # are all the as true?
````


````
true
````





These lines produce a random $\epsilon$, the resulting $\delta$, and then verify for 100 numbers
within $(c, c+\delta)$ that the inequality $\lvert f(x) - L \rvert < \epsilon$
holds for each. Running them again and again should always produce
`true` if $L$ is the limit and $\delta$ is chosen properly.

(Of course, we should also verify values to the left of $c$.)


If there is worry about the possibility that `epsilon == 0`, we could
replace its definition with `epsilon = max(eps(), rand())`.


In this case, $\delta$ is easy to guess, as the function is linear and
has slope $3$. This basically says the $y$ scale is 3 times the $x$
scale. For non-linear functions, finding $\delta$ for a given
$\epsilon$ can be a challenge. For the function $f(x) = x^3$,
illustrated below, a value of $\delta=\epsilon^{1/3}$ is used for $c=0$:

````
CalculusWithJulia.WeaveSupport.ImageFile("/var/folders/k0/94d1r7xd2xlcw_jkg
qq4h57w0000gr/T/jl_bpKlX9.gif", L"
Demonstration of $\epsilon$-$\delta$ proof of $\lim_{x \rightarrow 0}
x^3 = 0$. For any $\epsilon>0$ (the orange lines) there exists a
$\delta>0$ (the red lines of the box) for which the function $f(x)$
does not leave the top or bottom of the box (except possibly at the
edges). In this example $\delta^3=\epsilon$.

")
````






## Questions


###### Question

From the graph, find the limit:

$$~
L = \lim_{x\rightarrow 1}  \frac{x^2−3x+2}{x^2−6x+5}
~$$


````
Plot{Plots.PlotlyBackend() n=1}
````



````
CalculusWithJulia.WeaveSupport.Numericq(0.25, 0.1, "", "[0.15, 0.35]", 0.15
, 0.35, "", "")
````






###### Question

From the graph, find the limit $L$:

$$~
L = \lim_{x \rightarrow -2} \frac{x}{x+1} \frac{x^2}{x^2 + 4}
~$$

````
Plot{Plots.PlotlyBackend() n=1}
````



````
CalculusWithJulia.WeaveSupport.Numericq(1.0, 0.1, "", "[0.9, 1.1]", 0.9, 1.
1, "", "")
````







###### Question

Graphically investigate the limit

$$~
L = \lim_{x \rightarrow 0} \frac{e^x - 1}{x}.
~$$

What is the value of $L$?


````
Plot{Plots.PlotlyBackend() n=1}
````



````
CalculusWithJulia.WeaveSupport.Numericq(1, 0.1, "", "[0.9, 1.1]", 0.9, 1.1,
 "", "")
````







###### Question

Graphically investigate the limit

$$~
\lim_{x \rightarrow 0} \frac{\cos(x) - 1}{x}.
~$$

The limit exists, what is the value?

````
CalculusWithJulia.WeaveSupport.Numericq(0, 0.01, "", "[-0.01, 0.01]", -0.01
, 0.01, "", "")
````






###### Question

The following limit is commonly used:

$$~
\lim_{h \rightarrow 0} \frac{e^{x + h} - e^x}{h} = L.
~$$

Factoring out $e^x$ from the top and using rules of limits this becomes,

$$~
L = e^x \lim_{h \rightarrow 0} \frac{e^h - 1}{h}.
~$$

What is $L$?


````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$0$", L"$1
$", L"$e^x$"], 3, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"$0$", 
L"$1$", L"$e^x$"], "", false)
````









###### Question

The following limit is commonly used:

$$~
\lim_{h \rightarrow 0} \frac{\sin(x + h) - \sin(x)}{h} = L.
~$$

The answer should depend on $x$, though it is possible it is a
constant.  Using a double angle formula and the rules of limits, this
can be written as:

$$~
L = \cos(x) \lim_{h \rightarrow 0}\frac{\sin(h)}{h} + \sin(x) \lim_{h \rightarrow 0}\frac{\cos(h)-1}{h}.
~$$

Using the last result, what is the value of $L$?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString["0", "1", L"$\cos(x)$"
, L"$\sin(h)/h$", L"$\sin(x)$"], 3, "", nothing, [1, 2, 3, 4, 5], AbstractS
tring["0", "1", L"$\cos(x)$", L"$\sin(h)/h$", L"$\sin(x)$"], "", false)
````







###### Question <small>Squeeze theorem</small>

Let's look at the function $f(x) = x \sin(1/x)$. A graph around $0$
can be made with:

````julia

f(x) = x == 0 ? NaN : x * sin(1/x)
c, delta = 0, 1/4
plot([f, abs, x -> -abs(x)], c - delta, c + delta)
````


````
Plot{Plots.PlotlyBackend() n=3}
````





This graph clearly oscillates near $0$. To the graph of $f$, we added
graphs of both $g(x) = \lvert x\rvert$ and $h(x) = - \lvert x\rvert$. From this graph it is
easy to see by the "squeeze theorem" that the limit at $x=0$ is
$0$. Why?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"The functi
on $f$ has no limit - it oscillates too much near $0$", L"The functions $g$
 and $h$ both have a limit of $0$ at $x=0$ and the function $f$ is in
between both $g$ and $h$, so must to have a limit of $0$.
", L"The functions $g$ and $h$ squeeze each other as $g(x) > h(x)$"], 2, ""
, nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"The function $f$ has no li
mit - it oscillates too much near $0$", L"The functions $g$ and $h$ both ha
ve a limit of $0$ at $x=0$ and the function $f$ is in
between both $g$ and $h$, so must to have a limit of $0$.
", L"The functions $g$ and $h$ squeeze each other as $g(x) > h(x)$"], "", f
alse)
````







###### Question

Find the limit as $x$ goes to $2$ of

$$~
f(x) = \frac{3x^2 - x -10}{x^2 - 4}
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(2.75, 0.001, "", "[2.749, 2.751]", 
2.749, 2.751, "", "")
````






###### Question

Find the limit as $x$ goes to $-2$ of

$$~
f(x) = \frac{\frac{1}{x} + \frac{1}{2}}{x^3 + 8}
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(-0.020833333333333332, 0.001, "", "
[-0.02183, -0.01983]", -0.021833333333333333, -0.01983333333333333, "", "")
````






###### Question

Find the limit as $x$ goes to $27$ of

$$~
f(x) = \frac{x - 27}{x^{1/3} - 3}
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(27, 0, "", "[27.0, 27.0]", 27, 27, 
"", "")
````





###### Question

Find the limit

$$~
L = \lim_{x \rightarrow \pi/2} \frac{\tan (2x)}{x - \pi/2}
~$$


````
CalculusWithJulia.WeaveSupport.Numericq(2, 0, "", "[2.0, 2.0]", 2, 2, "", "
")
````






###### Question

The limit of $\sin(x)/x$ at $0$ has a numeric value. This depends upon
the fact that $x$ is measured in radians. Try to find this limit:
`limit(sind(x)/x, x=>0)`. What is the value?

````
CalculusWithJulia.WeaveSupport.Radioq(["`180/pi`", "`1`", "`0`", "`pi/180`"
], 4, "", nothing, [1, 2, 3, 4], ["`180/pi`", "`1`", "`0`", "`pi/180`"], ""
, false)
````






What is the limit `limit(sinpi(x)/x, x=>0)`?

````
CalculusWithJulia.WeaveSupport.Radioq(["`0`", "`pi`", "`1`", "`1/pi`"], 2, 
"", nothing, [1, 2, 3, 4], ["`0`", "`pi`", "`1`", "`1/pi`"], "", false)
````





###### Question <small>limit properties</small>

There are several properties of limits that allow one to break down
more complicated problems into smaller subproblems. For example,

$$~
\lim (f(x) + g(x)) = \lim f(x) + \lim g(x)
~$$

is notation to indicate that one can take a limit of the sum of two
function or take the limit of each first, then add and the answer will
be unchanged, provided all the limits in question exist.

Use one or the either to find the limit of $f(x) = \sin(x) + \tan(x) +
\cos(x)$ as $x$ goes to $0$.

````
CalculusWithJulia.WeaveSupport.Numericq(1.0, 1.0e-5, "", "[0.99999, 1.00001
]", 0.99999, 1.00001, "", "")
````





###### Question

Does this function have a limit as $h$ goes to $0$ from the right
(that is, assume $h>0$)?

$$~
\frac{h^h - 1}{h}
~$$


````
CalculusWithJulia.WeaveSupport.Radioq(["No, the value heads to negative inf
inity", "Yes, the value is `-9.2061`", "Yes, the value is `-11.5123`"], 1, 
"", nothing, [1, 2, 3], ["No, the value heads to negative infinity", "Yes, 
the value is `-9.2061`", "Yes, the value is `-11.5123`"], "", false)
````





###### Question

Compute the limit

$$~
\lim_{x \rightarrow 1} \frac{x}{x-1} - \frac{1}{\log(x)}.
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(0.5, 0.001, "", "[0.499, 0.501]", 0
.499, 0.501, "", "")
````





###### Question

Compute the limit

$$~
\lim_{x \rightarrow 1/2} \frac{1}{\pi} \frac{\cos(\pi x)}{1 - (2x)^2}.
~$$

````
CalculusWithJulia.WeaveSupport.Numericq(0.25, 0.001, "", "[0.249, 0.251]", 
0.249, 0.251, "", "")
````


