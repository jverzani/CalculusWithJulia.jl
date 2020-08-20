# Arc length



````
CalculusWithJulia.WeaveSupport.ImageFile("figures/jump-rope.png", "\nA kids
' jump rope by Lifeline is comprised of little plastic segments of uniform 
length around a cord. The length of the rope can be computed by adding up t
he lengths of each segment, regardless of how the rope is arranged.\n\n")
````





The length of the jump rope in the picture can be computed by either looking at the packaging it came in, or measuring the length of each plastic segment and multiplying by the number of segments. The former is easier, the latter provides the intuition as to how we can find the length of curves in the $x-y$ plane. The idea is old, [Archimedes](http://www.maa.org/external_archive/joma/Volume7/Aktumen/Polygon.html) used fixed length segments of polygons to approximate $\pi$ using the circumference of circle producing the bounds $3~\frac{1}{7} > \pi > 3~\frac{10}{71}$.

A more modern application is the algorithm used by GPS devices to record a path taken. However, rather than record times for a fixed distance traveled, the GPS device records position ($(x,y)$ or longitude and latitude at fixed units of time - similar to how parametric functions are used. The device can then compute distance traveled and speed traveled using some familiar formulas.

## Arc length formula

Recall the distance formula gives the distance between two points: $\sqrt{(x_1 - x_0)^2 + (y_1 - y_0)^2}$.

Consider now two functions $g(t)$ and $f(t)$ and the parameterized
graph between $a$ and $b$ given by the points $(g(t), f(t))$ for $a
\leq t \leq b$. Assume that both $g$ and $f$ are differentiable on
$(a,b)$ and continuous on $[a,b]$ and furthermore that $\sqrt{f'(t) +
g'(t)}$ is Riemann integrable.


> **The arc length of a curve**. For $f$ and $g$ as described, the arc length of the parameterized curve is given by
> $$~ L = \int_a^b \sqrt{g'(t) + f'(t)} dt. ~$$ For the special case of the graph of a function $f(x)$ between $a$ and $b$ the formula becomes $L = \int_a^b \sqrt{ 1 + f'(x)} dx$ (taking $g(t) = t$).


````
CalculusWithJulia.WeaveSupport.Alert(L"
The form of the integral may seem daunting with the square root and
the derivatives. A more general writing would create a vector out of
the two functions: $\phi(t) = \langle g(t), f(t) \rangle$. It is
natural to then let $\phi'(t) = \langle g'(t), f'(t) \rangle$. With
this, the integrand is just the norm - or length - of the
derivative, or $L=\int \| \phi'(t) \| dt$. This is similar to the
distance traveled being the integral of the speed, or the absolute
value of the derivative of position.

", Dict{Any,Any}(:class => "info"))
````






To see why, any partition of the interval $[a,b]$ by $a = t_0 < t_1 < \cdots < t_n =b$ gives rise to $n+1$ points in the plane given by $(g(t_i), f(t_i))$.

````
CalculusWithJulia.WeaveSupport.ImageFile("/var/folders/k0/94d1r7xd2xlcw_jkg
qq4h57w0000gr/T/jl_jRf1WO.gif", L"
The arc length of the parametric curve can be approximated using straight l
ine segments connecting points. This gives rise to an integral expression d
efining the length in terms of the functions $f$ and $g$.

")
````








The distance between points $(g(t_i), f(t_i))$ and $(g(t_{i-1}), f(t_{i-1}))$ is just

$$~
d_i = \sqrt{(g(t_i)-g(t_{i-1}))^2 + (f(t_i)-f(t_{i-1}))^2}
~$$

The total approximate distance of the curve would be $L_n = d_1 +
d_2 + \cdots + d_n$. This is exactly how we would compute the length
of the jump rope or the distance traveled from GPS recordings.

However, differences, such as $f(t_i)-f(t_{i-1})$, are the building blocks of approximate derivatives. With an eye towards this, we multiply both top and bottom by $t_i - t_{i-1}$ to get:

$$~
L_n = d_1 \cdot \frac{t_1 - t_0}{t_1 - t_0} + d_2 \cdot \frac{t_2 - t_1}{t_2 - t_1} + \cdots + d_n \cdot \frac{t_n - t_{n-1}}{t_n - t_{n-1}}.
~$$

But looking at each term, we can push the denominator into the square root as:

$$~
\begin{align}
d_i &= d_i \cdot \frac{t_i - t_{i-1}}{t_i - t_{i-1}}
\\
&= \sqrt{ \left(\frac{g(t_i)-g(t_{i-1})}{t_i-t_{i-1}}\right)^2 +
\left(\frac{f(t_i)-f(t_{i-1})}{t_i-t_{i-1}}\right)^2} \cdot (t_i - t_{i-1}) \\
&= \sqrt{ g'(\xi_i)^2 + f'(\psi_i)^2} \cdot (t_i - t_{i-1}).
\end{align}
~$$

The values $\xi_i$ and $\psi_i$ are guaranteed by the mean value theorem and must be in $[t_{i-1}, t_i]$.

With this, if $\sqrt{f'(t) + g'(t)}$ is integrable, as assumed, then as the size of the partition goes to zero, the sum of the $d_i$, $L_n$, must converge to the integral:

$$~
L = \int_a^b \sqrt{f'(t) + g'(t)} dt.
~$$

(This needs a technical adjustment to the Riemann theorem, as we are evaluating our function at two points in the interval. A general proof is [here](https://randomproofs.files.wordpress.com/2010/11/arc_length.pdf).)


````
CalculusWithJulia.WeaveSupport.Alert(L"
[Bressoud](http://www.math.harvard.edu/~knill/teaching/math1a_2011/exhibits
/bressoud/)
notes that Gregory (1668) proved this formula for arc length of the
graph of a function by showing that the length of the curve $f(x)$ is defin
ed
by the area under $\sqrt{1 + f'(x)^2}$. (It is commented that this was
also known a bit earlier by von Heurat.) Gregory went further though,
as part of the fundamental theorem of calculus was contained in his
work.  Gregory then posed this inverse question: given a curve
$y=g(x)$ find a function $u(x)$ so that the area under $g$ is equal to
the length of the second curve. The answer given was $u(x) =
(1/c)\int_a^x \sqrt{g^2(t) - c^2}$, which if $g(t) = \sqrt{1 + f'(t)}$
and $c=1$ says $u(x) = \int_a^x f(t)dt$.

An analogy might be a sausage maker. These take a mass of ground-up sausage
 material and return a long length of sausage. The material going in would 
depend on time via an equation like $\int_0^t g(u) du$ and the length comin
g out would be a constant (accounting for the cross section) times $u(t) = 
\int_0^t \sqrt{1 + g'(s)} ds$.

", Dict{Any,Any}(:class => "info"))
````





## Examples

Let $f(x) = x^2$. The arc length of the graph of $f(x)$ over $[0,1]$ is then $L=\int_0^1 \sqrt{1 + (2x)^2} dx$. A trigonometric substitution of $2x = \sin(\theta)$ leads to the antiderivative:

````julia

using CalculusWithJulia  # loads `SymPy`, `Roots`, `QuadGK`, `ForwardDiff`
using Plots
@vars x
F = integrate(sqrt(1 + (2x)^2), x)
````


````
__________             
    ╱    2                  
x⋅╲╱  4⋅x  + 1    asinh(2⋅x)
─────────────── + ──────────
       2              4
````



````julia

F(1) - F(0)
````


````
asinh(2)   √5
──────── + ──
   4       2
````





That number has some context, as can be seen from the graph, which gives simple lower and upper bounds of $\sqrt{1^2 + 1^2} = 1.414...$ and $1 + 1 = 2$.

````julia

f(x) = x^2
plot(f, 0, 1)
````


````
Plot{Plots.PlotlyBackend() n=1}
````



````
CalculusWithJulia.WeaveSupport.Alert(L"
The integrand $\sqrt{1 + f'(x)^2}$ may seem odd at first, but it can be int
erpreted as the length of the hypotenuse of a right triangle with \"run\" o
f $1$ and rise of $f'(x)$. This triangle is easily formed using the tangent
 line to the graph of $f(x)$. By multiplying by $dx$, the integral is \"sum
ming\" up the lengths of infinitesimal pieces of the tangent line approxima
tion.

", Dict{Any,Any}(:class => "info"))
````






##### Example

Let $f(t) = R\cos(t)$ and $g(t) = R\sin(t)$. Then the parametric curve over $[0, 2\pi]$ is a circle. As the curve does not wrap around, the arc-length of the curve is just the circumference of the circle. To see that the arc length formula gives us familiar answers, we have:

$$~
L = \int_0^{2\pi} \sqrt{(R\cos(t))^2 + (-R\sin(t))^2} dt = R\int_0^{2\pi} \sqrt{\cos(t)^2 + \sin(t)^2} dt =
R\int_0^{2\pi} dt = 2\pi R.
~$$

##### Example

Let $f(x) = \log(x)$. Find the length of the graph of $f$ over $[1/e, e]$.

The answer is

$$~
L = \int_{1/e}^e \sqrt{1 + (\frac{1}{x})^2} dx.
~$$

This has a *messy* antiderivative, so we let `SymPy` compute for us:

````julia

@vars x
ex = integrate(sqrt(1 + (1/x)^2), (x, 1/Sym(e), e))    # 1/Sym(e) keeps as symbolic value
````


````
-2                                  
       1             ℯ                                    
- ──────────── - ──────────── + asinh(ℯ) + 2.5363370869809
     _________      _________                             
    ╱  -2          ╱  -2                                  
  ╲╱  ℯ   + 1    ╲╱  ℯ   + 1
````





Which isn't so satisfying. From a quick graph, we see the answer should be no more than 4, and we see in fact it is

````julia

N(ex)
````


````
-2                                  
       1             ℯ                                    
- ──────────── - ──────────── + asinh(ℯ) + 2.5363370869809
     _________      _________                             
    ╱  -2          ╱  -2                                  
  ╲╱  ℯ   + 1    ╲╱  ℯ   + 1
````





##### Example


A [catenary shape](http://en.wikipedia.org/wiki/Catenary) is the shape a hanging chain will take as it is suspended between two posts. It appears elsewhere, for example, power wires will also have this shape as they are suspended between towers.  A formula for a catenary can be written in terms of the hyperbolic cosine, `cosh` in `julia` or exponentials.

$$~
y = a \cosh(x/a) = a \cdot \frac{e^{x/a} + e^{-x/a}}{2}.
~$$

Suppose we have the following chain hung between $x=-1$ and $x=1$ with $a = 2$:

````julia

f(x; a=2) = a * cosh(x/a)
plot(f, -1, 1)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





How long is the chain? Looking at the graph we can guess an answer is
between $2$ and $2.5$, say, but it isn't much work to get
an approximate numeric answer. Recall, the accompanying `CalculusWithJulia` package deines `f'` to find the derivative using the `ForwardDiff` package.


````julia

quadgk(x -> sqrt(1 + f'(x)^2), -1, 1)[1]
````


````
2.0843812219749895
````





We used a numeric approach, but this can be solved by hand and the answer is surprising.

##### Example

This picture of Jasper John's [Near the Lagoon](http://www.artic.edu/aic/collections/artwork/184095) was taken at The Art Institute Chicago.


````
CalculusWithJulia.WeaveSupport.ImageFile("figures/johns-catenary.jpg", "One
 of Jasper Johns' Catenary series. Art Institute of Chicago.")
````







The museum notes have

>    For his Catenary series (1997–2003), of which Near the Lagoon is
>    the largest and last work, Johns formed catenaries—a term used to
>    describe the curve assumed by a cord suspended freely from two
>    points—by tacking ordinary household string to the canvas or its
>    supports.

This particular catenary has a certain length. The basic dimensions
are 78in wide and 118in drop. We shift the basic function for catenaries to have $f(78/2) = f(-78/2) = 0$ and
$f(0) = -118$ (the top curve segment is on the $x$ axis and centered). We let our shifted function be parameterized by

$$~
f(x; a, b) = a \cosh(x/a) - b.
~$$


Evaluating at $0$ gives:

$$~
-118 = a - b \text{ or } b = a + 118.
~$$

Evaluating at $78/2$ gives: $a \cdot \cosh(78/(2a)) - (a + 118) = 0$. This can be solved numerically for a:

````julia

cat(x; a=1, b=0) = a*cosh(x/a) - b
a = find_zero(a -> cat(78/2, a=a, b=118 + a), 10)
````


````
12.994268574805425
````





Rounding, we take $a=13$. With these parameters ($a=13$, $b = 131$), we
compute the length of Johns' catenary in inches:

````julia

a = 13
b = 118 + a
f(x) = cat(x, a=13, b=118+13)
quadgk(x -> sqrt(1 + f'(x)^2), -78/2, 78/2)[1]
````


````
260.46474811265745
````





##### Example


Suspension bridges, like the Verrazano bridge, have different loading
than a cable and hence a different shape. A parabola is the shape the
cable takes under uniform loading (cf. [page 19](http://calteches.library.caltech.edu/4007/1/Calculus.pdf) for a
picture).

The Verrazano-Narrows
[bridge](http://observer.com/2012/09/staten-island/s-i-8/) has a span
of $1298$m. (Though, in the picture from the link the cable is
basically unloaded so will form a catenary.) Suppose the drop of the
main cables is $147$ meters over this span. Then the cable itself can
be modeled as a parabola with

* The $x$-intercepts $a = 1298/2$ and $-a$ and
* vertex $(0,b)$ with $b=-147$.

The parabola that fits these three points is

$$~
y = \frac{-b}{a^2}(x^2 - a^2)
~$$

Find the  length of the cable in meters.

````julia

a = 1298/2;
b = -147;
f(x) = (-b/a^2)*(x^2 - a^2);
val, _ = quadgk(x -> sqrt(1 + f'(x)^2), -a, a)
val
````


````
1341.1191077638794
````





##### Example

The
[Nephroid](http://www-history.mcs.st-and.ac.uk/Curves/Nephroid.html)
is a curve that can be described parametrically by

$$~
\begin{align}
g(t) &= a(3\cos(t) - \cos(3t)) \\
f(t) &= a(3\sin(t) - \sin(3t)).
\end{align}
~$$

Taking $a=1$ we have this graph:

````julia

a = 1
g(t) = a*(3cos(t) - cos(3t))
f(t) = a*(3sin(t) - sin(3t))
plot(g, f, 0, 2pi)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





Find the length of the perimeter of the closed figure formed by the graph.

We have $\sqrt{g'(t)^ + f'(t)^2} = \sqrt{18 - 18\cos(2t)}$.
An antiderivative isn't forthcoming through `SymPy`, so we take a numeric approach to find the length:


````julia

quadgk(t -> sqrt(g'(t)^2 + f'(t)^2), 0, 2pi)[1]
````


````
23.999999999999993
````





The answer seems like a floating point approximation of $24$, which  suggests that  this integral is tractable. Pursuing this, the integrand simplifies:

$$~
\begin{align}
\sqrt{g'(t)^2 + f'(t)^2}
&= \sqrt{(-3\sin(t) + 3\sin(3t))^2 + (3\cos(t) - 3\cos(3t))^2} \\
&= 3\sqrt{(\sin(t)^2 - 2\sin(t)\sin(3t) + \sin(3t)^2) + (\cos(t)^2 -2\cos(t)\cos(3t) + \cos(3t)^2)} \\
&= 3\sqrt{(\sin(t)^2+\cos(t)^2) + (\sin(3t)^2 + \cos(3t)^2) - 2(\sin(t)\sin(3t) + \cos(t)\cos(3t))}\\
&= 3\sqrt{2(1 - (\sin(t)\sin(3t) + \cos(t)\cos(3t)))}\\
&= 3\sqrt{2}\sqrt{1 - \cos(2t)}\\
&= 3\sqrt{2}\sqrt{2\sin(t)^2}.
\end{align}
~$$

The second to last line comes from a double angle formula expansion of $\cos(3t - t)$ and the last line from the half angle formula for $\cos$.

By graphing, we see that integrating over $[0,2\pi]$ gives twice the answer to integrating over $[0, \pi]$, which allows the simplification to:

$$~
L = \int_0^{2\pi} \sqrt{g'(t)^2 + f'(t)^2}dt = \int_0^{2\pi} 3\sqrt{2}\sqrt{2\sin(t)^2} =
3 \cdot 2 \cdot 2 \int_0^\pi \sin(t) dt = 3 \cdot 2 \cdot 2 \cdot 2 = 24.
~$$

##### Example

A teacher of small children assigns his students the task of computing the length of a jump rope by counting the number of $1$-inch segments it is made of. He knows that if a student is accurate, no matter how fast or slow they count the answer will be the same. (That is, unless the student starts counting in the wrong direction by mistake). The teacher knows this, as he is certain that the length of curve is independent of its parameterization, as it is a property intrinsic to the curve.

Mathematically, suppose a curve is described parametrically by $(g(t), f(t))$ for $a \leq t \leq b$. A new parameterization is provided by $\gamma(t)$. Suppose $\gamma$ is strictly increasing, so that an inverse function exists. (This assumption is implicitly made by the teacher, as it implies the student won't start counting in the wrong direction.) Then the same curve is described by composition through $(g(\gamma(u)), f(\gamma(u)))$ $\gamma^{-1}(a) \leq u \leq \gamma^{-1}(b)$. That the arc length is the same follows from substitution:

$$~
\begin{align}
\int_{\gamma^{-1}(a)}^{\gamma^{-1}(b)} \sqrt{([g(\gamma(t))]')^2 + ([f(\gamma(t))]')^2} dt
&=\int_{\gamma^{-1}(a)}^{\gamma^{-1}(b)} \sqrt{(g'(\gamma(t) )\gamma'(t))^2 + (f'(\gamma(t) )\gamma'(t))^2 } dt \\
&=\int_{\gamma^{-1}(a)}^{\gamma^{-1}(b)} \sqrt{g'(\gamma(t))^2 + f'(\gamma(t))^2} \gamma'(t) dt\\
&=\int_a^b \sqrt{g'(u)^2 + f'(u)^2} du = L
\end{align}
~$$

(Using $u=\gamma(t)$ for the substitution.)

In traveling there are two natural parameterizations: one by time, as in "how long have we been driving?"; and the other by distance, as in "how  far have we been driving?" Parameterizing by distance, or more technically arc length has other mathematical advantages.

To parameterize by arc length, we just need to consider a special $\gamma$ defined by:

$$~
\gamma(u) = \int_0^u \sqrt{g'(t)^2 + f'(t)^2} dt.
~$$

Supposing $\sqrt{g'(t)^2 + f'(t)^2}$ is continuous and positive, This
transformation is increasing, as its derivative by the Fundamental
Theorem of Calculus is $\sqrt{g'(t)^2 + f'(t)^2}$, which by assumption
is positive. (It is certainly non-negative.) So there exists an inverse
function. That it exists is one thing, computing all of this is a
different matter, of course.

For a simple example, we have $g(t) = R\cos(t)$ and $f(t)=R\sin(t)$
parameterizing the circle of radius $R$. The arc length between $0$
and $t$ is simply $\gamma(t) = Rt$, which we can easily see from the
formula.  The inverse of this function is $\gamma^{-1}(u) = u/R$, so
we get the parameterization $(g(Rt), f(Rt))$ for $0/R \leq t \leq
2\pi/R$.

What looks at first glance to be just a slightly more complicated equation is that of an ellipse, with $g(t) = a\cos(t)$ and $f(t) = b\sin(t)$. Taking $a=1$ and $b = a + c$, for $c > 0$ we get the equation for the arc length as a function of $t$ is just

$$~
s(u) = \int_0^u \sqrt{(-\sin(t))^2 + b\cos(t)^2} dt = \int_0^u \sqrt{\sin(t))^2 + \cos(t)^2 + c\cos(t)^2} dt =
\int_0^u \sqrt{1 + c\cos(t)^2} dt.
~$$

But, despite it not being too daunting, this integral is not tractable through our techniques and has an answer involving elliptic integrals. We can work numerically though. Letting $a=1$ and $b=2$, we have the arc length is given by:

````julia

a, b= 1, 2
s(u) = quadgk(t -> sqrt(a^2 * sin(t)^2 + b^2 * cos(t)^2), 0, u)[1]
````


````
s (generic function with 1 method)
````





This  has a graph, which does not look familiar, but we can see is monotonically increasing, so will have an inverse function:

````julia

plot(s, 0, 2pi)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The range is $[0, s(2\pi)]$.

The inverse function can be found by solving, we use `find_zero` for this:

````julia

using Roots
sinv(u) = find_zero(x -> s(x) - u, (0, s(2pi)))
````


````
sinv (generic function with 1 method)
````





Here we see that the new parameterization yields the same curve:

````julia

g(t) = a*cos(t)
f(t) = b*sin(t)

plot(t->g(s(t)), t-> f(s(t)), 0, s(2*pi))
````


````
Plot{Plots.PlotlyBackend() n=1}
````






## Questions

###### Question

The length of the curve given by $f(x) = e^x$ between $0$ and $1$ is certainly longer than the length of the line connecting $(0, f(0))$ and $(1, f(1))$. What is that length?

````
CalculusWithJulia.WeaveSupport.Numericq(1.397316156785056, 0.001, "", "[1.3
9632, 1.39832]", 1.3963161567850562, 1.398316156785056, "", "")
````





The length of the curve is certainly less than the length of going from $(0,f(0))$ to $(1, f(0))$ and then up to $(1, f(1))$. What is the length of this upper bound?

````
CalculusWithJulia.WeaveSupport.Numericq(2.718281828459045, 0.001, "", "[2.7
1728, 2.71928]", 2.717281828459045, 2.719281828459045, "", "")
````





Now find the actual length of the curve numerically:

````
CalculusWithJulia.WeaveSupport.Numericq(2.0034971116273526, 0.001, "", "[2.
0025, 2.0045]", 2.0024971116273527, 2.0044971116273524, "", "")
````





###### Question

Find the length of the graph of $f(x) = x^{3/2}$ between $0$ and $4$.

````
CalculusWithJulia.WeaveSupport.Numericq(9.073415289387619, 0.001, "", "[9.0
7242, 9.07442]", 9.072415289387619, 9.074415289387618, "", "")
````






###### Question

A [pursuit](http://www-history.mcs.st-and.ac.uk/Curves/Pursuit.html) curve is a track an optimal pursuer will take when chasing prey. The function $f(x) = x^2 - \log(x)$ is an example. Find the length of the curve between $1/10$ and $2$.

````
CalculusWithJulia.WeaveSupport.Numericq(3.5719968650115566, 0.001, "", "[3.
571, 3.573]", 3.5709968650115567, 3.5729968650115564, "", "")
````







###### Question

Find the length of the graph of $f(x) = \tan(x)$ between $-\pi/4$ and $\pi/4$.

````
CalculusWithJulia.WeaveSupport.Numericq(2.5559561185558684, 0.001, "", "[2.
55496, 2.55696]", 2.5549561185558685, 2.5569561185558682, "", "")
````





Note, the straight line segment should be a close approximation and has length:

````julia

sqrt((tan(pi/4) - tan(-pi/4))^2 + (pi/4 - -pi/4)^2)
````


````
2.543108550627035
````





###### Question

Find the length of the graph of the function $g(x) =\int_0^x \tan(x)dx$ between $0$ and $\pi/4$ by hand or numerically:

````
CalculusWithJulia.WeaveSupport.Numericq(0.881373587019543, 0.001, "", "[0.8
8037, 0.88237]", 0.880373587019543, 0.882373587019543, "", "")
````






###### Question


A boat sits at the point $(a, 0)$ and a man holds a rope taut attached to the boat at the origin $(0,0)$. The man walks on the $y$ axis. The position $y$ depends then on the position $x$ of the boat, and if the rope is taut, the position satisfies:


$$~
y = a \ln\frac{a + \sqrt{a^2 - x^2}}{x} - \sqrt{a^2 - x^2}
~$$

This can be entered into `julia` as:

````julia

g(x, a) = a * log((a + sqrt(a^2 - x^2))/x) - sqrt(a^2 - x^2)
````


````
g (generic function with 2 methods)
````






Let $a=12$, $f(x) = g(x, a)$. Compute the length the bow of the
boat has traveled between $x=1$ and $x=a$ using `quadgk`.

````
CalculusWithJulia.WeaveSupport.Numericq(29.818879797456006, 0.001, "", "[29
.81788, 29.81988]", 29.817879797456005, 29.819879797456007, "", "")
````





(The most elementary description of this curve is in terms
of the relationship $dy/dx = -\sqrt{a^2-x^2}/x$ which could be used in place of `D(f)` in your work.)

````
CalculusWithJulia.WeaveSupport.Alert("\nTo see an example of how the tractr
ix can be found in an everyday observation, follow this link on a descripti
on of [bicycle](https://simonsfoundation.org/multimedia/mathematical-impres
sions-bicycle-tracks) tracks.\n\n", Dict{Any,Any}(:class => "info"))
````





###### Question

A curve is parameterized by $g(t) = t + \sin(t)$ and $f(t) = \cos(t)$. Find the arc length of the curve between $t=0$ and $\pi$.

````
CalculusWithJulia.WeaveSupport.Numericq(4.0, 0.001, "", "[3.999, 4.001]", 3
.999, 4.001, "", "")
````





###### Question

The [astroid](http://www-history.mcs.st-and.ac.uk/Curves/Astroid.html) is
a curve  parameterized by $g(t) = \cos(t)^3$ and $f(t) = \sin(t)^3$. Find the arc length of the curve between $t=0$ and $2\pi$. (This can be computed by hand or numerically.)

````
CalculusWithJulia.WeaveSupport.Numericq(6.0, 0.001, "", "[5.999, 6.001]", 5
.999, 6.001, "", "")
````





###### Question

A curve is parameterized by $g(t) = (2t + 3)^{2/3}/3$ and $f(t) = t + t^2/2$, for $0\leq t \leq 3$. Compute the arc-length numerically or by hand:

````
CalculusWithJulia.WeaveSupport.Numericq(7.547109045293191, 0.001, "", "[7.5
4611, 7.54811]", 7.546109045293191, 7.548109045293192, "", "")
````






###### Question

The cycloid is parameterized by $g(t) = a(t - \sin(t))$ and $f(t) = a(1 - \cos(t))$ for $a > 0$. Taking $a=1$, and $t$ in $[0, 2\pi]$, find the length of the curve traced out.

````
CalculusWithJulia.WeaveSupport.Numericq(8.0, 0.001, "", "[7.999, 8.001]", 7
.999, 8.001, "", "")
````


