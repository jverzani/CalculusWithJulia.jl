# Optimization




This section discusses a basic application of calculus to answer
questions which relate to the largest or smallest a function can be given
some constraints.


For example,


> Of all rectangles with perimeter 20, which has of the largest area?


The main tool is the extreme value theorem of Bolzano and Fermat's
theorem about critical points: If the function $f(x)$ is continuous on
$[a,b]$ and differentiable on $(a,b)$, then the extrema exist and must
occur at either an end point or a critical point.


Though not all of our problems lend themselves to a description of a
continuous function on a closed interval, if they do, we have an
algorithmic prescription to find the absolute extrema of a function:

1) Find the critical points. For this we will can use a root-finding function like `find_zero`.

2) Evaluate the function values at the critical points and at the end points.

3) Identify the largest and smallest values.

With the computer we can take some shortcuts, as we will be able to
graph our function to see where the extreme values will be.

## Fixed perimeter and area

The simplest way to investigate the maximum or minimum value of a
function over a closed interval is to just graph it and look.

We begin with the question of which rectangles of perimeter 20 have
the largest area? The figure shows a few different rectangles with
this perimeter and their respective areas.

````
CalculusWithJulia.WeaveSupport.ImageFile("/var/folders/k0/94d1r7xd2xlcw_jkg
qq4h57w0000gr/T/jl_7ceBpm.gif", "\nSome possible rectangles that satisfy th
e constraint on the perimeter and their area.\n\n")
````






The basic mathematical approach is to find a function of a single
variable to maximize or minimize. In this case we have two variables
describing a rectangle: a base $b$ and height $h$. Our formulas are the area of a rectangle:

$$~
A = bh,
~$$

and the formula for the perimeter of a rectangle:

$$~
P = 2b + 2h = 20.
~$$

From this last one, we see that $b$ can be no bigger than 10 and no
smaller than 0 from the restriction put in place through the
perimeter. Solving for $h$ in terms of $b$ then yields this
restatement of the problem:

Maximize $A(b) = b \cdot (10 - b)$ over the interval $[0,10]$.

This is exactly the form needed to apply our theorem about the
existence of extrema (a continuous function on a closed
interval). Rather than solve analytically by taking a derivative, we
simply graph to find the value:

````julia

using CalculusWithJulia   #  `ForwardDiff`, `Roots`, `SymPy`
using Plots
A(b) = b * (10 - b)
plot(A, 0, 10)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





You should see the maximum occurs at $b=5$ by symmetry, so $h=5$ as
well, and the maximum area is then $25$. This gives the satisfying
answer that among all rectangles of fixed perimeter, that with the
largest area is a square. As well, this indicates a common result:
there is often some underlying symmetry in the answer.

### Exploiting polymorphism

Before moving on, let's see a slightly different way to do this
problem with `Julia`, where we trade off some algebra for a bit of
abstraction. This was discussed in the section on
[functions](../precalc/functions.html). Let's first write area as a
function of both base and height:

````julia

A(b, h) = b*h
````


````
A (generic function with 2 methods)
````





Here we write area, quite naturally, as a function of two variables.


Then from the constraint given by the perimeter being a fixed value we
can solve for `h` in terms of `b`. We write this as a function:

````julia

h(b) = (20 - 2b) / 2
````


````
h (generic function with 1 method)
````





Then to get `A(b)` we simply need to substitute `h(b)` into our
formula for the area, `A`. However, instead of doing the substitution
ourselves using algebra we let `Julia` do it through composition of
functions:

````julia

A(b) = A(b, h(b))
````


````
A (generic function with 2 methods)
````





From this we can solve graphically as before, or numerically.
We search for zeros of the derivative:

````julia

find_zeros(A', 0, 10)   # find_zeros in `Roots`,
````


````
1-element Array{Float64,1}:
 5.0
````



````
CalculusWithJulia.WeaveSupport.Alert("\nLook at the last definition of `A`.
 The function `A` appears on both sides, though on the left side with one a
rgument and on the right with two. These are two \"methods\" of a *generic*
 function, `A`. `Julia` allows multiple definitions for the same name as lo
ng as the arguments (their number and type) can disambiguate which to use. 
In this instance, when one argument is passed in then the last defintion is
 used (`A(b,h(b))`), whereas if two are passed in, then the method that mul
tiplies both arguments is used. The advantage of multiple dispatch is illus
trated: the same concept - area - has one function name, though there may b
e different ways to compute the area, so there is more than one implementat
ion.\n\n", Dict{Any,Any}())
````






### Norman Windows

Here is a similar, though more complicated, example where the analytic
approach can be a bit more tedious, but the graphical one mostly
satisfying, though we do use  a numerical algorithm to find
an exact final answer.

Let a "[Norman](https://en.wikipedia.org/wiki/Norman_architecture)"
window consist of a rectangular window of top length $x$ and side
length $y$ and a half circle on top. The goal is to maximize the area
for a fixed value of the perimeter. Again, assume this perimeter is 20
units.

This figure shows two such windows, one with base length given by
$x=4$, the other with base length given by $x=3$. The one with base
length $4$ seems to have much bigger area, what value of $x$ will lead to the largest area?

````
Plot{Plots.PlotlyBackend() n=4}
````





For this problem, we have two equations.

The area is the area of the rectangle plus the area of the half circle ($\pi r^2/2$ with $r=x/2$).

$$~
A = xy + \pi(x/2)^2/2
~$$

In `Julia` this is

````julia

A(x, y) = x*y + pi*(x/2)^2 / 2
````


````
A (generic function with 2 methods)
````






The perimeter consists of 3 sides of the rectangle and the perimeter
of half a circle ($\pi r$, with $r=x/2$):

$$~
P = 2y + x + \pi(x/2) = 20
~$$

We solve for $y$ in the first with $y = (20 - x - \pi(x/2))/2$ so that in `julia` we have:

````julia

y(x) = (20 - x - pi * x/2) / 2
````


````
y (generic function with 1 method)
````





And then we substitute in `y(x)` for `y` in the area formula through:

````julia

A(x) = A(x, y(x))
````


````
A (generic function with 2 methods)
````





Of course both $x$ and $y$ are non-negative. The latter forces $x$ to
be no more than $x=20/(1+\pi/2)$.

This leaves us the calculus problem of finding an absolute maximum of
a continuous function over the closed interval
$[0, 20/(1+\pi/2)]$. Our theorem tells us this maximum must occur, we
now proceed to find it.

We begin by simply graphing and estimating the values of the maximum and
where it occurs.

````julia

plot(A, 0, 20/(1+pi/2))
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The naked eye sees that maximum value is somewhere around $27$ and
occurs at $x\approx 5.6$. Clearly from the graph, we know the maximum
value happens at the critical point and there is only one such
critical point.

As reading the maximum from the graph is more difficult than reading a
$0$ of a function, we plot the derivative using our approximate
derivative.

````julia

plot(A', 5.5, 5.7)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





We confirm that the critical point is around $5.6$.

(As a reminder, the notation `A'` is defined in `CalculusWithJulia` through `Base.adjoint(f::Function)=x->ForwardDiff.derivative(f, float(x))`.)

#### Using `find_zero` to locate critical points.

Rather than zoom in graphically, we now use a root-finding algorithm,
to find a more precise value. We know that the maximum will occur at a
critical point, a zero of the derivative. The `find_zero`
function from the `Roots` package provides a non-linear root-finding
algorithm based on the bisection method. The only thing to keep
track of is that solving $f'(x) = 0$ means we use the derivative and
not the original function.

We see from the graph that $[0, 20/(1+\pi/2)]$ will provide a bracket, as there is only one relative maximum:

````julia

x = find_zero(A', (0, 20/(1+pi/2)))
````


````
5.600991535115574
````





The value `x` is the critical point, and in this case gives
the position of the value that will maximize the function. This value is
sometimes referred to as the *argmax*, or argument which maximizes the
function. The value and maximum area is then given by:

````julia

(x, A(x))
````


````
(5.600991535115574, 28.004957675577867)
````






(Compare this answer to the previous, is the square the figure of
greatest area for a fixed perimeter, or just the figure amongst all
rectangles? See [Isoperimetric inequality](https://en.wikipedia.org/wiki/Isoperimetric_inequality) for an answer.)

#### A symbolic approach

We could also do the above problem symbolically with the aid of `SymPy`. Here are the steps:

````julia

@vars width height real=true

Area  = width * height + pi * (width/2)^2 / 2
Perim = 2*height + width + pi * width/2
h0    = solve(Perim - 20, height)[1]
Area  = Area(height=> h0)
w0    = solve(diff(Area,width), width)[1]
````


````
40 
─────
π + 4
````






We know that `w0` is the maximum in this example from our previous
work. We shall see soon, that just knowing that the second derivative
is negative at `w0` would suffice to know this. Here we check that
condition:

````julia

diff(Area, width, width)(width => 40)
````


````
⎛π    ⎞
-⎜─ + 1⎟
 ⎝4    ⎠
````





As an aside, compare the steps involved above for a symbolic solution to those of previous work for a numeric solution:

````julia

A(w, h) = w*h + pi*(w/2)^2 / 2
h(w)    = (20 - w - pi * w/2) / 2
A(w)    =  A(w, h(w))
find_zero(A', (0, 20/(1+pi/2)))  # 40 / (pi + 4)
````


````
5.600991535115574
````





They are similar, except we solved for `h0` symbolically, rather than by hand, when we solved for `h(w)`.

## Trigonometry

Many maximization and minimization problems involve triangles, which
in turn use trigonometry in their description. Here is an example, the
"ladder corner problem." (There are many other [ladder](http://www.mathematische-basteleien.de/ladder.htm) problems.)


A ladder is to be moved through a two-dimensional hallway which has a
bend and gets narrower after the bend. The hallway is 8 feet wide then
5 feet wide. What is the longest such ladder that can be navigated
around the corner?

The figure shows a ladder of length $l_1 + l_2$ that got stuck - it
was too long.


````
Plot{Plots.PlotlyBackend() n=5}
````







We approach this problem in reverse. It is easy to see when a ladder
is too long. It gets stuck at some angle $\theta$. So for each
$\theta$ we find that ladder length that is just too long. Then we
find the minimum length of all these ladders that are too long. If a
ladder is this length or more it will get stuck for some
angle. However, if it is less than this length it will not get stuck.
So to maximize a ladder length, we minimize a different
function. Neat.

Now, to find the length $l = l_1 + l_2$ as a function of $\theta$.

We need to brush off our trigonometry, in particular right triangle
trigonometry. We see from the figure that $l_1$ is the hypotenuse of a
right triangle with opposite side $8$ and $l_2$ is the hypotenuse of a
right triangle with adjacent side $5$. So, $8/l_1 = \sin\theta$ and
$5/l_2 = \cos\theta$.


That is, we have

````julia

l(l1, l2) = l1 + l2
l1(t) = 8/sin(t)
l2(t) = 5/cos(t)

l(t) = l(l1(t), l2(t))		# or simply l(t) = 8/sin(t) + 5/cos(t)
````


````
l (generic function with 2 methods)
````





Our goal is to minimize this function for all angles between $0$ and $90$ degrees, or $0$ and $\pi/2$ radians.

This is not a continuous function on a closed interval - it is
undefined at the endpoints. That being said, a quick plot will
convince us that the minimum occurs at a critical point and there is
only one critical point in $(0, \pi/2)$.

````julia

delta = 0.2
plot(l, delta, pi/2 - delta)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The minimum occurs between 0.5 and 1.0 radians, a bracket for the derivative:

````julia

x = find_zero(l', (0.5, 1.0))
````


````
0.8634136052517809
````





So the minimum of the function $l$ is

````julia

l(x)
````


````
18.219533699708656
````





That is, any ladder less than this length can get around the hallway.

## Rate times time

Ethan Hunt, a top secret spy, has a mission to chase a bad guy. Here
is what we know:

* Ethan likes to run. He can run at 10 miles per hour.
* He can drive a car - usually some concept car by BMW - at 30 miles per hour, but only on the road.

For his mission, he needs to go 10 miles west and 5 miles north. He
can do this by:

* just driving 10 miles west then 5 miles north, or
* just running the diagonal distance, or
* driving $0 < x < 10$ miles west, then running on the diagonal


A quick analysis says:

* It would take $(10+5)/30$ hours to just drive
* It would take $\sqrt{10^2 + 5^2}/10$ hours to just run

Now, if he drives $x$ miles west ($0 < x < 10$) he would run an amount
given by the hypotenuse of a triangle with lengths $5$ and $10-x$. His
time driving would be $x/30$ and his time running would be
$\sqrt{5^2+(10-x)^2}/10$ for a total of:

$$~
T(x) = x/30 + \sqrt{5^2 + (10-x)^2}/10, \quad 0 < x < 10
~$$

With the endpoints given by
$T(0) = \sqrt{10^2 + 5^2}/10$ and $T(10) = (10 + 5)/30$.


Let's plot $T(x)$ over the interval $(0,10)$ and look:

````julia

T(x) = x/30 + sqrt(5^2 + (10-x)^2)/10
````


````
T (generic function with 1 method)
````



````julia

plot(T, 0, 10)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The minimum happens way out near 8. We zoom in a bit:

````julia

plot(T, 7, 9)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





It appears to be around 8.3. We now use `find_zero` to refine our
guess at the critical point using $[7,9]$ as a bracket:

````julia

x = find_zero(T', (7, 9))
````


````
8.232233047033631
````





Okay, got it. Around 8.23. So is  our minimum time

````julia

T(x)
````


````
0.804737854124365
````





We know this is a relative minimum, but not that it is the global
minimum over the closed time interlal. For that we must also check the
endpoints:

````julia

sqrt(10^2 + 5^2)/10, T(x), (10+5)/30
````


````
(1.118033988749895, 0.804737854124365, 0.5)
````





Ahh, we see that $T(x)$ is not continuous on $[0, 10]$, as it jumps at
$x=10$ down to an even smaller amount of $1/2$.  It may not look as
impressive as a miles-long sprint, but Mr. Hunt is advised by Benji to drive
the whole way.

## Rate times time ... the origin story

````
CalculusWithJulia.WeaveSupport.ImageFile("figures/fcarc-may2016-fig43-250.g
if", L"
Image number $43$ from l'Hospital's calculus book (the first). A
traveler leaving location $C$ to go to location $F$ must cross two
regions separated by the straight line $AEB$. We suppose that in the
region on the side of $C$, he covers distance $a$ in time $c$, and
that on the other, on the side of $F$, distance $b$ in the same time
$c$. We ask through which point $E$ on the line $AEB$ he should pass,
so as to take the least possible time to get from $C$ to $F$? (From
http://www.ams.org/samplings/feature-column/fc-2016-05.)


")
````






The last example is a modern day illustration of a problem of calculus
dating back to l'Hospital. His parameterization is a bit
different. Let's change his by taking two points $(0, a)$ and
$(L,-b)$, with $a,b,L$ positive values. Above the $x$ axis travel
happens at rate $r_0$, and below, travel happens at rate $r_1$, again,
both positive. What value $x$ in $[0,L]$ will minimize the total travel time?

We approach this symbolically with `SymPy`:

````julia

@vars a b L x r0 r1 positive=true

d0 = sqrt(x^2 + a^2)
d1 = sqrt((L-x)^2 + b^2)

t = d0/r0 + d1/r1   # time = distance/rate
dt = diff(t, x)     # look for critical points
````


````
-L + x                 x       
───────────────────── + ───────────────
      _______________         _________
     ╱  2          2         ╱  2    2 
r₁⋅╲╱  b  + (L - x)     r₀⋅╲╱  a  + x
````





The answer will occur at a critical point or an endpoint, either $x=0$ or $x=L$.

The structure of `dt` is too complicated for simply calling `solve` to find the critical points. Instead we help `SymPy` out a bit. We are solving an equation of the form $a/b + c/d = 0$. These solutions will also be solutions of $(a/b)^2 - (c/d)^2=0$ or even $a^2d^2 - c^2b^2 = 0$. This follows as solutions to $u+v=0$, also solve $(u+v)\cdot(u-v)=0$, or $u^2 - v^2=0$. Setting $u=a/b$ and $v=c/d$ completes the comparison.

We can get these terms - $a$, $b$, $c$, and $d$ - as follows:

````julia

t1, t2 = SymPy.Introspection.args(dt)  # args finds arguments to the outer function (+ in this case)
````


````
(x/(r0*sqrt(a^2 + x^2)), (-L + x)/(r1*sqrt(b^2 + (L - x)^2)))
````





The equivalent of $a^2d^2 - c^2 b^2$ is found using `numer` and
`denom` to access the numerator and denominator of the fractions:

````julia

ex = numer(t1^2)*denom(t2^2) - denom(t1^2)*numer(t2^2)
````


````
2         2 ⎛ 2    2⎞     2  2 ⎛ 2          2⎞
- r₀ ⋅(-L + x) ⋅⎝a  + x ⎠ + r₁ ⋅x ⋅⎝b  + (L - x) ⎠
````





This is a polynomial in the `x` variable of degree $4$:

````julia

sympy.Poly(ex, x).coeffs() # a0 + a1⋅x + a2⋅x^2 + a3⋅x^3 + a4⋅x^4
````


````
5-element Array{Sym,1}:
                               -r0^2 + r1^2
                        2*L*r0^2 - 2*L*r1^2
 -L^2*r0^2 + L^2*r1^2 - a^2*r0^2 + b^2*r1^2
                               2*L*a^2*r0^2
                              -L^2*a^2*r0^2
````





Fourth degree polynomials can be solved. The critical points of the
original equation will be among the 4 solutions given. However, the result
is complicated.  The
[article](http://www.ams.org/samplings/feature-column/fc-2016-05) from
which the figure came states that "In today's textbooks the problem,
usually involving a river, involves walking along one bank and then
swimming across; this corresponds to setting $g=0$ in l'Hospital's
example, and leads to a quadratic equation." Let's see that case,
which we can get in our notation by taking $b=0$:

````julia

q = ex(b=>0)
factor(q)
````


````
2 ⎛ 2   2     2  2     2  2⎞
-(-L + x) ⋅⎝a ⋅r₀  + r₀ ⋅x  - r₁ ⋅x ⎠
````





We see two terms: one with $x=L$ and another quadratic. For the simple
case $r_0=r_1$, a straight line is the best solution, and this
corresponds to $L=0$, which is clear from the formula above, as we
only have one solution to the following:

````julia

solve(q(r1=>r0), x)
````


````
1-element Array{Sym,1}:
 L
````





Well, not so fast. We need to check the other endpoint, $x=0$:

````julia

ta = t(b=>0, r1=>r0)
ta(x=>0), ta(x=>L)
````


````
(L/r0 + a/r0, sqrt(L^2 + a^2)/r0)
````





The value at $x=L$ is smaller, as $L^2 + a^2 \leq (L+a)^2$.


Now, if, say, travel above the line is half as slow as travel along, then $2r_0 = r_1$, and the critical points will be:

````julia

out = solve(q(r1 => 2r0), x)
````


````
2-element Array{Sym,1}:
           L
 sqrt(3)*a/3
````





It is hard to tell which would minimize time without more work. To check a case ($a=1, L=2, r_0=1$) we might have

````julia

t(r1 =>2r0, b=>0, x=>out[1], a=>1, L=>2, r0 => 1)  # for x=L
````


````
√5
````





Compared to the smaller ($x=\sqrt{3}a/3$):

````julia

t(r1 =>2r0, b=>0, x=>out[2], a=>1, L=>2, r0 => 1)
````


````
√3    
── + 1
2
````





What about $x=0$?

````julia

t(r1 =>2r0, b=>0, x=>0, a=>1, L=>2, r0 => 1)
````


````
2
````





The value of $x=\sqrt{3}a/3$ minimizes time
The traveler in this case is advised to head to the $x$ axis at $x=\sqrt{3}a/3$  and then travel along the $x$ axis.



Will this approach always be true?  Consider different parameters, say we
switch the values of $a$ and $L$ so $a > L$:

````julia

pts = [0, out...]
vals = N.([t(r1 =>2r0, b=>0, x=>u, a=>2, L=>1, r0 => 1) for u in pts])
[pts vals]
````


````
3×2 Array{Sym,2}:
           0  …                                                            
                5/2
           L     2.23606797749978969640917366873127623544061835961152572427
0897245410520925638
 sqrt(3)*a/3     2.38675134594812882254574390250978727823800875635063438009
3011632419888361515
````





Here traveling directly to the point $(L,0)$ is fastest. Though travel
is slower, the route is more direct and there is no time saved by
taking the longer route with faster travel for part of it.




## Unbounded domains

Maximize the function $xe^{-(1/2) x^2}$ over the interval $[0, \infty)$.

Here the extreme value theorem doesn't technically apply, as we don't
have a closed interval. However, if we can eliminate the endpoints as
candidates, then we should be able to convince ourselves the maximum
must occur at a critical point of $f(x)$. (If not, then convince yourself for all sufficiently large $M$ the maximum over $[0,M]$ occurs at
a critical point, not an endpoint. Then let $M$ go to infinity.)

So to approach this problem we first graph it over a wide interval.

````julia

f(x) = x * exp(-x^2)
plot(f, 0, 100)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





Clearly the action is nearer to 1 than 100. We try graphing the
derivative near that area:

````julia

plot(f', 0, 5)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





This shows the value of interest near $0.7$. We use `find_zero` with $[0,1]$ as a bracket

````julia

x = find_zero(f', (0, 1))
````


````
0.7071067811865476
````





The maximum is then at

````julia

f(x)
````


````
0.42888194248035333
````





### Minimize the surface area of a can


For a more applied problem of this type (infinite domain), consider a
can of some soft drink that is to contain 355ml which is 355 cubic
centimeters.  We use metric units, as the relationship between volume
(cubic centimeters) and fluid amount (ml) is clear.  A can to hold
this amount is produced in the shape of cylinder with radius $r$ and
height $h$. The materials involved give the surface area, which would
be:

$$~
SA = h \cdot 2\pi r + 2 \cdot \pi r^2
~$$

The volume satisfies:

$$~
V = 355 = h \cdot \pi r^2
~$$

Find the values of $r$ and $h$ which minimize the surface area.


First the surface area in both variables is given by

````julia

SA(h, r) = h * 2pi * r + 2pi * r^2
````


````
SA (generic function with 1 method)
````





Solving from the constraint on the volume for `h` in terms of `r` yields:

````julia

h(r) = 355 / (pi * r^2)
````


````
h (generic function with 1 method)
````





Composing gives a function of `r` alone:

````julia

SA(r) = SA(h(r), r)
````


````
SA (generic function with 2 methods)
````





This is minimized subject to the constraint that $r \geq 0$. A quick
glance shows that as $r$ gets close to $0$, the can must get
infinitely tall to contain that fixed volume, and would have infinite
surface area as the $1/r^2$ in the first term implies. On the other
hand, as $r$ goes to infinity, the height must go to 0 to make a
really flat can. Again, we would have infinite surface area, as the
$r^2$ term at the end indicates. With this observation, we can rule
out the endpoints as possible minima, so any minima must occur at a
critical point.

We start by making a graph, making an educated guess that the answer
is somewhere near a real life answer, or around 3-5 cms in radius:


````julia

plot(SA, 2, 10)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The minimum looks to be around $4$cm and is clearly between $3$ and
$5$. We can use `find_zero` to zero in on the value of the critical point:

````julia

r0 = find_zero(SA', (3, 5))
````


````
3.8372152480156734
````





Okay, $3.837...$ is our computation for $r$. To get $h$, we use:

````julia

h(r0)
````


````
7.674430496031345
````







This produces a can which is about square in profile. This is not how
most cans look though. Perhaps our model is too simple, or the cans
are optimized for some other purpose than minimizing materials.



## Questions

###### Question

A geometric figure has area given in terms of two measurements by
$A=\pi a b$ and perimeter $P = \pi (a + b)$. If the perimeter is fixed
to be 20 units long, what is the maximal area the figure can be?

````
CalculusWithJulia.WeaveSupport.Numericq(31.83098861837907, 0.001, "", "[31.
82999, 31.83199]", 31.82998861837907, 31.83198861837907, "", "")
````





###### Question

A geometric figure has area given in terms of two measurements by
$A=\pi a b$ and perimeter $P=\pi \cdot \sqrt{a^2 + b^2}/2$. If the
perimeter is 20 units long, what is the maximal area?

````
CalculusWithJulia.WeaveSupport.Numericq(254.64790894703253, 0.001, "", "[25
4.64691, 254.64891]", 254.64690894703253, 254.64890894703254, "", "")
````






###### Question

A rancher with 10 meters of fence wishes to make a pen adjacent to an
existing fence. The pen will be a rectangle with one edge using the
existing fence. Say that has length $x$, then $10 = 2y + x$, with $y$
the other dimension of the pen. What is the maximum area that can be
made?

````
CalculusWithJulia.WeaveSupport.Numericq(12.5, 0.001, "", "[12.499, 12.501]"
, 12.499, 12.501, "", "")
````





Is there "symmetry" in the answer between $x$ and $y$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````





What is you were do do two pens like this back to back, then the
answer would involve a rectangle. Is there symmetry in the answer now?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````







###### Question

A rectangle of sides $w$ and $h$ has fixed area $20$. What is the *smallest* perimeter it can have?

````
CalculusWithJulia.WeaveSupport.Numericq(17.88854381999832, 0.001, "", "[17.
88754, 17.88954]", 17.887543819998317, 17.88954381999832, "", "")
````






###### Question

A rectangle of sides $w$ and $h$ has fixed area $20$. What is the *largest* perimeter it can have?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"$17.888$", "It can b
e infinite", "It is also 20"], 2, "", nothing, [1, 2, 3], AbstractString[L"
$17.888$", "It can be infinite", "It is also 20"], "", false)
````





###### Question

A rain gutter is constructed from a 30" wide sheet of tin by bending
it into thirds. If the sides are bent 90 degrees, then the
cross-sectional area would be $100 = 10^2$. This is not the largest
possible amount. For example, if the sides are bent by 45 degrees, the cross sectional area is:

````
120.71067811865474
````





Find a value in degrees that gives the maximum. (The first task is to
write the area in terms of $\theta$.


````
CalculusWithJulia.WeaveSupport.Numericq(60.00000000000001, 0.001, "", "[59.
999, 60.001]", 59.99900000000001, 60.001000000000005, "", "")
````





###### Question Non-Norman windows

Suppose our new "Norman" window has half circular tops at the top and bottom? If the perimeter is fixed at $20$ and the dimensions of the rectangle are $x$ for the width and $y$ for the height.

What is the value of $y$ that maximizes the area?

````
CalculusWithJulia.WeaveSupport.Numericq(0.0, 0.001, "", "[-0.001, 0.001]", 
-0.001, 0.001, "", "")
````






###### Question (Thanks https://www.math.ucdavis.edu/~kouba)

A movie screen projects on a wall 20 feet high beginning 10 feet above
the floor.  This figure shows $\theta$ for $x=30$:

````
Plot{Plots.PlotlyBackend() n=3}
````





What value of $x$ gives the largest angle $\theta$? (In degrees.)

````
CalculusWithJulia.WeaveSupport.Numericq(30.000000000000004, 0.1, "", "[29.9
, 30.1]", 29.900000000000002, 30.100000000000005, "", "")
````






###### Question

A maximum likelihood estimator is a value derived by maximizing a function. For example, if

````julia

Likhood(t) = t^3 * exp(-3t) * exp(-2t) * exp(-4t) ## 0 <= t <= 10
````


````
Likhood (generic function with 1 method)
````





Then `Likhood(t)` is continuous and has single peak, so the maximum occurs
at the lone critical point. It turns out that this problem is bit sensitive to an initial condition, so we bracket

````julia

x = find_zero(Likhood',  (0.1, 0.5))
````


````
0.3333333333333333
````





Now if $Likhood(t) = \exp(-3t) \cdot \exp(-2t) \cdot \exp(-4t), \quad 0 \leq t \leq 10$, by graphing, explain why the same approach won't work:

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString["It does work and the 
answer is x = 2.27...", L" $Likhood(t)$ takes its maximum at a boundary poi
nt - not a critical point", L" $Likhood(t)$ is not continuous on $0$ to $10
$"], 2, "", nothing, [1, 2, 3], AbstractString["It does work and the answer
 is x = 2.27...", L" $Likhood(t)$ takes its maximum at a boundary point - n
ot a critical point", L" $Likhood(t)$ is not continuous on $0$ to $10$"], "
", false)
````





##### Question

Let $x_1$, $x_2$, $x_n$ be a set of unspecified numbers in a data
set. Form the expression $s(x) = (x-x_1)^2 + \cdots (x-x_n)^2$. What
is the smallest this can be (in $x$)?

We approach this using `SymPy` and $n=10$

````julia

using SymPy
n = 10
@vars s
xs = [symbols("x\$i") for i in 1:n]
s(x) = sum((x-xs[i])^2 for i in 1:n)
cps = solve(diff(s(x), x), x)
````




Run the above code. Baseed on the critical points found, what do you guess will be the
minimum value in terms of the values $x_1$, $x_2, \dots$?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"The square roots of 
the values squared, $(x_1^2 + \cdots x_n^2)^2$", "The mean, or average, of 
the values", "The median, or middle number, of the values"], 2, "", nothing
, [1, 2, 3], AbstractString[L"The square roots of the values squared, $(x_1
^2 + \cdots x_n^2)^2$", "The mean, or average, of the values", "The median,
 or middle number, of the values"], "", false)
````





###### Question

Minimize the function $f(x) = 2x + 3/x$ over $(0, \infty)$.

````
CalculusWithJulia.WeaveSupport.Numericq(1.2247448713915892, 0.001, "", "[1.
22374, 1.22574]", 1.2237448713915893, 1.225744871391589, "", "")
````






###### Question

Of all rectangles of area 4, find the one with smallest perimeter. What is the perimeter?

````
CalculusWithJulia.WeaveSupport.Numericq(8.0, 0.001, "", "[7.999, 8.001]", 7
.999, 8.001, "", "")
````






###### Question

A running track is in the shape of two straight aways and two half
circles. The total distance (perimeter) is 400 meters. Suppose $w$ is
the width (twice the radius of the circles) and $h$ is the
height. What dimensions minimize the sum $w + h$?

You have $P(w, h) = 2\pi \cdot (w/2) + 2\cdot(h-w)$.


````
CalculusWithJulia.WeaveSupport.Numericq(200.0, 0.001, "", "[199.999, 200.00
1]", 199.999, 200.001, "", "")
````





###### Question

A cell phone manufacturer wishes to make a rectangular phone with
total surface area of 12,000 $mm^2$ and maximal screen area. The
screen is surrounded by bezels with sizes of 8$mm$ on the long sides
and 32$mm$ on the short sides. (So, for example, the screen width is
shorter by $2\cdot 8$ mm than the phone width.)

What are the dimensions (width and
height) that allow the maximum screen area?

The width is:

````
CalculusWithJulia.WeaveSupport.Numericq(54.772255750516614, 0.001, "", "[54
.77126, 54.77326]", 54.771255750516616, 54.77325575051661, "", "")
````





The height is?

````
CalculusWithJulia.WeaveSupport.Numericq(219.08902300206643, 0.001, "", "[21
9.08802, 219.09002]", 219.08802300206642, 219.09002300206643, "", "")
````





###### Question

Find the value $x > 0$ which minimizes the distance from the graph of
$f(x) = \log_e(x) - x$ to the origin $(0,0)$.

````
Plot{Plots.PlotlyBackend() n=5}
````



````
CalculusWithJulia.WeaveSupport.Numericq(1.2607180017701087, 0.001, "", "[1.
25972, 1.26172]", 1.2597180017701088, 1.2617180017701086, "", "")
````





###### Question

````
CalculusWithJulia.WeaveSupport.ImageFile("figures/fcarc-may2016-fig40-300.g
if", L"
Image number $40$ from l'Hospital's calculus book (the first calculus book)
. Among all the cones that can be inscribed in a sphere, determine which on
e has the largest lateral area. (From http://www.ams.org/samplings/feature-
column/fc-2016-05)

")
````





The figure above poses a problem about cones in spheres, which can be reduced to a two-dimensional problem. Take a sphere of radius $r=1$, and imagine a secant line of length$l$ connecting $(-r, 0)$ to another point $(x,y)$ with $y>0$. Rotating that line around the $x$ axis produces a cone and its lateral surface is given by $SA=\pi \cdot y \cdot l$. Write $SA$ as a function of $x$ and solve.

The largest lateral surface area is:

````
CalculusWithJulia.WeaveSupport.Numericq(4.442882938158366, 0.001, "", "[4.4
4188, 4.44388]", 4.441882938158366, 4.443882938158366, "", "")
````





The surface area of a sphere of radius $1$ is $4\pi r^2 = 4 \pi$. This is how many times greater than that of the largest cone?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString["about the same", L"ab
out $2.6$ times as big", L"exactly $\pi$ times", "exactly four times"], 4, 
"", nothing, [1, 2, 3, 4], AbstractString["about the same", L"about $2.6$ t
imes as big", L"exactly $\pi$ times", "exactly four times"], "", false)
````


