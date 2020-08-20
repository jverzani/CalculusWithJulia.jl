# Limits, issues, extensions of the concept





The limit of a function at $c$ need not exist for one of many
different reasons. Some of these reasons can be handled with
extensions to the concept of the limit, others are just problematic in
terms of limits. This section covers examples of each.

````julia
using CalculusWithJulia
using Plots
````






Let's begin with a function that is just problematic. Consider

$$~
f(x) = \sin(1/x)
~$$

As this is a composition of nice functions it will have a limit
everywhere except possibly when $x=0$, as then $1/x$ may not have a
limit. So rather than talk about where it is nice, let's consider the
question of whether a limit exists at $c=0$.


A graph shows the issue:

````
Plot{Plots.PlotlyBackend() n=1}
````





The graph oscillates between $-1$ and $1$ infinitely many times on
this interval - so many times, that no matter how close one zooms in,
the graph on the screen will fail to capture them all. Graphically,
there is no single value of $L$ that the function gets close to, as it
varies between all the values in $[-1,1]$ as $x$ gets close to $0$. A
simple proof that there is no limit, is to take any $\epsilon$ less
than $1$, then with any $\delta > 0$, there are infinitely many $x$
values where $f(x)=1$ and infinitely many where $f(x) = -1$. That is,
there is no $L$ with $|f(x) - L| < \epsilon$ when $\epsilon$ is less than $1$ for all $x$ near $0$.

This function basically has too many values it gets close to. Another
favorite example of such a function is the function that is $0$ if $x$
is rational and $1$ if not. This function will have no limit anywhere,
not just at $0$, and for basically the same reason as above.


The issue isn't oscillation though. Take, for example, the function
$f(x) = x \cdot \sin(1/x)$. This function again has a limit everywhere
save possibly $0$. But in this case, there is a limit at $0$ of
$0$. This is because, the following is true:

$$~
-|x| \leq x \sin(1/x) \leq |x|.
~$$

The following figure illustrates:

````julia

f(x) = x * sin(1/x)
plot(f, -1, 1)
plot!(abs)
plot!(x -> -abs(x))
````


````
Plot{Plots.PlotlyBackend() n=3}
````






The [squeeze](http://en.wikipedia.org/wiki/Squeeze_theorem) theorem of
calculus is the formal reason $f$ has a limit at $0$, as as both the
upper function, $|x|$, and the lower function, $-|x|$, have a limit of
$0$ at $0$.

## Right and left limits

Another example where $f(x)$ has no limit is the  function $f(x) = x /|x|, x \neq 0$. This
function is $-1$ for negative $x$ and $1$ for positive $x$. Again,
this function will have a limit everywhere except possibly at $x=0$,
where division by $0$ is possible.

It's graph is

````julia

f(x) = abs(x)/x
plot(f, -2, 2)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The sharp jump at $0$ is misleading - again, the plotting algorithm
just connects the points, it doesn't handle what is a fundamental
discontinuity well - the function is not defined at $0$ and jumps
from $-1$ to $1$ there. Similarly to our example of $\sin(1/x)$, near
$0$ the function get's close to both $1$ and $-1$, so will have no
limit. (Again, just take $\epsilon$ smaller than $1$.)

But unlike the previous example, this function *would* have a limit if
the definition didn't consider values of $x$ on both sides of $c$. The
limit on the right side would be $1$, the limit on the left side would
be $-1$. This distinction is useful, so there is an extension of the idea of a
limit to *one-sided limits*.


Let's loosen up the language in the definition of a limit to read:

> The limit of $f(x)$ as $x$ approaches $c$ is $L$ if for every
>  neighborhood, $V$, of $L$ there is a neighborhood, $U$, of $c$ for
>  which $f(x)$ is in $V$ for every $x$ in $U$, except possibly $x=c$.

The $\epsilon-\delta$ definition has $V = (L-\epsilon, L + \epsilon)$
and $U=(c-\delta, c+\delta)$. This is a rewriting of $L-\epsilon <
f(x) < L + \epsilon$ as $|f(x) - L| < \epsilon$.

Now for the defintion:


> A function $f(x)$ has a limit on the right of $c$, written $\lim_{x
>  \rightarrow c+}f(x) = L$ if for every $\epsilon > 0$, there exists a
>  $\delta > 0$ such that whenever $0 < x - c < \delta$ it holds that
>  $|f(x) - L| < \epsilon$. That is, $U$ is $(c, c+\delta)$

Similarly, a limit on the left is defined where $U=(c-\delta, c)$.

The `SymPy` function `limit` has a keyword argument `dir="+"` or
`dir="-"` to request that a one-sided limit be formed.


````julia

@vars x
f(x) = abs(x)/x
limit(f(x), x=>0, dir="+"), limit(f(x), x=>0, dir="-")
````


````
(1, -1)
````



````
CalculusWithJulia.WeaveSupport.Alert("However, `SymPy` will actually *not* 
get this correct as a limit, as one can verify through `limit(f(x), x=>0)`.
 This is because `SymPy` defaults to `dir=\"+\"`. To be certain, you can ch
eck both to see they are equal.\n", Dict{Any,Any}())
````





The relation between the two concepts is that a function has a limit at $c$ if
an only if the left and right limits exist and are equal. This
function $f$ has both existing, but the two limits are not equal.


There are other such functions that jump. Another useful one is the
floor function, which just rounds down to the nearest integer. A graph shows the basic shape:

````julia

plot(floor, -5,5)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





Again, the (nearly) vertical lines are an artifact of the graphing
algorithm and not actual points that solve $y=f(x)$. The floor
function has limits except at the integers. There the left and right
limits differ.

Consider the limit at $c=0$. If $0 < x < 1/2$, say, then $f(x) = 0$ as
we round down, so the right limit will be $0$. However, if $-1/2 < x <
0$, then the $f(x) = -1$, again as we round down, so the left limit
will be $-1$. Again, with this example both the left and right limits
exists, but at the integer values they are not equal, as they differ
by 1.


Some functions only have one-sided limits as they are not defined in
an interval around $c$. There are many examples, but we will take
$f(x) = x^x$ at $x=0$. This function is not well defined for all $x <
0$, so it is typical to just take the domain to be $x > 0$. Still it
has a right limit $\lim_{x \rightarrow 0+} x^x = 1$. `SymPy` can verify:

````julia

@vars x real=true
limit(x^x, x, 0, dir="+")
````


````
1
````





This agrees with the IEEE convention of assigning `0^0` to be `1`.

However, not all such functions with indeterminate forms of $0^0$ will
have a limit of $1$.

##### Example

Consider this funny graph:

````
Plot{Plots.PlotlyBackend() n=5}
````





Describe the limits at $-1$, $0$, and $1$.

* At $-1$ we see a jump, there is no limit but instead a left limit of 1 and a right limit appearing to be $1/2$.

* At $0$ we see a limit of $1$.

* Finally, at $1$ again there is a jump, so no limit. Instead the left limit is about $-1$ and the right limit $1$.




## Limits at infinity

The loose definition of a horizontal asymptote is "a line such that
the distance between the curve and the line approaches $0$ as they
tend to infinity." This sounds like it should be defined by a
limit. The issue is, that the limit would be at $\pm\infty$ and not
some finite $c$. This means the idea of a neighborhood of $c$, $0 < |x-c| < \delta$, needs
reworking.

The basic idea for a limit at $+\infty$ is that for any $\epsilon$,
there exists an $M$ such that when $x > M$ it must be that $|f(x) - L|
< \epsilon$. For a horizontal asymptote, the line would be
$y=L$. Similarly a limit at $-\infty$ can be defined with $x < M$
being the condition.


Let's consider some cases.

The function $f(x) = \sin(x)$ will not have a limit at $+\infty$ for
exactly the same reason that $f(x) = \sin(1/x)$ does not have a limit
at $c=0$ - it just oscillates between $-1$ and $1$ so never
eventually gets close to a single value.

`SymPy` gives an odd answer here indicating the range of values:

````julia

limit(sin(x), x=>oo)
````


````
<-1, 1>
````





(We used `SymPy`'s `oo` for $\infty$ and not `Inf`.)

----


However, a damped oscillation, such as $f(x) = e^{-x} \sin(x)$ will have a limit:

````julia

@vars x real=true
limit(exp(-x)*sin(x), x=>oo)
````


````
0
````






----

We have rational functions will have the expected limit. In this
example $m = n$, so we get a horizontal asymptote that is not $y=0$:

````julia

limit((x^2 - 2x +2)/(4x^2 + 3x - 2), x=>oo)
````


````
1/4
````




----

Though rational functions can have only one (at most) horizontal asymptote, this isn't true for all functions. Consider the following $f(x) = x / \sqrt{x^2 + 4}$. It has different limits:

````julia

f(x) = x / sqrt(x^2 + 4)
limit(f(x), x=>oo), limit(f(x), x=>-oo)
````


````
(1, -1)
````





(A simpler example showing this behavior is just the function $|x|/x$ considered earlier.)

## Limits of infinity

Vertical asymptotes are nicely defined with horizontal asymptotes by
the graph getting close to some line. However, the formal definition
of a limit won't be the same. For a vertical asymptote, the value of
$f(x)$ heads towards positive or negative infinity, not some finite
$L$. As such, a neighborhood like $(L-\epsilon, L+\epsilon)$ will no
longer make sense, rather we replace it with an expression like $(M,
\infty)$ or $(-\infty, M)$. As in: the limit of $f(x)$ as $x$
approaches $c$ is *infinity* if for every $M > 0$ there exists a
$\delta>0$ such that if $0 < |x-c| < \delta$ then $f(x) > M$. Approaching $-\infty$ would conclude with $f(x) < -M$ for all $M>0$.

##### Examples

Consider the function $f(x) = 1/x^2$. This will have a limit at every
point except possibly $0$, where division by $0$ is possible. In this
case, there is a vertical asymptote. The limit at $0$ is $\infty$, in
the extended sense above. For $M>0$, we can take any $0 < \delta <
1/\sqrt{M}$. The following graph shows $M=25$ where the function
values are outside of the box, as $f(x) > M$ for those $x$ values with $0 < |x-0| < 1/\sqrt{M}$.

````
Plot{Plots.PlotlyBackend() n=4}
````





----

The function $f(x)=1/x$ requires us to talk about left and right limits of infinity, with the natural generalization. We can see that the left limit at $0$ is $-\infty$ and the right limit $\infty$:

````
Plot{Plots.PlotlyBackend() n=2}
````





`SymPy` agrees:

````julia

f(x) = 1/x
limit(f(x), x=>0, dir="-"), limit(f(x), x=>0, dir="+")
````


````
(-oo, oo)
````







----

Consider the function $f(x) = x^x(1 + \log(x)), x > 0$. Does this have a *right* limit at $0$?

A quick graph shows that a limit may be $-\infty$:

````julia

f(x) = x^x * (1 + log(x))
plot(f, 1/100, 1)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





We can check with `SymPy`:

````julia

limit(f(x), x=>0, dir="+")
````


````
-∞
````




## Limits of sequences

After all this, we still can't formalize the basic question asked in
the introduction to limits: what is the area contained in a parabola. For that
we developed a sequence of sums: $s_n = 1/2 \dot((1/4)^0 + (1/4)^1 + (1/4)^2 +
\cdots + (1/4)^n)$. This isn't a function of $x$, but rather depends
only on non-negative integer values of $n$. However, the same idea as
a limit at infinity can be used to define a limit.

> Let $a_0,a_1, a_2, \dots, a_n, \dots$ be a sequence of values indexed by $n$.
> We have $\lim_{n \rightarrow \infty} a_n = L$ if for every $\epsilon > 0$ there is an $M>0$ where if $n > M$ then $|a_n - L| < \epsilon$.


This is essentially the same as a limit *at* infinity for a function,
but in this case the function's domain is only the non-negative
integers.

`SymPy` is happy to compute limits of sequences. Defining this one involving a sum is best done with the `summation` function:

````julia

@vars i n integer=true
s(n) = 1//2 * summation((1//4)^i, (i, 0, n))    # rationals make for an exact answer
limit(s(n), n=>oo)
````


````
2/3
````





## Summary

The following table captures the various changes to the definition of
the limit to accommodate some of the possible behaviors.

````
CalculusWithJulia.WeaveSupport.Table(8×4 DataFrame. Omitted printing of 2 c
olumns
│ Row │ Type                │ Notation                                 │
│     │ AbstractString      │ LaTeXStrings.LaTeXString                 │
├─────┼─────────────────────┼──────────────────────────────────────────┤
│ 1   │ limit               │ $\\lim_{x\\rightarrow c}f(x) = L$        │
│ 2   │ right limit         │ $\\lim_{x\\rightarrow c+}f(x) = L$       │
│ 3   │ left limit          │ $\\lim_{x\\rightarrow c-}f(x) = L$       │
│ 4   │ limit at $\\infty$  │ $\\lim_{x\\rightarrow \\infty}f(x) = L$  │
│ 5   │ limit at $-\\infty$ │ $\\lim_{x\\rightarrow -\\infty}f(x) = L$ │
│ 6   │ limit of $\\infty$  │ $\\lim_{x\\rightarrow c}f(x) = \\infty$  │
│ 7   │ limit of $-\\infty$ │ $\\lim_{x\\rightarrow c}f(x) = -\\infty$ │
│ 8   │ limit of a sequence │ $\\lim_{n \\rightarrow \\infty} a_n = L$ │)
````







## Questions


###### Question

Consider the function $f(x) = \sqrt{x}$.

Does this function have a limit at every $c > 0$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", true)
````





Does this function have a limit at $c=0$?


````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", true)
````






Does this function have a right limit at $c=0$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", true)
````





Does this function have a left limit at $c=0$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", true)
````





##### Question

Find $\lim_{x \rightarrow \infty} \sin(x)/x$.

````
CalculusWithJulia.WeaveSupport.Numericq(0, 0, "", "[0.0, 0.0]", 0, 0, "", "
")
````






###### Question

Find $\lim_{x \rightarrow \infty} (1-\cos(x))/x^2$.

````
CalculusWithJulia.WeaveSupport.Numericq(0, 0, "", "[0.0, 0.0]", 0, 0, "", "
")
````






###### Question

Find $\lim_{x \rightarrow \infty} \log(x)/x$.

````
CalculusWithJulia.WeaveSupport.Numericq(0, 0, "", "[0.0, 0.0]", 0, 0, "", "
")
````









###### Question

Find $\lim_{x \rightarrow 2+} (x-3)/(x-2)$.

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$L=\infty$
", L"$L=0$", L"$L=-1$", L"$L=-\infty$"], 4, "", nothing, [1, 2, 3, 4], LaTe
XStrings.LaTeXString[L"$L=\infty$", L"$L=0$", L"$L=-1$", L"$L=-\infty$"], "
", false)
````





Find $\lim_{x \rightarrow -3-} (x-3)/(x+3)$.



````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$L=-1$", L
"$L=0$", L"$L=\infty$", L"$L=-\infty$"], 3, "", nothing, [1, 2, 3, 4], LaTe
XStrings.LaTeXString[L"$L=-1$", L"$L=0$", L"$L=\infty$", L"$L=-\infty$"], "
", false)
````





###### Question <small>No limit</small>

Some functions do not have a limit. Make a graph of $\sin(1/x)$ from $0.0001$ to $1$ and look at the output. Why does a limit not exist?

````
CalculusWithJulia.WeaveSupport.Radioq(["The limit does exist - it is any nu
mber from -1 to 1", "Err, the limit does exists and is 1", "The function os
cillates too much and its y values do not get close to any one value", "Any
 function that oscillates does not have a limit."], 3, "", nothing, [1, 2, 
3, 4], ["The limit does exist - it is any number from -1 to 1", "Err, the l
imit does exists and is 1", "The function oscillates too much and its y val
ues do not get close to any one value", "Any function that oscillates does 
not have a limit."], "", false)
````







###### Question <small>$0^0$</small>

Is the form $0^0$ really indeterminate? As mentioned `0^0` evaluates to `1`.


Consider this limit:

$$~
\lim_{x \rightarrow 0+} x^{k\cdot x} = L.
~$$

Consider different values of $k$ to see if this limit depends on $k$ or not. What is $L$?


````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"$k$", L"$\log(k)$", 
L"$1$", "The limit does not exist"], 3, "", nothing, [1, 2, 3, 4], Abstract
String[L"$k$", L"$\log(k)$", L"$1$", "The limit does not exist"], "", false
)
````






Now, consider this limit:

$$~
\lim_{x \rightarrow 0+} x^{1/\log_k(x)} = L.
~$$

In `julia`, $\log_k(x)$ is found with `log(k,x)`. The default, `log(x)` takes $k=e$ so gives the natural log. So, we would define `f`, for a given `k`, with

````
f (generic function with 1 method)
````







Consider different values of $k$ to see if the limit depends on $k$ or not. What is $L$?


````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"$1$", L"$k$", L"$\lo
g(k)$", "The limit does not exist"], 2, "", nothing, [1, 2, 3, 4], Abstract
String[L"$1$", L"$k$", L"$\log(k)$", "The limit does not exist"], "", false
)
````





###### Question

Limits *of* infinity *at* infinity. We could define this concept quite
easily mashing together the two definitions. Suppose we did. Which of
these ratios would have a limit of infinity at infinity:

$$~
x^4/x^3,\quad x^{100+1}/x^{100}, \quad x/\log(x), \quad 3^x / 2^x, \quad e^x/x^{100}
~$$

````
CalculusWithJulia.WeaveSupport.Radioq(["the first one", "the first and seco
nd ones", "the first, second and third ones", "the first, second, third, an
d fourth ones", "all of them"], 5, "", nothing, [1, 2, 3, 4, 5], ["the firs
t one", "the first and second ones", "the first, second and third ones", "t
he first, second, third, and fourth ones", "all of them"], "", false)
````






###### Question

A slant asymptote is a line $mx + b$ for which the graph of $f(x)$
gets close to as $x$ gets large. We can't express this directly as a
limit, as "$L$" is not a number. How might we?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"We can talk about th
e limit at $\infty$ of $f(x) - (mx + b)$ being $0$", L"We can talk about th
e limit at $\infty$ of $f(x) - mx$ being $b$", L"We can say $f(x) - mx$ has
 a horizontal asymptote $y=b$", L"We can say $f(x) - (mx+b)$ has a horizont
al asymptote $y=0$", "Any of the above"], 5, "", nothing, [1, 2, 3, 4, 5], 
AbstractString[L"We can talk about the limit at $\infty$ of $f(x) - (mx + b
)$ being $0$", L"We can talk about the limit at $\infty$ of $f(x) - mx$ bei
ng $b$", L"We can say $f(x) - mx$ has a horizontal asymptote $y=b$", L"We c
an say $f(x) - (mx+b)$ has a horizontal asymptote $y=0$", "Any of the above
"], "", false)
````





###### Question

Suppose a sequence of points $x_n$ converges to $a$ in the limiting sense. For a function $f(x)$, the sequence of points $f(x_n)$ may or may not converge.  One alternative definition of a [limit](https://en.wikipedia.org/wiki/Limit_of_a_function#In_terms_of_sequences) due to Heine is that $lim_{x \rightarrow a}f(x) = L$ if *and* only if **all** sequences $x_n \rightarrow a$ have $f(x_n) \rightarrow L$.

Consider the function $f(x) = \sin(1/x)$, $a=0$, and the two sequences implicitly defined by $1/x_n = \pi/2 + n \cdot (2\pi)$ and $y_n = 3\pi/2 + n \cdot(2\pi)$, $n = 0, 1, 2, \dots$.

What is $\lim_{x_n \rightarrow 0} f(x_n)$?

````
CalculusWithJulia.WeaveSupport.Numericq(1, 0, "", "[1.0, 1.0]", 1, 1, "", "
")
````





What is $\lim_{x_n \rightarrow 0} f(y_n)$?

````
CalculusWithJulia.WeaveSupport.Numericq(-1, 0, "", "[-1.0, -1.0]", -1, -1, 
"", "")
````





This shows that

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L" $f(x)$ do
es not have a limit as $x \rightarrow 0$", L" $f(x)$ has a limit of $-11$ a
s $x \rightarrow 0$", L" $f(x)$ has a limit of $1$ as $x \rightarrow 0$"], 
1, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L" $f(x)$ does not have
 a limit as $x \rightarrow 0$", L" $f(x)$ has a limit of $-11$ as $x \right
arrow 0$", L" $f(x)$ has a limit of $1$ as $x \rightarrow 0$"], "", false)
````


