# Integration By Parts






So far we have seen that the *derivative* rules lead to *integration rules*. In particular:

* The sum rule $[au(x) + bv(x)]' = au'(x) + bv'(x)$ gives rise to an
  integration rule: $\int (au(x) + bv(x))dx = a\int u(x)dx + b\int
  v(x))dx$. (That is, the linearity of the derivative means the
  integral has linearity.)

* The chain rule $[f(g(x))]' = f'(g(x)) g'(x)$ gives $\int_a^b
  f(g(x))g'(x)dx=\int_{g(a)}^{g(b)}f(x)dx$. That is, substitution
  reverses the chain rule.

Now we turn our attention to the implications of the *product rule*: $[uv]' = u'v + uv'$. The resulting technique is called integration by parts.


The following illustrates integration by parts of the integral $(uv)'$ over
$[a,b]$ [original](http://en.wikipedia.org/wiki/Integration_by_parts#Visualization).

````
Plot{Plots.PlotlyBackend() n=4}
````





The figure is a parametric plot of $(u,v)$ with the points $(u(a),
v(a))$ and $(u(b), v(b))$ marked. The difference $u(b)v(b) - u(a)v(a)
= u(x)v(x) \big|_a^b$ is shaded.  This area breaks into two pieces,
$A$ and $B$, partitioned by the curve. If $u$ is increasing and the
curve is parameterized by $t \rightarrow u^{-1}(t)$, then
$A=\int_{u^{-1}(a)}^{u^{-1}(b)} v(u^{-1}(t))dt$. A $u$-substitution
with $t = u(x)$ changes this into the integral $\int_a^b v(x) u'(x)
dx$. Similarly, for increasing $v$, it can be seen that $B=\int_a^b
u(x) v'(x) dx$. This suggests a relationship between the integral of
$u v'$, the integral of $u' v$ and the value $u(b)v(b) - u(a)v(a)$.




In terms of formulas:

$$~
u(x)\cdot v(x)\big|_a^b = \int_a^b [u(x) v(x)]' dx = \int_a^b u'(x) \cdot v(x) dx + \int_a^b u(x) \cdot v'(x) dx.
~$$

This is re-expressed as

$$~
\int_a^b u(x) \cdot v'(x) dx = u(x) \cdot v(x)\big|_a^b -  \int_a^b v(x) \cdot u'(x) dx,
~$$

Or, more informally, as $\int udv = uv - \int v du$.



This can sometimes be confusingly written as:

$$~
\int f(x) g'(x) dx = f(x)g(x) - \int f'(x) g(x) dx.
~$$

(The confusion coming from the fact that the indefinite integrals are only defined up to a constant.)

How does this help? It allows us to differentiate parts of an integral in hopes it makes the result easier to integrate.

An illustration can clarify.

Consider the integral $\int_0^\pi x\sin(x) dx$. If we let $u=x$ and $dv=\sin(x) dx$, the $du = 1dx$ and $v=-\cos(x)$. The above then says:

$$~
\begin{align}
\int_0^\pi x\sin(x) dx &= \int_0^\pi u dv\\
&= uv\big|_0^\pi - \int_0^\pi v du\\
&= x \cdot (-\cos(x)) \big|_0^\pi - \int_0^\pi (-\cos(x)) dx\\
&= \pi (-\cos(\pi)) - 0(-\cos(0)) + \int_0^\pi \cos(x) dx\\
&= \pi + \sin(x)\big|_0^\pi\\
&= \pi.
\end{align}
~$$

The technique means one part is differentiated and one part
integrated. The art is to break the integrand up into a piece that gets
easier through differentiation and a piece that doesn't get much
harder through integration.

## Examples

Consider $\int_1^2 x \log(x) dx$. We might try differentiating the $\log(x)$ term, so we set $u=\log(x)$ and $dv=xdx$. Then we get $du = 1/x dx$ and $v = x^2/2$. Putting together gives:

$$~
\begin{align}
\int_1^2 x \log(x) dx
&= (\log(x) \cdot \frac{x^2}{2}) \big|_1^2 - \int_1^2 \frac{x^2}{2} \frac{1}{x} dx\\
&= (2\log(2) - 0) - (\frac{x^2}{4})\big|_1^2\\
&= 2\log(2) - (1 - \frac{1}{4}) \\
&= 2\log(2) - \frac{3}{4}.
\end{align}
~$$

##### Example

This related problem uses the same idea, though perhaps harder to see at first glance, as $dv=dx$ seems too trivial.

$$~
\begin{align}
\int \log(x) dx
&= \int u dv\\
&= uv - \int v du\\
&= (\log(x) \cdot x) - \int x \cdot \frac{1}{x} dx\\
&= x \log(x) - \int dx\\
&= x \log(x) - x
\end{align}
~$$

Were this a definite integral problem, we would have written:

$$~
\int_a^b \log(x) dx = (x\log(x))\big|_a^b - \int_a^b dx = (x\log(x) - x)\big|_a^b.
~$$

##### Example

Sometimes integration by parts is used two or more times. Here we let $u=x^2$ and $dv = e^x dx$:


$$~
\int_a^b x^2 e^x dx = (x^2 \cdot e^x)\big|_a^b - \int_a^b 2x e^x dx.
~$$


But we can do $\int_a^b x e^xdx$ the same way:

$$~
\int_a^b x e^x = (x\cdot e^x)\big|_a^b - \int_a^b 1 \cdot e^xdx = (xe^x - e^x)\big|_a^b.
~$$

Combining gives the answer:

$$~
\int_a^b x^2 e^x dx
= (x^2 \cdot e^x)\big|_a^b - 2( (xe^x - e^x)\big|_a^b ) =
e^x(x^2  - 2x - 1) \big|_a^b.
~$$


In fact, it isn't hard to see that an integral of $x^m e^x$, $m$ a positive integer, can be handled in this manner. For example, when $m=10$, `SymPy` gives:

````julia

using CalculusWithJulia   # loads `SymPy`
@vars x
integrate(x^10 * exp(x), x)
````


````
⎛ 10       9       8        7         6          5           4           3 
   
⎝x   - 10⋅x  + 90⋅x  - 720⋅x  + 5040⋅x  - 30240⋅x  + 151200⋅x  - 604800⋅x  
+ 1

        2                      ⎞  x
814400⋅x  - 3628800⋅x + 3628800⎠⋅ℯ
````






The general answer is $\int x^n e^xdx = p(x) e^x$, where $p(x)$ is a
polynomial of degree $n$.

##### Example

The same technique is attempted for  this integral, but ends differently. First in the following we let $u=\sin(x)$ and $dv=e^x dx$:

$$~
\int e^x \sin(x)dx = \sin(x) e^x - \int \cos(x) e^x dx.
~$$

Now we let $u = \cos(x)$ and again $dv=e^x dx$:

$$~
\int e^x \sin(x)dx = \sin(x) e^x - \int \cos(x) e^x dx = \sin(x)e^x - \cos(x)e^x - \int (-\sin(x))e^x dx.
~$$

But simplifying this gives:

$$~
\int e^x \sin(x)dx = - \int e^x \sin(x)dx +  e^x(\sin(x) - \cos(x)).
~$$

Solving for the "unknown" $\int e^x \sin(x) dx$ gives:

$$~
\int e^x \sin(x) dx = \frac{1}{2} e^x (\sin(x) - \cos(x)).
~$$

##### Example

Positive integer powers of trigonometric functions can be addressed by this technique. Consider
$\int \cos(x)^n dx$. We let $u=\cos(x)^{n-1}$ and $dv=\cos(x) dx$. Then $du = (n-1)\cos(x)^{n-2}(-\sin(x))dx$ and $v=\sin(x)$. So,

$$~
\begin{align}
\int \cos(x)^n dx &= \cos(x)^{n-1} \cdot (\sin(x)) - \int (\sin(x)) ((n-1)\sin(x) \cos(x)^{n-2}) dx \\
&= \sin(x) \cos(x)^{n-1} + (n-1)\int \sin^2(x) \cos(x)^{n-1} dx\\
&= \sin(x) \cos(x)^{n-1} + (n-1)\int (1 - \cos(x)^2) \cos(x)^{n-2} dx\\
&= \sin(x) \cos(x)^{n-1} + (n-1)\int \cos(x)^{n-2}dx - (n-1)\int \cos(x)^n dx.
\end{align}
~$$

We can then solve for the unknown ($\int \cos(x)^{n}dx$) to get this *reduction formula*:


$$~
\int \cos(x)^n dx = \frac{1}{n}\sin(x) \cos(x)^{n-1} + \frac{n-1}{n}\int \cos(x)^{n-2}dx.
~$$

This is called a reduction formula as it reduces the problem from an
integral with a power of $n$ to one with a power of $n - 2$, so could
be repeated until the remaining indefinite integral required knowing either
$\int \cos(x) dx$ (which is $-\sin(x)$) or $\int \cos(x)^2 dx$, which
by a double angle formula application, is $x/2 - \sin(2x)/4$.

`SymPy` is quite able to do this repeated bookkeeping. For example with $n=10$:

````julia

integrate(cos(x)^10, x)
````


````
9                  7                   5                  
 3 
63⋅x   sin(x)⋅cos (x)   9⋅sin(x)⋅cos (x)   21⋅sin(x)⋅cos (x)   21⋅sin(x)⋅co
s (
──── + ────────────── + ──────────────── + ───────────────── + ────────────
───
256          10                80                 160                 128  
   

                     
x)   63⋅sin(x)⋅cos(x)
── + ────────────────
           256
````





##### Example

The visual interpretation of integration by parts breaks area into two pieces, the one labeled "B" looks like it would be labeled "A" for an inverse function for $f$. Indeed, integration by parts gives a means to possibly find antiderivatives for inverse functions.

Let $uv = x f^{-1}(x)$. Then we have $[uv]' = u'v + uv' = f^{-1}(x) + x [f^{-1}(x)]'$. So,

$$~
\begin{align}
\int f^{-1}(x) dx
&= xf^{-1}(x) - \int x [f^{-1}(x)]' dx\\
&= xf^{-1}(x) - \int f(u) du.\\
\end{align}
~$$

The last line follows from the $u$-substitution $u=f^{-1}(x)$ for then $du = [f^{-1}(x)]' dx$ and $x=f(u)$.

We use this to find an antiderivative for $\sin^{-1}(x)$:

$$~
\int \sin^{-1}(x) = x \sin^{-1}(x) - \int \sin(u) du =  x \sin^{-1}(x) + \cos(u) = x \sin^{-1}(x) + \cos(\sin^{-1}(x)).
~$$

Using right triangles to simplify, the last value
$\cos(\sin^{-1}(x))$ can otherwise be written as $\sqrt{1 - x^2}$.

##### Example

The [trapezoid](http://en.wikipedia.org/wiki/Trapezoidal_rule) rule is an approximation to the definite integral like a
Riemann sum, only instead of approximating the area above
$[x_i, x_i + h]$ by a rectangle with height $f(c_i)$ (for some $c_i$),
it uses a trapezoid formed by the left and right endpoints. That is,
this area is used in the estimation: $(1/2)\cdot (f(x_i) + f(x_i+h))
\cdot h$.

Even though we suggest just using `quadgk` for numeric integration,
estimating the error in this approximation is still of some
theoretical interest. Recall, just using *either* $x_i$ or $x_{i-1}$
for $c_i$ gives an error that is "like" $1/n$, as $n$ gets large, though the exact rate depends on the function and the length of the interval.

This [proof](http://www.math.ucsd.edu/~ebender/20B/77_Trap.pdf) for the
error estimate is involved, but is reproduced here, as it nicely
integrates many of the theoretical concepts of integration discussed so far.

First, for convenience, we consider the interval $x_i$ to $x_i+h$. The
actual answer over this is just $\int_{x_i}^{x_i+h}f(x) dx$. By a
$u$-substitution with $u=x-x_i$ this becomes $\int_0^h f(t + x_i)
dt$. For analyzing this we integrate once by parts using $u=f(t+x_i)$ and
$dv=dt$. But instead of letting $v=t$, we choose to add - as is our prerogative - a constant of integration
$A$, so $v=t+A$:

$$~
\int_0^h f(t + x_i) dt = (t+A)f(t+x_i)\big|_0^h - \int_0^h (t + A) f'(t + x_i) dt.
~$$

We choose $A$ to be $-h/2$, for then the term $(t+A)f(t+x_i)\big|_0^h$
becomes $(1/2)(f(x_i+h) + f(x_i)) \cdot h$, or the trapezoid
approximation. This means, the error over this interval - actual minus estimate - satisfies:

$$~
\text{error}_i = \int_{x_i}^{x_i+h}f(x) dx - \frac{f(x_i+h) -f(x_i)}{2} \cdot h  = - \int_0^h (t + A) f'(t + x_i) dt.
~$$

For this, we *again* integrate by parts with $u=f'(t+x_i)$ and
$dv=(t+A)dt$. Again we add a constant of integration to get $v=(t+A)^2/2 + B$, and
our error becomes:

$$~
\text{error}_i = -(\frac{(t+A)^2}{2} + B)f'(t+x_i)\big|_0^h + \int_0^h (\frac{(t+A)^2}{2} + B) \cdot f''(t+x_i) dt.
~$$

With $A=-h/2$, $B$ is chosen to be $-h^2/8$ which causes the first
term to vanish and the absolute error to simplify to:

$$~
\lvert \text{error}_i  \rvert = \lvert \int_0^h \left(\frac{(t-h/2)^2}{2} - \frac{h^2}{8}\right) \cdot f''(t + x_i) dt \rvert.
~$$

Now, we assume the $\lvert f''(t)\rvert$ is bounded by $K$ for any $a \leq t \leq b$. This
will be true, for example, if the second derivative is assumed to exist and be continuous.  Using this fact about definite integrals
$\lvert \int_a^b g dx\rvert \leq \int_a^b \lvert g \rvert dx$ we have:


$$~
\lvert \text{error}_i  \rvert \leq K \int_0^h \lvert (\frac{(t-h/2)^2}{2} - \frac{h^2}{8}) \rvert dt.
~$$

But what is the function in the integrand? Clearly it is a quadratic in $t$. Expanding gives $1/2 \cdot
(t^2 - ht)$.  This is negative over $[0,h]$ (and $0$ at these
endpoints, so the integral above is just:

$$~
\frac{1}{2}\int_0^h (ht - t^2)dt = \frac{1}{2} (\frac{ht^2}{2} - \frac{t^3}{3})\big|_0^h = \frac{h^3}{12}
~$$

This gives the bound: $\vert \text{error}_i \rvert \leq K h^3/12$. The
*total* error may be less, but is not more than the value found by
adding up the error over each of the $n$ intervals. As our bound does not
depend on the $i$, we have this sum satisfies:

$$~
\lvert \text{error}\rvert \leq n \cdot \frac{Kh^3}{12} = \frac{K(b-a)^3}{12}\frac{1}{n^2}.
~$$

So the error is like $1/n^2$, in contrast to the $1/n$ error of the
Riemann sums. One way to see this, for the Riemann sum it takes twice
as many terms to half an error estimate, but for the trapezoid rule
only $\sqrt{2}$ as many, and for Simpson's rule, only $2^{1/4}$ as
many.



## Questions


###### Question

In the integral of $\int \log(x) dx$ we let $u=\log(x)$ and $dv=dx$. What are $du$ and $v$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$du=1/x dx
\quad v = x^2/2$", L"$du=1/x dx \quad v = x$", L"$du=x\log(x) dx\quad v = 1
$"], 2, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"$du=1/x dx\quad 
v = x^2/2$", L"$du=1/x dx \quad v = x$", L"$du=x\log(x) dx\quad v = 1$"], "
", false)
````





###### Question

In the integral $\int \sec(x)^3 dx$ we let $u=\sec(x)$ and $dv = \sec(x)^2 dx$. What are $du$ and $v$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$du=\csc(x
) dx \quad v=\sec(x)^3 / 3$", L"$du=\tan(x)  dx \quad v=\sec(x)\tan(x)$", L
"$du=\sec(x)\tan(x)dx \quad v=\tan(x)$"], 3, "", nothing, [1, 2, 3], LaTeXS
trings.LaTeXString[L"$du=\csc(x) dx \quad v=\sec(x)^3 / 3$", L"$du=\tan(x) 
 dx \quad v=\sec(x)\tan(x)$", L"$du=\sec(x)\tan(x)dx \quad v=\tan(x)$"], ""
, false)
````






###### Question

In the integral $\int e^{-x} \cos(x)dx$ we let $u=e^{-x}$ and $dv=\cos(x) dx$.
What are $du$ and $v$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$du=\sin(x
)dx \quad v=-e^{-x}$", L"$du=-e^{-x} dx \quad v=\sin(x)$", L"$du=-e^{-x} dx
 \quad v=-\sin(x)$"], 2, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L
"$du=\sin(x)dx \quad v=-e^{-x}$", L"$du=-e^{-x} dx \quad v=\sin(x)$", L"$du
=-e^{-x} dx \quad v=-\sin(x)$"], "", false)
````





###### Question

Find the value of $\int_1^4 x \log(x) dx$. You can integrate by parts.

````
CalculusWithJulia.WeaveSupport.Numericq(7.340354888959126, 0.001, "", "[7.3
3935, 7.34135]", 7.339354888959126, 7.341354888959127, "", "")
````





###### Question

Find the value of $\int_0^{\pi/2} x\cos(2x) dx$. You can integrate by parts.

````
CalculusWithJulia.WeaveSupport.Numericq(-0.49999999999999983, 0.001, "", "[
-0.501, -0.499]", -0.5009999999999998, -0.49899999999999983, "", "")
````






###### Question


Find the value of $\int_1^e (\log(x))^2 dx$. You can integrate by parts.

````
CalculusWithJulia.WeaveSupport.Numericq(0.7182818284590451, 0.001, "", "[0.
71728, 0.71928]", 0.7172818284590451, 0.7192818284590451, "", "")
````







###### Question

Integration by parts can be used to provide "reduction" formulas, where an antiderivative is written in terms of another antiderivative with a lower power. Which is the proper reduction formula for $\int (\log(x))^n dx$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$x(\log(x)
)^n - n \int (\log(x))^{n-1} dx$", L"$\int (\log(x))^{n+1}/(n+1) dx$", L"$x
(\log(x))^n - \int (\log(x))^{n-1} dx$"], 1, "", nothing, [1, 2, 3], LaTeXS
trings.LaTeXString[L"$x(\log(x))^n - n \int (\log(x))^{n-1} dx$", L"$\int (
\log(x))^{n+1}/(n+1) dx$", L"$x(\log(x))^n - \int (\log(x))^{n-1} dx$"], ""
, false)
````





###### Question

The [Wikipedia](http://en.wikipedia.org/wiki/Integration_by_parts)
page has a rule of thumb with an acronym LIATE to indicate what is a
good candidate to be "$u$": **L**og function, **I**nverse functions,
**A**lgebraic functions ($x^n$), **T**rigonmetric functions, and
**E**xponential functions.

Consider the integral $\int x \cos(x) dx$. Which letter should be tried first?

````
CalculusWithJulia.WeaveSupport.Radioq(["L", "I", "A", "T", "E"], 3, "", not
hing, [1, 2, 3, 4, 5], ["L", "I", "A", "T", "E"], "", false)
````





----


Consider the integral $\int x^2\log(x) dx$. Which letter should be tried first?

````
CalculusWithJulia.WeaveSupport.Radioq(["L", "I", "A", "T", "E"], 1, "", not
hing, [1, 2, 3, 4, 5], ["L", "I", "A", "T", "E"], "", false)
````





----


Consider the integral $\int x^2 \sin^{-1}(x) dx$. Which letter should be tried first?

````
CalculusWithJulia.WeaveSupport.Radioq(["L", "I", "A", "T", "E"], 2, "", not
hing, [1, 2, 3, 4, 5], ["L", "I", "A", "T", "E"], "", false)
````






----


Consider the integral $\int e^x \sin(x) dx$. Which letter should be tried first?

````
CalculusWithJulia.WeaveSupport.Radioq(["L", "I", "A", "T", "E"], 4, "", not
hing, [1, 2, 3, 4, 5], ["L", "I", "A", "T", "E"], "", false)
````





###### Question

Find an antiderivative for $\cos^{-1}(x)$ using the integration by parts formula.

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$-\sin^{-1
}(x)$", L"$x^2/2 \cos^{-1}(x) - x\sqrt{1-x^2}/4 - \cos^{-1}(x)/4$", L"$x\co
s^{-1}(x)-\sqrt{1 - x^2}$"], 3, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXS
tring[L"$-\sin^{-1}(x)$", L"$x^2/2 \cos^{-1}(x) - x\sqrt{1-x^2}/4 - \cos^{-
1}(x)/4$", L"$x\cos^{-1}(x)-\sqrt{1 - x^2}$"], "", false)
````


