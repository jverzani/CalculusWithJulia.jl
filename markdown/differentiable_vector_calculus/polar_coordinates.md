# Polar Coordinates and Curves





The description of the $x$-$y$ plane via Cartesian coordinates is not
the only possible way, though one that is most familiar. Here we discuss
a different means. Instead of talking about over and up from an
origin, we focus on a direction and a distance from the origin.

We begin by loading our package providing access to the necessary packages:



## Definition of polar coordinates

Polar coordinates parameterize the plane though an angle $\theta$ made from the positive ray of the $x$ axis and a radius $r$.

![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/polar_coordinates_2_1.png)




To recover the Cartesian coordinates from the pair $(r,\theta)$, we have these formulas from [right](http://en.wikipedia.org/wiki/Polar_coordinate_system#Converting_between_polar_and_Cartesian_coordinates) triangle geometry:

$$~
x = r \cos(\theta),~ y = r \sin(\theta).
~$$

Each point $(x,y)$ corresponds to several possible values of
$(r,\theta)$, as any integer multiple of $2\pi$ added to $\theta$ will
describe the same point. Except for the origin, there is only one pair
when we restrict to $r > 0$ and $0 \leq \theta < 2\pi$.

For values in the first and fourth quadrants (the range of
$\tan^{-1}(x)$), we have:

$$~
r = \sqrt{x^2 + y^2},~ \theta=\tan^{-1}(y/x).
~$$

For the other two quadrants, the signs of $y$ and $x$ must be
considered. This is done with the function `atan` when two arguments are used.


For example, $(-3, 4)$ would have polar coordinates:

````julia

x,y = -3, 4
rad, theta = sqrt(x^2 + y^2), atan(y, x)
````


````
(5.0, 2.214297435588181)
````





And reversing

````julia

rad*cos(theta), rad*sin(theta)
````


````
(-2.999999999999999, 4.000000000000001)
````





This figure illustrates:

![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/polar_coordinates_5_1.png)




The case where $r < 0$ is handled by going 180 degrees in the opposite direction, in other
words the point $(r, \theta)$ can be described as well by $(-r,\theta+\pi)$.

## Parameterizing curves using polar coordinates

If $r=r(\theta)$, then the parameterized curve $(r(\theta), \theta)$
is just the set of points generated as $\theta$ ranges over some set
of values. There are many examples of parameterized curves that
simplify what might be a complicated presentation in Cartesian coordinates.

For example, a circle has the form $x^2 + y^2 = R^2$. Whereas
parameterized by polar coordinates it is just $r(\theta) = R$, or a
constant function.

The circle centered at $(r_0, \gamma)$ (in polar coordinates) with
radius $R$ has a more involved description in polar coordinates:

$$~
r(\theta) = r_0 \cos(\theta - \gamma)  + \sqrt{R^2 - r_0^2\sin^2(\theta - \gamma)}.
~$$

The case where $r_0 > R$ will not be defined for all values of $\theta$, only when $|\sin(\theta-\gamma)| \leq R/r_0$.

## Examples

The `Plots.jl` package provides a means to visualize polar plots through `plot(thetas, rs, proj=:polar)`. For example, to plot a circe with $r_0=1/2$ and $\gamma=\pi/6$ we would have:

````julia

using Plots
R, r0, gamma = 1, 1/2, pi/6
r(theta) = r0 * cos(theta-gamma) + sqrt(R^2 - r0^2*sin(theta-gamma)^2)
ts = range(0, 2pi, length=100)
rs = r.(ts)
plot(ts, rs, proj=:polar, legend=false)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





To avoid having to create values for $\theta$ and values for $r$, the `CalculusWithJulia` package provides a helper function, `plot_polar`. It is essentially this:

````julia

plot_polar(r, a, b; kwargs...) = plot(t -> r(t)*cos(t), t -> r(t)*sin(t), a, b; kwargs...)
````




We will use this in the following, as the graphs are a bit more familiar and the calling pattern similar to how we have plotted functions.

As `Plots` will make a parametric plot when called as `plot(function, function, a,b)`, the above
function creates two such functions using the relationship $x=r\cos(\theta)$ and $y=r\sin(\theta)$.


Using `plot_polar`,  we can plot circles with the following. We have to be a bit careful for the general circle, as when center is farther away from the origin that the radius ($R$), then not all angles will be acceptable and there are two functions needed to describe the radius, as this comes from a quadratic equation and both the "plus" and "minus" terms are used.

````julia

R=4; r(t) = R;

function plot_general_circle!(r0, gamma, R)
    # law of cosines has if gamma=0, |theta| <= asin(R/r0)
    # R^2 = a^2 + r^2 - 2a*r*cos(theta); solve for a
    r(t) = r0 * cos(t - gamma) + sqrt(R^2 - r0^2*sin(t-gamma)^2)
    l(t) = r0 * cos(t - gamma) - sqrt(R^2 - r0^2*sin(t-gamma)^2)

    if R < r0
        theta = asin(R/r0)-1e-6                 # avoid round off issues
        plot_polar!(r, gamma-theta, gamma+theta)
        plot_polar!(l, gamma-theta, gamma+theta)
	else
		plot_polar!(r, 0, 2pi)
	end
end

plot_polar(r, 0, 2pi, aspect_ratio=:equal, legend=false)
plot_general_circle!(2, 0, 2)
plot_general_circle!(3, 0, 1)
````


````
Plot{Plots.PlotlyBackend() n=4}
````






There are many interesting examples of curves described by polar coordinates. An interesting [compilation](http://www-history.mcs.st-and.ac.uk/Curves/Curves.html) of famous curves is found at the MacTutor History of Mathematics archive, many of which have formulas in polar coordinates.

##### Example


The [rhodenea](http://www-history.mcs.st-and.ac.uk/Curves/Rhodonea.html) curve has

$$~
r(\theta) = a \sin(k\theta)
~$$

````julia

a, k = 4, 5
r(theta) = a * sin(k * theta)
plot_polar(r, 0, pi)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





This graph has radius $0$ whenever $\sin(k\theta) = 0$ or $k\theta
=n\pi$. Solving means that it is $0$ at integer multiples of
$\pi/k$. In the above, with $k=5$, there will $5$ zeroes in
$[0,\pi]$. The entire curve is traced out over this interval, the
values from $\pi$ to $2\pi$ yield negative value of $r$, so are
related to values within $0$ to $\pi$ via the relation $(r,\pi
+\theta) = (-r, \theta)$.

##### Example

The [folium](http://www-history.mcs.st-and.ac.uk/Curves/Folium.html)
is a somewhat similar looking curve, but has this description:

$$~
r(\theta) = -b \cos(\theta) + 4a \cos(\theta) \sin(2\theta)
~$$


````julia

a, b = 4, 2
r(theta) = -b * cos(theta) + 4a * cos(theta) * sin(2theta)
plot_polar(r, 0, 2pi)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The folium has radial part $0$ when $\cos(\theta) = 0$ or
$\sin(2\theta) = b/4a$. This could be used to find out what values
correspond to which loop. For our choice of $a$ and $b$ this gives $\pi/2$, $3\pi/2$ or, as
$b/4a = 1/8$, when $\sin(2\theta) = 1/8$ which happens at
$a_0=\sin^{-1}(1/8)/2=0.0626...$ and $\pi/2 - a_0$, $\pi+a_0$ and $3\pi/2 - a_0$. The first folium can be plotted with:

````julia

a0 = (1/2) * asin(1/8)
plot_polar(r, a0, pi/2 - a0)
````


````
Plot{Plots.PlotlyBackend() n=1}
````






The second - which is too small to appear in the initial plot without zooming in - with

````julia

plot_polar(r, pi/2 - a0, pi/2)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The third with

````julia

plot_polar(r, pi/2, pi + a0)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The plot repeats from there, so the initial plot could have been made over $[0, \pi + a_0]$.

##### Example

The [Limacon of Pascal](http://www-history.mcs.st-and.ac.uk/Curves/Limacon.html) has

$$~
r(\theta) = b + 2a\cos(\theta)
~$$

````julia

a,b = 4, 2
r(theta) = b + 2a*cos(theta)
plot_polar(r, 0, 2pi)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





##### Example

Some curves require a longer parameterization, such as this where we
plot over $[0, 8\pi]$ so that the cosine term can range over an entire
half period:

````julia

r(theta) = sqrt(abs(cos(theta/8)))
plot_polar(r, 0, 8pi)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





## Area of polar graphs

Consider the [cardioid](http://www-history.mcs.st-and.ac.uk/Curves/Cardioid.html) described by $r(\theta) = 2(1 + \cos(\theta))$:

````julia

r(theta) = 2(1 + cos(theta))
plot_polar(r, 0, 2pi)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





How much area is contained in the graph?

In some cases it might be possible to translate back into Cartesian
coordinates and compute from there. In practice, this is not usually the best
solution.

The area can be approximated by wedges (not rectangles). For example, here we see that the area over a given angle is well approximated by the wedge for each of the sectors:

![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/polar_coordinates_17_1.png)



As well, see this part of a
[Wikipedia](http://en.wikipedia.org/wiki/Polar_coordinate_system#Integral_calculus_.28area.29)
page for a figure.

Imagine we have $a < b$ and a partition $a=t_0 < t_1 < \cdots < t_n =
b$. Let $\phi_i = (1/2)(t_{i-1} + t_{i})$ be the midpoint.
Then the wedge of radius $r(\phi_i)$ with angle between $t_{i-1}$ and $t_i$ will have area $\pi r(\phi_i)^2 (t_i-t_{i-1}) / (2\pi) = (1/2) r(\phi_i)(t_i-t_{i-1})$, the ratio $(t_i-t_{i-1}) / (2\pi)$ being the angle to the total angle of a circle.
 Summing the area of these wedges
over the partition gives a Riemann sum approximation for the integral $(1/2)\int_a^b
r(\theta)^2 d\theta$. This limit of this sum defines the area in polar coordinates.

> Area of polar regions. Let $R$ denote the region bounded by the curve $r(\theta)$ and bounded by the rays
> $\theta=a$ and $\theta=b$ with $b-a \leq 2\pi$, then the area of $R$ is given by
> $$~A = \frac{1}{2}\int_a^b r(\theta)^2 d\theta.~$$

So the area of the cardioid, which is parameterized over $[0, 2\pi]$ is found by

````julia

using SymPy
r(theta) = 2(1 + cos(theta))
@vars theta
(1//2) * integrate(r(theta)^2, (theta, 0, 2PI))
````


````
6⋅π
````





##### Example

The folium has general formula $r(\theta) = -b \cos(\theta)
+4a\cos(\theta)\sin(\theta)^2$. When $a=1$ and $b=1$ a leaf of the
folium is traced out between $\pi/6$ and $\pi/2$. What is the area of
that leaf?


An antiderivative exists for arbitrary $a$ and $b$:

````julia

@vars a b
r(theta) = -b*cos(theta) + 4a*cos(theta)*sin(theta)^2
integrate(r(theta)^2, theta) / 2
````


````
2      6         2      4       2         2      2       4       2      6 
   
a ⋅θ⋅sin (θ)   3⋅a ⋅θ⋅sin (θ)⋅cos (θ)   3⋅a ⋅θ⋅sin (θ)⋅cos (θ)   a ⋅θ⋅cos (
θ) 
──────────── + ────────────────────── + ────────────────────── + ──────────
── 
     2                   2                        2                   2    
   

   2    5                2    3       3       2           5               4
   
  a ⋅sin (θ)⋅cos(θ)   4⋅a ⋅sin (θ)⋅cos (θ)   a ⋅sin(θ)⋅cos (θ)   a⋅b⋅θ⋅sin 
(θ)
+ ───────────────── - ──────────────────── - ───────────────── - ──────────
───
          2                    3                     2                 2   
   

                                    4             3                        
   
            2       2      a⋅b⋅θ⋅cos (θ)   a⋅b⋅sin (θ)⋅cos(θ)   a⋅b⋅sin(θ)⋅
cos
 - a⋅b⋅θ⋅sin (θ)⋅cos (θ) - ───────────── - ────────────────── + ───────────
───
                                 2                 2                    2  
   

3       2      2       2      2       2              
 (θ)   b ⋅θ⋅sin (θ)   b ⋅θ⋅cos (θ)   b ⋅sin(θ)⋅cos(θ)
──── + ──────────── + ──────────── + ────────────────
            4              4                4
````





For our specific values, the answer can be computed with:

````julia

ex = integrate(r(theta)^2, (theta, PI/6, PI/2)) / 2
ex(a => 1, b=>1)
````


````
π 
──
12
````






###### Example

Pascal's
[limacon](http://www-history.mcs.st-and.ac.uk/Curves/Limacon.html) is
like the cardioid, but contains an extra loop. When $a=1$ and $b=1$ we
have this graph.

![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/polar_coordinates_21_1.png)



What is the area contained in the outer loop, that is not in the inner loop?

To answer, we need to find out what range of values in $[0, 2\pi]$ the
inner and outer loops are traced. This will be when $r(\theta) = 0$,
which for the choice of $a$ and $b$ solves $1 + 2\cos(\theta) = 0$, or
$\cos(\theta) = -1/2$. This is $\pi/2 + \pi/6$ and $3\pi/2 -
\pi/6$. The inner loop is traversed between those values and has area:

````julia

@vars a b
r(theta) =  b + 2a*cos(theta)
ex = integrate(r(theta)^2 / 2, (theta, PI/2 + PI/6, 3PI/2 - PI/6))
inner = ex(a=>1, b=>1)
````


````
3⋅√3
π - ────
     2
````





The outer area (including the inner loop) is the integral from $0$ to $\pi/2 + \pi/6$ plus that from $3\pi/2 - \pi/6$ to $2\pi$. These areas are equal, so we double the first:

````julia

ex = 2 * integrate(r(theta)^2 / 2, (theta, 0, PI/2 + PI/6))
outer = ex(a=>1, b=>1)
````


````
3⋅√3      
──── + 2⋅π
 2
````





The answer is the difference:

````julia

outer - inner
````


````
π + 3⋅√3
````





## Arc length

The length of the arc traced by a polar graph can also be expressed
using an integral. Again, we partition the interval $[a,b]$ and
consider the wedge from $(r(t_{i-1}), t_{i-1})$ to $(r(t_i),
t_i)$. The curve this wedge approximates will have its arc length
approximated by the line segment connecting the points. Expressing the
points in Cartesian coordinates and simplifying gives the distance
squared as:

$$~
\begin{align}
d_i^2 &= (r(t_i) \cos(t_i) - r(t_{i-1})\cos(t_{i-1}))^2 + (r(t_i) \sin(t_i) - r(t_{i-1})\sin(t_{i-1}))^2\\
&= r(t_i)^2 - 2r(t_i)r(t_{i-1}) \cos(t_i - t_{i-1}) +  r(t_{i-1})^2 \\
&\approx r(t_i)^2 - 2r(t_i)r(t_{i-1}) (1 - \frac{(t_i - t_{i-1})^2}{2})+  r(t_{i-1})^2 \quad(\text{as} \cos(x) \approx 1 - x^2/2)\\
&= (r(t_i) - r(t_{i-1}))^2 + r(t_i)r(t_{i-1}) (t_i - t_{i-1})^2.
\end{align}
~$$

As was done with arc length we multiply $d_i$ by $(t_i - t_{i-1})/(t_i - t_{i-1})$
and move the bottom factor under the square root:


$$~
\begin{align}
d_i
&= d_i \frac{t_i - t_{i-1}}{t_i - t_{i-1}} \\
&\approx \sqrt{\frac{(r(t_i) - r(t_{i-1}))^2}{(t_i - t_{i-1})^2} +
\frac{r(t_i)r(t_{i-1}) (t_i - t_{i-1})^2}{(t_i - t_{i-1})^2}} \cdot (t_i - t_{i-1})\\
&= \sqrt{(r'(\xi_i))^2 + r(t_i)r(t_{i-1})} \cdot (t_i - t_{i-1}).\quad(\text{the mean value theorem})
\end{align}
~$$

Adding the approximations to the $d_i$ looks like a Riemann sum approximation to the
integral $\int_a^b \sqrt{(r'(\theta)^2) + r(\theta)^2} d\theta$ (with
the extension to the Riemann sum formula needed to derive the arc
length for a parameterized curve). That is:

> Arc length of a polar curve. The arc length of the curve described in polar coordinates by $r(\theta)$ for $a \leq \theta \leq b$ is given by
> $$~\int_a^b \sqrt{r'(\theta)^2 + r(\theta)^2} d\theta.~$$

We test this out on a circle with $r(\theta) = R$, a constant. The
integrand simplifies to just $\sqrt{R^2}$ and the integral is from $0$
to $2\pi$, so the arc length is $2\pi R$, precisely the formula for
the circumference.

##### Example

A cardioid is described by $r(\theta) = 2(1 + \cos(\theta))$. What is the arc length from $0$ to $2\pi$?

The integrand is integrable

````julia

r(theta) = 2*(1 + cos(theta))
ds = sqrt(diff(r(theta), theta)^2 + r(theta)^2) |> simplify
````


````
______________
2⋅╲╱ 2⋅cos(θ) + 2
````





with antiderivative $4\sqrt{2\cos(\theta) + 2} \cdot \tan(\theta/2)$,
but `SymPy` isn't able to find it. Instead we give a numeric answer:

````julia

quadgk(t -> sqrt(r'(t)^2 + r(t)^2), 0, 2pi)[1]
````


````
16.0
````





##### Example

The [equiangular](http://www-history.mcs.st-and.ac.uk/Curves/Equiangular.html) spiral has polar representation

$$~
r(\theta) = a e^{\theta \cot(b)}
~$$

With $a=1$ and $b=\pi/4$, find the arc length traced out from $\theta=0$ to $\theta=1$.

````julia

a, b= 1, PI/4
r(theta) = a * exp(theta * cot(b))
ds = sqrt(diff(r(theta), theta)^2 + r(theta)^2)
integrate(ds, (theta, 0, 1))
````


````
-√2 + √2⋅ℯ
````






##### Example

An Archimedean [spiral](http://en.wikipedia.org/wiki/Archimedean_spiral) is defined in polar form by

$$~
r(\theta) = a + b \theta
~$$

That is, the radius increases linearly. The crossings of the positive $x$ axis occur at $a + b n 2\pi$, so are evenly spaced out by $2\pi b$. These could be a model for such things as coils of materials of uniform thickness.

For example, a roll of toilet paper promises 1000 sheets with the
[smaller](http://www.phlmetropolis.com/2011/03/the-incredible-shrinking-toilet-paper.php)
$4.1 \times 3.7$ inch size. This $3700$ inch long connected sheet of
paper is wrapped around a paper tube in an Archimedean spiral with
$r(\theta) = d_{\text{inner}}/2 + b\theta$. The entire roll must fit in a standard
dimension, so the outer diameter will be $d_{\text{outer}} = 5~1/4$ inches. Can we figure out
$b$?

Let $n$ be the number of windings and assume the starting and ending point is on the positive $x$ axis,
$r(2\pi n) = d_{\text{outer}}/2 = d_{\text{inner}}/2 + b (2\pi n)$. Solving for $n$ in terms of $b$ we get:
$n = ( d_{\text{outer}} - d_{\text{inner}})/2 / (2\pi b)$. With this, the following must hold as the total arc length is $3700$ inches.


$$~
\int_0^{n\cdot 2\pi} \sqrt{r(\theta)^2 + r'(\theta)^2} d\theta = 3700
~$$

Numerically then we have:

````julia

dinner = 1 + 5/8
douter = 5 + 1/4
r(b,t) = dinner/2 + b*t
rp(b,t) = b
integrand(b,t) = sqrt((r(b,t))^2 + rp(b,t)^2)  # sqrt(r^2 + r'^2)
n(b) = (douter - dinner)/2/(2*pi*b)
b = find_zero(b -> quadgk(t->integrand(b,t), 0, n(b)*2*pi)[1] - 3700, (1/100000, 1/100))
````


````
0.0008419553488281331
````





This gives a value in inches, in millimeters this is about a $.02mm$ thickness per sheet:

````julia

b * 25.4
````


````
0.02138566586023458
````






## Questions

###### Question

Let $r=3$ and $\theta=\pi/8$. In Cartesian coordinates what is $x$?

````
CalculusWithJulia.WeaveSupport.Numericq(2.77163859753386, 0.001, "", "[2.77
064, 2.77264]", 2.77063859753386, 2.77263859753386, "", "")
````





What is $y$?

````
CalculusWithJulia.WeaveSupport.Numericq(1.1480502970952693, 0.001, "", "[1.
14705, 1.14905]", 1.1470502970952694, 1.1490502970952692, "", "")
````





###### Question

A point in Cartesian coordinates is given by $(-12, -5)$. In has a polar coordinate representation with an angle $\theta$ in $[0,2\pi]$ and $r > 0$. What is $r$?

````
CalculusWithJulia.WeaveSupport.Numericq(13.0, 0.001, "", "[12.999, 13.001]"
, 12.999, 13.001, "", "")
````





What is $\theta$?

````
CalculusWithJulia.WeaveSupport.Numericq(-2.746801533890032, 0.001, "", "[-2
.7478, -2.7458]", -2.7478015338900317, -2.745801533890032, "", "")
````





###### Question

Does $r(\theta) = a \sec(\theta - \gamma)$ describe a line for $0$ when $a=3$ and $\gamma=\pi/4$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````





If yes, what is the $y$ intercept

````
CalculusWithJulia.WeaveSupport.Numericq(Inf, 0.001, "", "[Inf, Inf]", Inf, 
Inf, "", "")
````





What is slope of the line?

````
CalculusWithJulia.WeaveSupport.Numericq(NaN, 0.001, "", "[NaN, NaN]", NaN, 
NaN, "", "")
````





Does this seem likely: the slope is $-1/\tan(\gamma)$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````





###### Question

The polar curve $r(\theta) = 2\cos(\theta)$ has tangent lines at most points. This differential representation of the chain rule

$$~
\frac{dy}{dx} = \frac{dy}{d\theta} / \frac{dx}{d\theta},
~$$

allows the slope to be computed when $y$ and $x$ are the Cartesian
form of the polar curve. For this curve, we have

$$~
\frac{dy}{d\theta} = \frac{d}{d\theta}(2\cos(\theta) \cdot \cos(\theta)),~ \text{ and }
\frac{dx}{d\theta} = \frac{d}{d\theta}(2\sin(\theta) \cdot \cos(\theta)).
~$$

Numerically, what is the slope of the tangent line when $\theta = \pi/4$?

````
CalculusWithJulia.WeaveSupport.Numericq(-4.503599627370496e15, 0.001, "", "
[-4.503599627370496e15, -4.503599627370496e15]", -4.503599627370496e15, -4.
503599627370496e15, "", "")
````





###### Question

For different values $k > 0$ and $e > 0$ the polar equation

$$~
r(\theta) = \frac{ke}{1 + e\cos(\theta)}
~$$

has a familiar form. The value of $k$ is just a scale factor, but different values of $e$ yield different shapes.

When $0 < e < 1$ what is the shape of the curve? (Answer by making a plot and guessing.)

````
CalculusWithJulia.WeaveSupport.Radioq(["an ellipse", "a parabola", "a hyper
bola", "a circle", "a line"], 1, "", nothing, [1, 2, 3, 4, 5], ["an ellipse
", "a parabola", "a hyperbola", "a circle", "a line"], "", false)
````






When $e = 1$ what is the shape of the curve?

````
CalculusWithJulia.WeaveSupport.Radioq(["an ellipse", "a parabola", "a hyper
bola", "a circle", "a line"], 2, "", nothing, [1, 2, 3, 4, 5], ["an ellipse
", "a parabola", "a hyperbola", "a circle", "a line"], "", false)
````






When $1 < e$ what is the shape of the curve?

````
CalculusWithJulia.WeaveSupport.Radioq(["an ellipse", "a parabola", "a hyper
bola", "a circle", "a line"], 3, "", nothing, [1, 2, 3, 4, 5], ["an ellipse
", "a parabola", "a hyperbola", "a circle", "a line"], "", false)
````





###### Question

Find the area of a lobe of the
[lemniscate](http://www-history.mcs.st-and.ac.uk/Curves/Lemniscate.html)
curve traced out by $r(\theta) = \sqrt{\cos(2\theta)}$ between
$-\pi/4$ and $\pi/4$. What is the answer?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\pi/2$", 
L"$1$", L"$1/2$"], 3, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"$\
pi/2$", L"$1$", L"$1/2$"], "", false)
````





###### Question

Find the area of a lobe of the [eight](http://www-history.mcs.st-and.ac.uk/Curves/Eight.html) curve traced out by $r(\theta) = \cos(2\theta)\sec(\theta)^4$ from $-\pi/4$ to $\pi/4$. Do this numerically.

````
CalculusWithJulia.WeaveSupport.Numericq(0.6666666666666666, 0.001, "", "[0.
66567, 0.66767]", 0.6656666666666666, 0.6676666666666666, "", "")
````





###### Question

Find the arc length of a lobe of the
[lemniscate](http://www-history.mcs.st-and.ac.uk/Curves/Lemniscate.html)
curve traced out by $r(\theta) = \sqrt{\cos(2\theta)}$ between
$-\pi/4$ and $\pi/4$. What is the answer (numerically)?

````
CalculusWithJulia.WeaveSupport.Numericq(2.622057529756253, 0.001, "", "[2.6
2106, 2.62306]", 2.621057529756253, 2.623057529756253, "", "")
````





###### Question


Find the arc length of a lobe of the [eight](http://www-history.mcs.st-and.ac.uk/Curves/Eight.html) curve traced out by $r(\theta) = \cos(2\theta)\sec(\theta)^4$ from $-\pi/4$ to $\pi/4$. Do this numerically.

````
CalculusWithJulia.WeaveSupport.Numericq(3.048611692422249, 0.001, "", "[3.0
4761, 3.04961]", 3.047611692422249, 3.049611692422249, "", "")
````


