# Line and Surface Integrals





This section discusses generalizations to the one- and two-dimensional definite integral. These two integrals integrate a function over a one or two dimensional region (e.g., $[a,b]$ or $[a,b]\times[c,d]$). The generalization is to change this region to a one-dimensional piece of path in $R^n$ or a two-dimensional surface in $R^3$.

To fix notation, consider $\int_a^b f(x)dx$ and $\int_a^b\int_c^d g(x,y) dy dx$. In defining both, a Riemann sum is involved, these involve a partition of $[a,b]$ or $[a,b]\times[c,d]$ and terms like $f(c_i) \Delta{x_i}$ and $g(c_i, d_j) \Delta{x_i}\Delta{y_j}$. The $\Delta$s the diameter of an intervals $I_i$ or $J_j$.  Consider now two parameterizations: $\vec{r}(t)$ for $t$ in $[a,b]$ and $\Phi(u,v)$ for $(u,v)$ in $[a,b]\times[c,d]$. One is a parameterization of a space curve, $\vec{r}:R\rightarrow R^n$; the other a parameterization of a surface, $\Phi:R^2 \rightarrow R^3$. The *image* of $I_i$ or $I_i\times{J_j}$ under $\vec{r}$ and $\Phi$, respectively, will look *almost* linear if the intervals are small enough, so, at least on the microscopic level. A Riemann term can be based around this fact, provided it is understood how much the two parameterizations change the interval $I_i$ or region $I_i\times{J_j}$.

This chapter will quantify this change, describing it in terms of associated vectors to $\vec{r}$ and $\Phi$, yielding formulas for an integral of a *scalar* function along a path or over a surface. Furthermore, these integrals will be generalized to give meaning to  physically useful interactions between the path or surface and a vector field.



Before beginning, we will use many of the packages and functions provided by `CalculusWithJulia`.

````julia
using CalculusWithJulia
using Plots
````






## Line integrals

In [arc length](../integrals/arc-length.html) a formula to give the
arc-length of the graph of a univariate function or parameterized
curve in $2$ dimensions is given in terms of an integral. The
intuitive approximation involved segments of the curve. To review, let
$\vec{r}(t)$, $a \leq t \leq b$, describe a curve, $C$, in $R^n$, $n
\geq 2$. Partition $[a,b]$ into $a=t_0 < t_1 < \cdots < t_{n-1} < t_n =
b$.

Consider the path segment  connecting $\vec{r}(t_{i-1})$ to $\vec{r}(t_i)$. If the partition of $[a,b]$ is microscopically small, this path will be *approximated* by $\vec{r}(t_i) - \vec{r}(t_{i-1})$. This difference in turn is approximately $\vec{r}'(t_i) (t_i - t_{i-1}) = \vec{r}'(t_i) \Delta{t}_i$, provided $\vec{r}$ is differentiable.


If $f:R^n \rightarrow R$ is a scalar function. Taking right-hand end points, we can consider the Riemann sum $\sum (f\circ\vec{r})(t_i) \|\vec{r}'(t_i)\| \Delta{t}_i$.  For integrable functions, this sum converges to the *line integral* defined as a one-dimensional integral for a given parameterization:

$$~
\int_a^b f(\vec{r}(t)) \| \vec{r}'(t) \| dt.
~$$

The weight $\| \vec{r}'(t) \|$ can be interpreted by how much the parameterization stretches (or contracts) an interval $[t_{i-1},t_i]$ when mapped to its corresponding path segment.

----


The curve $C$ can be parameterized many different ways by introducing a function $s(t)$ to change the time. If we use the arc-length parameterization with $\gamma(0) = a$ and $\gamma(l) = b$, where $l$ is the arc-length of $C$, then we have by change of variables $t = \gamma(s)$ that

$$~
\int_a^b f(\vec{r}(t)) \| \vec{r}'(t) \| dt =
\int_0^l (f \circ \vec{r} \circ \gamma)(s) \| \frac{d\vec{r}}{dt}\mid_{t = \gamma(s)}\| \gamma'(s) ds.
~$$

But, by the chain rule:

$$~
\frac{d(\vec{r} \circ\gamma)}{du}(s) = \frac{d\vec{r}}{dt}\mid_{t=\gamma(s)} \frac{d\gamma}{du}.
~$$

Since $\gamma$ is increasing, $\gamma' \geq 0$, so we get:

$$~
\int_a^b f(\vec{r}(t)) \| \vec{r}'(t) \| dt =
\int_0^l (f \circ \vec{r} \circ \gamma)(s) \|\frac{d(\vec{r}\circ\gamma)}{ds}\| ds =
\int_0^l (f \circ \vec{r} \circ \gamma)(s) ds.
~$$

The last line, as the derivative is the unit tangent vector, $T$, with norm $1$.

This shows that the line integral is *not* dependent on the parameterization. The notation $\int_C f ds$ is used to represent the line integral of a scalar function, the $ds$ emphasizing an implicit parameterization of $C$ by arc-length. When $C$ is a closed curve, the $\oint_C fds$ is used to indicate that.

### Example


When $f$ is identically $1$, the line integral returns the arc length. When $f$ varies, then the line integral can be interpreted a few ways. First, if $f \geq 0$ and we consider a sheet hung from the curve $f\circ \vec{r}$ and cut to just touch the ground, the line integral gives the area of this sheet, in the same way an integral gives the area under a positive curve.

If the composition $f \circ \vec{r}$ is viewed as a density of the arc (as though it were constructed out of some non-uniform material), then the line integral can be seen to return the mass of the arc.

Suppose $\rho(x,y,z) = 5 - z$ gives the density of an arc where the arc is parameterized by $\vec{r}(t) = \langle \cos(t), 0, \sin(t) \rangle$, $0 \leq t \leq \pi$. (A half-circular arc.) Find the mass of the arc.

````julia

rho(x,y,z) = 5 - z
rho(v) = rho(v...)
r(t) = [cos(t), 0, sin(t)]
@vars t
rp = diff.(r(t),t)  # r'
area = integrate((rho ∘ r)(t) * norm(rp), (t, 0, PI))
````


````
-2 + 5⋅π
````





Continuing, we could find the center of mass by integrating $\int_C z (f\circ \vec{r}) \|r'\| dt$:

````julia

Mz = integrate(r(t)[3] * (rho ∘ r)(t) * norm(rp), (t, 0, PI))
Mz
````


````
π
10 - ─
     2
````





Finally, we get the center of mass by

````julia

Mz / area
````


````
π 
 10 - ─ 
      2 
────────
-2 + 5⋅π
````





##### Example

Let $f(x,y,z) = x\sin(y)\cos(z)$ and $C$ the path described by $\vec{r}(t) = \langle t, t^2, t^3\rangle$ for $0 \leq t \leq \pi$. Find the line integral $\int_C fds$.

We find the numeric value with:

````julia

f(x,y,z) = x*sin(y)*cos(z)
f(v) = f(v...)
r(t) = [t, t^2, t^3]
integrand(t) = (f ∘ r)(t) * norm(r'(t))
quadgk(integrand, 0, pi)
````


````
(-1.2230621144956229, 1.783298175794812e-8)
````






##### Example

Imagine the $z$ axis is a wire and in the $x$-$y$ plane the unit circle is a path. If there is a magnetic field, $B$, then the field will induce a current to flow along the wire. [Ampere's]https://tinyurl.com/y4gl9pgu) circuital law states $\oint_C B\cdot\hat{T} ds = \mu_0 I$, where $\mu_0$ is a constant and $I$ the current. If the magnetic field is given by $B=(x^2+y^2)^{1/2}\langle -y,x,0\rangle$ compute $I$ in terms of $\mu_0$.

We have the path is parameterized by $\vec{r}(t) = \langle \cos(t), \sin(t), 0\rangle$, and so $\hat{T} = \langle -\sin(t), \cos(t), 0\rangle$ and the integrand, $B\cdot\hat{T}$ is

$$~
(x^2 + y^2)^{-1/2}\langle -\sin(t), \cos(t), 0\rangle\cdot
\langle -\sin(t), \cos(t), 0\rangle = (x^2 + y^2)(-1/2),
~$$

which is $1$ on the path $C$. So $\int_C B\cdot\hat{T} ds = \int_C ds = 2\pi$. So the current satisfies $2\pi = \mu_0 I$, so $I = (2\pi)/\mu_0$.

(Ampere's law is more typically used to find $B$ from an current, then $I$ from $B$, for special circumstances. The Biot-Savart does this more generally.)

### Line integrals and vector fields; work and flow

As defined above, the line integral is defined for a scalar function, but this can be generalized. If $F:R^n \rightarrow R^n$ is a vector field, then each component is a scalar function, so the integral $\int (F\circ\vec{r}) \|\vec{r}'\| dt$ can be defined component by component to yield a vector.

However, it proves more interesting to define an integral
incorporating how properties of the path interact with the vector
field. The key is $\vec{r}'(t) dt = \hat{T} \| \vec{r}'(t)\|dt$ describes both the magnitude of how the parameterization stretches an interval but also a direction the path is taking. This direction allows interaction with the vector field.

The canonical example is [work](https://en.wikipedia.org/wiki/Work_(physics)), which is a measure of a
force times a distance. For an object following a path, the work done is still a force times a distance, but only that force in the direction of the motion is considered. (The *constraint force* keeping the object on the path does no work.) Mathematically, $\hat{T}$ describes the direction of motion along a path, so the work done in moving an object over a small segment of the path is $(F\cdot\hat{T}) \Delta{s}$. Adding up incremental amounts of work leads to a Riemann sum for a line integral involving a vector field.

> The *work* done in moving an object along a path $C$ by a force field, $F$, is given by the integral
> $$~
> \int_C (F \cdot \hat{T}) ds = \int_C F\cdot d\vec{r} = \int_a^b ((F\circ\vec{r}) \cdot \frac{d\vec{r}}{dt})(t) dt.
> ~$$


----


In the $n=2$ case, there is another useful interpretation of the line integral.
In this dimension the normal vector, $\hat{N}$, is well defined in terms of the tangent vector, $\hat{T}$, through a rotation:
$\langle a,b\rangle^t = \langle b,-a\rangle^t$. (The negative, $\langle -b,a\rangle$ is also a candidate, the difference in this choice would lead to a sign difference in  in the answer.)
This allows the definition of a different line integral, called a flow integral, as detailed later:

> The *flow* across a curve $C$ is given by
> $$~
> \int_C (F\cdot\hat{N}) ds = \int_a^b (F \circ \vec{r})(t) \cdot (\vec{r}'(t))^t dt.
> ~$$


### Examples

##### Example

Let $F(x,y,z) = \langle x - y, x^2 - y^2, x^2 - z^2 \rangle$ and
$\vec{r}(t) = \langle t, t^2, t^3 \rangle$. Find the work required to move an object along the curve described by $\vec{r}$ between $0$ and $1$.

````julia

F(x,y,z) = [x-y, x^2 - y^2, x^2 - z^2]
F(v) = F(v...)
r(t) = [t, t^2, t^3]

@vars t real=true
integrate((F ∘ r)(t) ⋅ diff.(r(t), t), (t, 0, 1))
````


````
3/5
````






##### Example

Let $C$ be a closed curve. For a closed curve, the work integral is also termed the *circulation*. For the vector field $F(x,y) = \langle -y, x\rangle$ compute the circulation around the triangle with vertices $(-1,0)$, $(1,0)$, and $(0,1)$.

We have three integrals using $\vec{r}_1(t) = \langle -1+2t, 0\rangle$,
$\vec{r}_2(t) = \langle 1-t, t\rangle$ and
$\vec{r}_3(t) = \langle -t, 1-t \rangle$, all from $0$ to $1$. (Check that the parameterization is counter clockwise.)

The circulation then is:

````julia

r1(t) = [-1 + 2t, 0]
r2(t) = [1-t, t]
r3(t) = [-t, 1-t]
F(x,y) = [-y, x]
F(v) = F(v...)
integrand(r) = t -> (F ∘ r)(t) ⋅ r'(t)
C1 = quadgk(integrand(r1), 0, 1)[1]
C2 = quadgk(integrand(r2), 0, 1)[1]
C3 = quadgk(integrand(r3), 0, 1)[1]
C1 + C2 + C3
````


````
2.0
````





That this is non-zero reflects a feature of the vector field. In this case, the vector field spirals around the origin, and the circulation is non zero.

##### Example

Let $F$ be the force of gravity exerted by a mass $M$ on a mass $m$ a distance $\vec{r}$ away, that is $F(\vec{r}) = -(GMm/\|\vec{r}\|^2)\hat{r}$.

Let $\vec{r}(t) = \langle 1-t, 0, t\rangle$, $0 \leq t \leq 1$. For concreteness, we take $G M m$ to be $10$. Then the work to move the mass is given by:

````julia

using QuadGK
uvec(v) = v/norm(v) # unit vector
GMm = 10
F(r) = - GMm /norm(r)^2 * uvec(r)
r(t) = [1-t, 0, t]
quadgk(t -> (F ∘ r)(t) ⋅ r'(t), 0, 1)
````


````
(0.0, 0.0)
````





Hmm, a value of $0$. That's a bit surprising at first glance. Maybe it had something to do with the specific path chosen. To investigate, we connect the start and endpoints with a circular arc, instead of a straight line:


````julia

r(t) = [cos(t), 0, sin(t)]
quadgk(t -> (F ∘ r)(t) ⋅ r'(t), 0, 1)
````


````
(-1.2493163125924272e-17, 2.7429251495998208e-17)
````





Still $0$. We will see next that this is not surprising if something about $F$ is known.

````
CalculusWithJulia.WeaveSupport.Alert("The [Washington Post](https://www.was
hingtonpost.com/outlook/everything-you-thought-you-knew-about-gravity-is-wr
ong/2019/08/01/627f3696-a723-11e9-a3a6-ab670962db05_story.html\") had an ar
ticle by Richard Panek with the quote \"Well, yes — depending on what we me
an by 'attraction.' Two bodies of mass don’t actually exert some mysterious
 tugging on each other. Newton himself tried to avoid the word 'attraction'
 for this very reason. All (!) he was trying to do was find the math to des
cribe the motions both down here on Earth and up there among the planets (o
f which Earth, thanks to Copernicus and Kepler and Galileo, was one).\" The
 point being the formula above is a mathematical description of the force, 
but not an explanation of how the force actually is transferred.\n", Dict{A
ny,Any}(:class => "info"))
````





#### Work in a *conservative* vector field

Let $f: R^n \rightarrow R$ be a scalar function. Its gradient, $\nabla f$ is a *vector field*. For a *scalar* function, we have by the chain rule:

$$~
\frac{d(f \circ \vec{r})}{dt} = \nabla{f}(\vec{r}(t)) \cdot \frac{d\vec{r}}{dt}.
~$$

If we integrate, we see:

$$~
W = \int_a^b = \nabla{f}(\vec{r}(t)) \cdot \frac{d\vec{r}}{dt} dt =
\int_a^b \frac{d(f \circ \vec{r})}{dt} dt =
(f\circ\vec{r})\mid_{t = a}^b =
(f\circ\vec{r})(b) - (f\circ\vec{r})(a),
~$$
using the Fundamental Theorem of Calculus.

The main point above is that *if* the vector field is the gradient of a scalar field, then the work done depends *only* on the endpoints of the path and not the path itself.

> Conservative vector field
>  If $F$ is a vector field defined in an *open* region $R$; $A$ and $B$ are points in $R$ and *if* for *any* curve $C$ in $R$ connecting $A$ to $B$, the line integral of $F \cdot \vec{T}$ over $C$ depends *only* on the endpoint $A$ and $B$ and not the path, then the line integral is called *path indenpendent* and the field is called a *conservative field*.

The force of gravity is the gradient of a scalar field. As such, the two integrals above which yield $0$ could have been computed more directly. The particular scalar field is $f = -GMm/\|\vec{r}\|$, which goes by the name the gravitational *potential* function. As seen, $f$ depends only on magnitude, and as the endpoints of the path in the example have the same distance to the origin, the work integral, $(f\circ\vec{r})(b) - (f\circ\vec{r})(a)$ will be $0$.


##### Example

Coulomb's law states that the electrostatic force between two charged particles is proportional to the product of their charges and *inversely* proportional to square of the distance between the two particles. That is,

$$~
F = k\frac{ q q_0}{\|\vec{r}\|^2}\frac{\vec{r}}{\|\vec{r}\|}.
~$$

This is similar to gravitational force and is a *conservative force*. We saw that a line integral for work in a conservative force depends only on the endpoints. Verify, that for a closed loop the work integral will yield $0$.

Take as a closed loop the unit circle, parameterized by arc-length by $\vec{r}(t) = \langle \cos(t), \sin(t)\rangle$. The unit tangent will be $\hat{T} = \vec{r}'(t) = \langle -\sin(t), \cos(t) \rangle$. The work to move a particle of charge $q_0$ about a partical of charge $q$ at the origin around the unit circle would be computed through:

````julia

@vars k q q0 t
F(r) = k*q*q0 * r / norm(r)^3
r(t) = [cos(t), sin(t)]
T(r) = [-r[2], r[1]]
W = integrate(F(r(t)) ⋅ T(r(t)), (t, 0, 2PI))
````


````
0
````





### Closed curves and regions;

There are technical assumptions about curves and regions that are necessary for some statements to be made:

* Let $C$ be a [Jordan](https://en.wikipedia.org/wiki/Jordan_curve_theorem) curve -  a non-self-intersecting continuous loop in the plane. Such a curve divides the plane into two regions, one bounded and one unbounded. The normal to a Jordan curve is assumed to be in the direction of the unbounded part.

* Further, we will assume that our curves are *piecewise smooth*. That is comprised of finitely many smooth pieces, continuously connected.

* The region enclosed by a closed curve has an *interior*, $D$, which we assume is an *open* set (one for which every point in $D$ has some "ball" about it entirely within $D$ as well.)

* The region $D$ is *connected* meaning between any two points there is a continuous path in $D$ between the two points.

* The region $D$ is *simply connected*. This means it has no "holes." Technically, any path in $D$ can be contracted to a point. Connected means one piece, simply connected means no holes.


### The fundamental theorem of line integrals

The fact that work in a potential field is path independent is a consequence of the Fundamental Theorem of Line [Integrals](https://en.wikipedia.org/wiki/Gradient_theorem):

> Let $U$ be an open subset of $R^n$, $f: U \rightarrow R$ a *differentiable* function and $\vec{r}: R \rightarrow R^n$ a differentiable function such that the the path $C = \vec{r}(t)$, $a\leq t\leq b$ is contained in $U$. Then
> $$~
> \int_C  \nabla{f} \cdot d\vec{r} =
> \int_a^b \nabla{f}(\vec{r}(t)) \cdot \vec{r}'(t) dt =
> f(\vec{r}(b)) - f(\vec{r}(a)).
> ~$$



That is, a line integral through a gradient field can be evaluated by
evaluating the original scalar field at the endpoints of the
curve. In other words, line integrals through gradient fields are conservative.

Are conservative fields gradient fields? The answer is yes.

Assume $U$ is an open region in $R^n$ and $F$ is  a continuous and conservative vector field in $U$.

Let $a$ in $U$ be some fixed point. For $\vec{x}$ in $U$, define:

$$~
\phi(\vec{x}) = \int_{\vec\gamma[a,\vec{x}]} F \cdot \frac{d\vec\gamma}{dt}dt,
~$$

where $\vec\gamma$ is *any* differentiable path in $U$ connecting $a$ to
$\vec{x}$ (as a point in $U$). The function $\phi$ is uniquely
defined, as the integral only depends on the endpoints, not the choice
of path.

It is [shown](https://en.wikipedia.org/wiki/Gradient_theorem#Converse_of_the_gradient_theorem) that the directional derivative $\nabla{\phi} \cdot \vec{v}$ is equal to $F \cdot \vec{v}$ by showing

$$~
\lim_{t \rightarrow 0}\frac{\phi(\vec{x} + t\vec{v}) - \phi(\vec{x})}{t}
= \lim_{t \rightarrow 0} \frac{1}{t} \int_{\vec\gamma[\vec{x},\vec{x}+t\vec{v}]} F \cdot \frac{d\vec\gamma}{dt}dt
= F(\vec{x}) \cdot \vec{v}.
~$$

This is so for all $\vec{v}$, so in particular for the coordinate vectors. So $\nabla\phi = F$.


##### Example

Let $Radial(x,y) = \langle x, y\rangle$. This is a conservative field. Show the work integral over the half circle in the upper half plane is the same as the work integral over the $x$ axis connecting $-1$ to $1$.

We have:

````julia

Radial(x,y) = [x,y]
Radial(v) = Radial(v...)

r(t) = [-1 + t, 0]
quadgk(t -> Radial(r(t)) ⋅ r'(t), 0, 2)
````


````
(0.0, 0.0)
````





Compared to

````julia

r(t) = [-cos(t), sin(t)]
quadgk(t -> Radial(r(t)) ⋅ r'(t), 0, pi)
````


````
(0.0, 0.0)
````





##### Example





----

Not all vector fields are conservative.  How can a vector field in $U$
be identified as conservative? For now, this would require either
finding a scalar potential *or* showing all line integrals are path
independent.

In dimension $2$ there is an easy to check method assuming $U$ is *simply connected*: If $F=\langle F_x, F_y\rangle$ is continuously differentiable in an simply connected region *and* $\partial{F_y}/\partial{x} - \partial{F_x}/\partial{y} = 0$ then $F$ is conservative. A similarly statement is available in dimension $3$. The reasoning behind this will come from the upcoming Green's theorem.




### Flow across a curve


The flow integral in the $n=2$ case was

$$~
\int_C (F\cdot\hat{N}) ds = \int_a^b (F \circ \vec{r})(t) \cdot (\vec{r}'(t))^{t} dt,
~$$

where $\langle a,b\rangle^t = \langle b, -a\rangle$.


For a given section of $C$, the vector field breaks down into a
tangential and normal component. The tangential component moves along
the curve and so doesn't contribute to any flow *across* the curve, only
the normal component will contribute. Hence the
$F\cdot\hat{N}$ integrand.  The following figure indicates the flow of a vector
field by horizontal lines, the closeness of the lines representing
strength, though these are all evenly space. The two line segments
have equal length, but the one captures more flow than the other, as
its normal vector is more parallel to the flow lines:

![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/line_integrals_15_1.png)




The flow integral is typically computed for a closed (Jordan) curve, measuring the total flow out of a region. In this case, the integral is written $\oint_C (F\cdot\hat{N})ds$.


````
CalculusWithJulia.WeaveSupport.Alert(L"For a Jordan curve, the positive ori
entation of the curve is such that the normal direction (proportional to $\
hat{T}'$) points away from the bounded interior. For a non-closed path, the
 choice of parameterization will determine the normal and the integral for 
flow across a curve is dependent - up to its sign - on this choice.
", Dict{Any,Any}(:class => "info"))
````






##### Example

The [New York Times](https://www.nytimes.com/interactive/2019/06/20/world/asia/hong-kong-protest-size.html) showed aerial photos to estimate the number of protest marchers in Hong Kong. This is a more precise way to estimate crowd size, but requires a drone or some such to take photos. If one is on the ground, the number of marchers could be *estimated* by finding the flow of marchers across a given width. In the Times article, we see "Protestors packed the width of Hennessy Road for more than 5 hours. If this road is 50 meters wide and the rate of the marchers is 3 kilometers per hour, estimate the number of marchers.

The basic idea is to compute the rate of flow *across* a part of the street and then multiply by time. For computational sake, say the marchers are on a grid of 1 meters (that is in a 40m wide street, there is room for 40 marchers at a time. In one minute, the marchers move 50 meters:

````julia

3000/60
````


````
50.0
````





This means the rate of marchers per minute is `40 * 50`. If this is steady over 5 hours, this *simple* count gives:

````julia

40 * 50 * 5 * 60
````


````
600000
````





This is short of the estimate 2M marchers, but useful for a rough estimate. The point is from rates of  flow, which can be calculated locally, amounts over bigger scales can be computed. The word "*across*" is used, as only the direction across the part of the street counts in the computation. Were the marchers in total unison and then told to take a step to the left and a step to the right, they would have motion, but since it wasn't across the line in the road (rather along the line) there would be no contribution to the count. The dot product with the normal vector formalizes this.

##### Example

Let a path $C$ be parameterized by $\vec{r}(t) = \langle \cos(t), 2\sin(t)\rangle$, $0 \leq t \leq \pi/2$ and $F(x,y) = \langle \cos(x), \sin(xy)\rangle$. Compute the flow across $C$.

We have

````julia

r(t) = [cos(t), 2sin(t)]
F(x,y) = [cos(x), sin(x*y)]
F(v) = F(v...)
normal(a,b) = [b, -a]
G(t) = (F ∘ r)(t) ⋅ normal(r(t)...)
a, b = 0, pi/2
quadgk(G, a, b)[1]
````


````
1.0894497472261733
````





##### Example

Example, let $F(x,y) = \langle -y, x\rangle$ be a vector field. (It represents an rotational flow.) What is the flow across the unit circle?

````julia

@vars t real=true
F(x,y) = [-y,x]
F(v) = F(v...)
r(t) = [cos(t),sin(t)]
T(t) = diff.(r(t), t)
normal(a,b) = [b,-a]
integrate((F ∘ r)(t) ⋅ normal(T(t)...) , (t, 0, 2PI))
````


````
0
````







##### Example

Let $F(x,y) = \langle x,y\rangle$ be a vector field. (It represents a *source*.) What is the flow across the unit circle?

````julia

@vars t real=true
F(x,y) = [x, y]
F(v) = F(v...)
r(t) = [cos(t),sin(t)]
T(t) = diff.(r(t), t)
normal(a,b) = [b,-a]
integrate((F ∘ r)(t) ⋅ normal(T(t)...) , (t, 0, 2PI))
````


````
2⋅π
````





##### Example


Let $F(x,y) = \langle x, y\rangle / \| \langle x, y\rangle\|^3$:

````julia

F(x,y) = [x,y] / norm([x,y])^2
F(v) = F(v...)
````


````
F (generic function with 3 methods)
````





Consider $C$ to be the square with vertices at $(-1,-1)$, $(1,-1)$, $(1,1)$, and $(-1, 1)$. What is the flow across $C$ for this vector field? The region has simple outward pointing *unit* normals, these being $\pm\hat{i}$ and $\pm\hat{j}$, the unit vectors in the $x$ and $y$ direction. The integral can be computed in 4 parts. The first (along the bottom):

````julia

@vars s real=true

r(s) = [-1 + s, -1]
n = [0,-1]
A1 = integrate(F(r(s)) ⋅ n, (s, 0, 2))
````


````
π
─
2
````





The other three sides are related as each parameterization and normal is similar:

````julia

r(s) = [1, -1 + s]
n = [1, 0]
A2 = integrate(F(r(s)) ⋅ n, (s, 0, 2))


r(s) = [1 - s, 1]
n = [0, 1]
A3 = integrate(F(r(s)) ⋅ n, (s, 0, 2))


r(s) = [-1, 1-s]
n = [-1, 0]
A4 = integrate(F(r(s)) ⋅ n, (s, 0, 2))

A1 +  A2 +  A3 + A4
````


````
2⋅π
````





As could have been anticipated by symmetry, the answer is simply `4A1` or $2\pi$. What likely is not anticipated, is that this integral will be the same as that found by integrating over the unit circle (an easier integral):

````julia

@vars t real=true
r(t) = [cos(t), sin(t)]
N(t) = r(t)
integrate(F(r(t)) ⋅ N(t), (t, 0, 2PI))
````


````
2⋅π
````





This equivalence is a consequence of the upcoming Green's theorem, as the vector field satisfies a particular equation.




## Surface integrals

````
CalculusWithJulia.WeaveSupport.ImageFile("figures/kapoor-cloud-gate.jpg", "
The Anish Kapoor sculpture Cloud Gate maps the Cartesian grid formed by its
 concrete resting pad onto a curved surface showing the local distortions. 
 Knowing the areas of the reflected grid after distortion would allow the c
omputation of the surface area of the sculpture through addition. (Wikipedi
a)\n")
````






We next turn attention to a generalization of line integrals to surface integrals. Surfaces were described in one of three ways: directly through a function as $z=f(x,y)$, as a level curve through $f(x,y,z) = c$, and parameterized through a function $\Phi: R^2 \rightarrow R^3$. The level curve description is locally a function description, and the function description leads to a parameterization ($\Phi(u,v) = \langle u,v,f(u,v)\rangle$) so we restrict to the parameterized case.




Consider the figure of the surface described by $\Phi(u,v) = \langle u,v,f(u,v)\rangle$:


````
Plot{Plots.PlotlyBackend() n=41}
````





The partitioning of the $u-v$ plane into a grid, lends itself to a partitioning of the surface. To compute the total *surface area* of the surface, it would be natural to begin by *approximating* the area of each cell of this partition and add. As with other sums, we would expect that as the cells got smaller in diameter, the sum would approach an integral, in this case an integral yielding the surface area.

Consider a single cell:





The figure shows that a cell on the grid in the $u-v$ plane of area $\Delta{u}\Delta{v}$ maps to a cell of the partition with surface area $\Delta{S}$ which can be *approximated* by a part of the tangent plane described by two vectors $\vec{v}_1 = \partial{\Phi}/\partial{u}$ and $\vec{v}_2 = \partial{\Phi}/\partial{v}$. These two vectors have cross product which a) points in the direction of the normal vector, and b) has magnitude yielding the approximation $\Delta{S} \approx \|\vec{v}_1 \times \vec{v}_2\|\Delta{u}\Delta{v}$.

If we were to integrate the function $G(x,y, z)$ over the *surface* $S$, then an approximating Riemann sum could be produced by $G(c) \| \vec{v}_1 \times \vec{v}_2\| \Delta u \Delta v$, for some point $c$ on the surface.

In the limit a definition of an *integral* over a surface $S$ in $R^3$ is found by a two-dimensional integral over $R$ in $R^2$:

$$~
\int_S G(x,y,z) dS = \int_R G(\Phi(u,v))
\| \frac{\partial{\Phi}}{\partial{u}} \times \frac{\partial{\Phi}}{\partial{v}} \| du dv.
~$$

In the case that the surface is described by $z = f(x,y)$, then the formula's become $\vec{v}_1 = \langle 1,0,\partial{f}/\partial{x}\rangle$ and $\vec{v}_2 = \langle 0, 1, \partial{f}/\partial{y}\rangle$ with cross product $\vec{v}_1\times\vec{v}_2 =\langle -\partial{f}/\partial{x},  -\partial{f}/\partial{y},1\rangle$.

The value $\| \frac{\partial{\Phi}}{\partial{u}} \times
\frac{\partial{\Phi}}{\partial{y}} \|$ is called the *surface
element*. As seen, it is the scaling between a unit area in the $u-v$
plane and the approximating area on the surface after the
parameterization.

### Examples

Let us see that the formula holds for some cases where the answer is known by other means.

##### A cone

The surface area of cone is a known quantity. In cylindrical coordinates, the cone may be described by $z = a - br$, so the parameterization $(r, \theta) \rightarrow \langle r\cos(\theta), r\sin(\theta), a - br \rangle$ maps $T = [0, a/b] \times [0, 2\pi]$ onto the surface (less the bottom).

The surface element is the cross product $\langle \cos(\theta), \sin(\theta), -b\rangle$ and $\langle -r\sin(\theta), r\cos(\theta), 0\rangle$, which is:

````julia

@vars R theta a b positive=true
n = [cos(theta), sin(theta), -b] × [-R*sin(theta), R*cos(theta), 0]
se = simplify(norm(n))
````


````
________
    ╱  2     
R⋅╲╱  b  + 1
````





(To do this computationally, one might compute:
````julia

Phi(r, theta) = [r*cos(theta), r*sin(theta), a - b*r]
Phi(R, theta).jacobian([R, theta])
````


````
3×2 Array{Sym,2}:
 cos(θ)  -R⋅sin(θ)
 sin(θ)   R⋅cos(θ)
         -b              0
````





and from here pull out the two vectors to take a cross product.)


The surface area is then found by integrating $G(\vec{x}) = 1$:

````julia

integrate(1 * se, (R, 0, a/b), (theta, 0, 2PI))
````


````
________
   2   ╱  2     
π⋅a ⋅╲╱  b  + 1 
────────────────
        2       
       b
````





A formula from a *quick* Google search is $A = \pi r(r^2  + \sqrt{h^2 + r^2}$. Does this match up?

````julia

R = a/b; h = a
pi * R * (R + sqrt(R^2 + h^2)) |> simplify
````


````
⎛   ________    ⎞
   2 ⎜  ╱  2         ⎟
π⋅a ⋅⎝╲╱  b  + 1  + 1⎠
──────────────────────
           2          
          b
````





Nope, off by a summand of $\pi(a/b)^2 = \pi r^2$, which may be recognized as the area of the base, which we did not compute, but which the Google search did. So yes, the formulas do agree.

##### Example

The sphere has known surface area $4\pi r^2$. Let's see if we can compute this. With the parameterization from spherical coordinates $(\theta, \phi) \rightarrow \langle r\sin\phi\cos\theta, r\sin\phi\sin\theta,r\cos\phi\rangle$, we have approaching this *numerically*:

````julia

Rad = 1
Phi(theta, phi) = Rad * [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)]
Phi(v) = Phi(v...)

function surface_element(pt)
  Jac = ForwardDiff.jacobian(Phi, pt)
  v1, v2 = Jac[:,1], Jac[:,2]
  norm(v1 × v2)
end
out = hcubature(surface_element, (0, 0), (2pi, 1pi))
out[1] - 4pi*Rad^2  # *basically* zero
````


````
8.15347789284715e-13
````






##### Example

In [Surface area](../integrals/surface_area.mmd) the following formula for the surface area of a surface of *revolution* about the $x$ axis is described by $r=f(x)$ is given:

$$~
\int_a^b 2\pi f(x) \cdot \sqrt{1 + f'(x)^2} dx.
~$$

Consider the transformation $(x, \theta) \rightarrow \langle x, f(x)\cos(\theta), f(x)\sin(\theta)$. This maps the region $[a,b] \times [0, 2\pi]$ *onto* the surface of revolution. As such, the surface element would be:

````julia

H = SymFunction("H")
@vars x theta real=true
Phi(x, theta) = [x, H(x)*cos(theta), H(x)*sin(theta)]
Jac = Phi(x, theta).jacobian([x, theta])
v1, v2 = Jac[:,1], Jac[:,2]
norm(v1 × v2)
````


````
______________________________________________________________________
___
    ╱                                                                      
   
   ╱               2                2   │        2    d                  2 
   
  ╱   │H(x)⋅sin(θ)│  + │H(x)⋅cos(θ)│  + │H(x)⋅sin (θ)⋅──(H(x)) + H(x)⋅cos (
θ)⋅
╲╱                                      │             dx                   
   

___________
         2 
d       │  
──(H(x))│  
dx      │
````





We divide by `H(x)` and expect (and see) the square root of $1$ plus the derivative:

````julia

norm((v1 × v2)/H(x)) .|> simplify
````


````
_________________
    ╱           2     
   ╱  │d       │      
  ╱   │──(H(x))│  + 1 
╲╱    │dx      │
````





##### Example

Consider the *upper* half sphere, $S$. Compute $\int_S z dS$.

Were the half sphere made of a thin uniform material, this would be computed to find the $z$ direction of the centroid.

We use the spherical coordinates to parameterize:

$$~
\Phi(\theta, \phi) = \langle \cos(\phi)\cos(\theta), \cos(\phi)\sin(\theta), \sin(\phi) \rangle
~$$

The Jacobian, and surface element can be computed:

````julia

@vars theta phi real=true
Phi(theta, phi) = [cos(phi)*cos(theta), cos(phi)*sin(theta), sin(phi)]
Jac = Phi(theta,phi).jacobian([theta, phi])
v1, v2 = Jac[:,1], Jac[:,2]
SurfElement = norm(v1 × v2) |> simplify
````


````
│cos(φ)│
````





With this our integral becomes:

````julia

z = sin(phi)
integrate(z * SurfElement, (theta, 0, 2PI), (phi, 0, PI/2))
````


````
π
````





### Orientation

A smooth surface $S$ is *orientable* if it possible to define a unit normal vector, $\vec{N}$ that varies continuously with position. For example, a sphere has a normal vector that does this. On the other hand, a Mobius strip does not, as a normal when moved around the surface may necessarily be reversed as it returns to its starting point. For a closed, orientable smooth surface there are two possible choices for a normal, and convention chooses the one that points away from the contained region, such as the outward pointing normal for the sphere or torus.


### Surface integrals in vector fields

Beyond finding surface area, surface integrals can also compute interesting physical phenomena. These are often associated to a vector field (in this case a function $\vec{F}: R^3 \rightarrow R^3$), and the typical case is the *flux* through a surface defined locally by $\vec{F} \cdot \hat{N}$, that is the *magnitude* of the *projection* of the field onto the *unit* normal vector.


Consider the flow of water through an opening in a time period $\Delta t$. The amount of water mass to flow through would be the area of the opening times the velocity of the flow perpendicular to the surface times the density times the time period; symbolically: $dS \cdot ((\rho \vec{v}) \cdot \vec{N}) \cdot \Delta t$. Dividing by $\Delta t$ gives a rate of flow as $((\rho \vec{v}) \cdot \vec{N}) dS$. With $F = \rho \vec{v}$, the flux integral can be seen as the rate of flow through a surface.

To find the normal for a surface element arising from a parameterization $\Phi$, we have the two *partial* derivatives $\vec{v}_1=\partial{\Phi}/\partial{u}$ and $\vec{v}_2 = \partial{\Phi}/\partial{v}$, the two column vectors of the Jacobian matrix of $\Phi(u,v)$. These describe the tangent plane, and even more their cross product will be a) *normal* to the tangent plane and b) have magnitude yielding the surface element of the transformation.


From this, for a given parameterization, $\Phi(u,v):T \rightarrow S$, the following formula is suggested for orientable surfaces:

$$~
\int_S \vec{F} \cdot \hat{N} dS =
\int_T \vec{F}(\Phi(u,v)) \cdot
(\frac{\partial{\Phi}}{\partial{u}} \times \frac{\partial{\Phi}}{\partial{v}})
du dv.
~$$


When the surface is described by a function, $z=f(x,y)$, the parameterization is $(u,v) \rightarrow \langle u, v, f(u,v)\rangle$, and the two vectors are $\vec{v}_1 = \langle 1, 0, \partial{f}/\partial{u}\rangle$ and $\vec{v}_2 = \langle 0, 1, \partial{f}/\partial{v}\rangle$ and their cross product is $\vec{v}_1\times\vec{v}_1=\langle -\partial{f}/\partial{u}, -\partial{f}/\partial{v}, 1\rangle$.


##### Example

Suppose a vector field $F(x,y,z) = \langle 0, y, -z \rangle$ is given. Let $S$ be the surface of the paraboloid $y = x^2 + z^2$ between $y=0$ and $y=4$. Compute the surface integral $\int_S F\cdot \hat{N} dS$.

This is a surface of revolution about the $y$ axis, so a parameterization is
$\Phi(y,\theta) = \langle \sqrt{y} \cos(\theta), y, \sqrt{y}\sin(\theta) \rangle$. The surface normal is given by:

````julia

@vars y theta positive=true
Phi(y,theta) = [sqrt(y)*cos(theta), y, sqrt(y)*sin(theta)]
Jac = Phi(y, theta).jacobian([y, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2
````


````
3-element Array{Sym,1}:
               √y⋅cos(θ)
 -sin(theta)^2/2 - cos(theta)^2/2
               √y⋅sin(θ)
````





With this, the surface integral becomes:

````julia

F(x,y,z) = [0, y, -z]
F(v) = F(v...)
integrate(F(Phi(y,theta)) ⋅ Normal, (theta, 0, 2PI), (y, 0, 4))
````


````
-16⋅π
````





##### Example

Let $S$ be the closed surface bounded by the cylinder $x^2 + y^2 = 1$, the plane $z=0$, and the plane $z = 1+x$. Let $F(x,y,z) =  \langle 1, y, -z \rangle$. Compute $\oint_S F\cdot\vec{N} dS$.


````julia

F(x,y,z) = [1, y, z]
F(v) = F(v...)
````


````
F (generic function with 3 methods)
````





The surface has three faces, with different outward pointing normals for each. Let $S_1$ be the unit disk in the $x-y$ plane with normal $-\hat{k}$; $S_2$ be the top part, with normal $\langle \langle-1, 0, 1\rangle$ (as the plane is $-1x + 0y + 1z = 1$); and $S_3$ be the cylindrical part with outward pointing normal $\vec{r}$.


Integrating over $S_1$, we have the parameterization $\Phi(r,\theta) = \langle r\cos(\theta), r\sin(\theta), 0\rangle$:

````julia

@vars R theta positive=true
Phi(r,theta) = [r*cos(theta), r*sin(theta), 0]
Jac = Phi(R, theta).jacobian([R, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2 .|> simplify
````


````
3-element Array{Sym,1}:
 0
 0
 R
````



````julia

F(x,y,z)= [1, y, -z]
A1 = integrate(F(Phi(R, theta)) ⋅ (-Normal), (theta, 0, 2PI), (R, 0, 1))  # use -Normal for outward pointing
````


````
0
````





Integrating over $S_2$ we use the parameterization $\Phi(r, \theta) = \langle r\cos(\theta), r\sin(\theta), 1 + r\cos(\theta)\rangle$.

````julia

Phi(r, theta) = [r*cos(theta), r*sin(theta), 1 + r*cos(theta)]
Jac = Phi(R, theta).jacobian([R, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2 .|> simplify  # has correct orientation
````


````
3-element Array{Sym,1}:
 -R
  0
  R
````





With this, the contribution for $S_2$ is:

````julia

A2 = integrate(F(Phi(R, theta)) ⋅ (Normal), (theta, 0, 2PI), (R, 0, 1))
````


````
-2⋅π
````





Finally for $S_3$, the parameterization used is $\Phi(z, \theta) = \langle \cos(\theta), \sin(\theta), z\rangle$, but this is over a non-rectangular region, as $z$ is between $0$ and $1 + x$.

This parameterization gives a normal computed through:

````julia

@vars z positive=true
Phi(z, theta) = [cos(theta), sin(theta), z]
Jac = Phi(z, theta).jacobian([z, theta])
v1, v2 = Jac[:,1], Jac[:,2]
Normal = v1 × v2 .|> simplify  # wrong orientation, so we change sign below
````


````
3-element Array{Sym,1}:
 -cos(θ)
 -sin(θ)
           0
````





The contribution is

````julia

A3 = integrate(F(Phi(Rad, theta)) ⋅ (-Normal), (z, 0, 1 + cos(theta)), (theta, 0, 2PI))
````


````
2⋅π
````





In total, the surface integral is

````julia

A1 + A2 + A3
````


````
0
````





##### Example

Two point charges with charges $q$ and $q_0$ will exert an electrostatic force of attraction or repulsion according to [Coulomb](https://en.wikipedia.org/wiki/Coulomb%27s_law)'s law. The Coulomb force is $kqq_0\vec{r}/\|\vec{r}\|^3$.
This force is proportional to the product of the charges, $qq_0$, and inversely proportional to the square of the distance between them.

The electric field is a vector field is the field generated by the force on a test charge, and is given by $E = kq\vec{r}/\|\vec{r}\|^3$.


Let $S$ be the unit sphere $\|\vec{r}\|^2 = 1$. Compute the surface integral of the electric field over the closed surface, $S$.

We have (using $\oint$ for a surface integral over a closed surface):

$$~
\oint_S S \cdot \vec{N} dS =
\oint_S \frac{kq}{\|\vec{r}\|^2} \hat{r} \cdot \hat{r} dS =
\oint_S \frac{kq}{\|\vec{r}\|^2} dS =
kqq_0 \cdot SA(S) =
4\pi k q
~$$


Now consider the electric field generated by a point charge within the unit sphere, but not at the origin. The integral now will not fall in place by symmetry considerations, so we will approach the problem numerically.


````julia

E(r) = (1/norm(r)^2) * uvec(r) # kq = 1

Phi(theta, phi) = 1*[sin(phi)*cos(theta), sin(phi) * sin(theta), cos(phi)]
Phi(r) = Phi(r...)

normal(r) = Phi(r)/norm(Phi(r))

function SE(r)
    Jac = ForwardDiff.jacobian(Phi, r)
    v1, v2 = Jac[:,1], Jac[:,2]
    v1 × v2
end

a = rand() * Phi(2pi*rand(), pi*rand())
A1 = hcubature(r -> E(Phi(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,0.0), (2pi, 1pi))
A1[1]
````


````
12.566370614781192
````





The answer is $4\pi$, regardless of the choice of `a`, as long as it is *inside* the surface. (We see above, some fussiness in the limits of integration. `HCubature` does some conversion of the limits, but does not *currently* do well with mixed types, so in the above only floating point values are used.)

When `a` is *outside* the surface, the answer is *always*:

````julia

a = 2 * Phi(2pi*rand(), pi*rand())  # random point with radius 2
A1 = hcubature(r -> E(Phi(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,0.0), (2pi, pi/2))
A2 = hcubature(r -> E(Phi(r)-a) ⋅ normal(r) * norm(SE(r)), (0.0,pi/2), (2pi, 1pi))
A1[1] + A2[1]
````


````
-3.5388802999136715e-11
````





Always $0$.

This is a consequence of [Gauss's law](https://en.wikipedia.org/wiki/Gauss%27s_law), which states that for an electric field $E$, the electric flux through a closed surface is proportional to the total charge contained. (Gauss's law is related to the upcoming divergence theorem.) When `a` is inside the surface, the total charge is the same regardless of exactly where, so the integral's value is always the same. When `a` is outside the surface, the total charge inside the sphere is $0$, so the flux integral is as well.

Gauss's law is typically used to identify the electric field by choosing a judicious surface where the surface integral can be computed. For example, suppose a ball of radius $R_0$ has a *uniform* charge. What is the electric field generated? *Assuming* it is dependent only on the distance from the center of the charged ball, we can, first, take a sphere of radius $R > R_0$ and note that $E(\vec{r})\cdot\hat{N}(r) = \|E(R)\|$, the magnitude a distance $R$ away. So the surface integral is simply $\|E(R)\|4\pi R^2$ and by Gauss's law a constant depending on the total charge. So $\|E(R)\| ~ 1/R^2$. When $R < R_0$, the same applies, but the total charge within the surface will be like $(R/R_0 )^3$, so the result will be *linear* in $R$, as:

$$~
4 \pi \|E(R)\| R^2 = k 4\pi \left(\frac{R}{R_0}\right)^3.
~$$




## Questions

###### Question

Let $\vec{r}(t) = \langle e^t\cos(t), e^{-t}\sin(t) \rangle$.

What is $\|\vec{r}'(1/2)\|$?

````
CalculusWithJulia.WeaveSupport.Numericq(0.699461297570161, 0.001, "", "[0.6
9846, 0.70046]", 0.698461297570161, 0.700461297570161, "", "")
````





What is the $x$ (first) component of $\hat{N}(t) = \hat{T}'(t)/\|\hat{T}'(t)\|$ at $t=1/2$?

````
CalculusWithJulia.WeaveSupport.Numericq(0.3452577617116201, 0.001, "", "[0.
34426, 0.34626]", 0.3442577617116201, 0.3462577617116201, "", "")
````






###### Question

Let $\Phi(u,v) = \langle u,v,u^2+v^2\rangle$ parameterize a surface. Find the magnitude of
$\| \partial{\Phi}/\partial{u} \times  \partial{\Phi}/\partial{v} \|$ at $u=1$ and $v=2$.

````
CalculusWithJulia.WeaveSupport.Numericq(4.58257569495584, 0.001, "", "[4.58
158, 4.58358]", 4.5815756949558395, 4.58357569495584, "", "")
````






###### Question

For a plane $ax+by+cz=d$ find the unit normal.

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\langle a
, b, c\rangle / \| \langle a, b, c\rangle\|$", L"$\langle d-a, d-b, d-c\ran
gle / \| \langle d-a, d-b, d-c\rangle\|$", L"$\langle a, b, c\rangle$"], 1,
 "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"$\langle a, b, c\rangle
 / \| \langle a, b, c\rangle\|$", L"$\langle d-a, d-b, d-c\rangle / \| \lan
gle d-a, d-b, d-c\rangle\|$", L"$\langle a, b, c\rangle$"], "", false)
````





Does it depend on $d$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"No. Moving
 $d$ just shifts the plane up or down the $z$ axis, but won't change the no
rmal vector", L"Yes. The gradient of $F(x,y,z) = ax + by + cz$ will be norm
al to the level curve $F(x,y,z)=d$, and so this will depend on $d$.", L"Yes
. Of course. Different values for $d$ mean different values for $x$, $y$, a
nd $z$ are needed."], 1, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L
"No. Moving $d$ just shifts the plane up or down the $z$ axis, but won't ch
ange the normal vector", L"Yes. The gradient of $F(x,y,z) = ax + by + cz$ w
ill be normal to the level curve $F(x,y,z)=d$, and so this will depend on $
d$.", L"Yes. Of course. Different values for $d$ mean different values for 
$x$, $y$, and $z$ are needed."], "", false)
````








###### Question

Let $\vec{r}(t) = \langle \cos(t), \sin(t), t\rangle$ and let $F(x,y,z) = \langle -y, x, z\rangle$

Numerically compute $\int_0^{2\pi} F(\vec{r}(t)) \cdot \vec{r}'(t) dt$.

````
CalculusWithJulia.WeaveSupport.Numericq(26.022394109358302, 0.001, "", "[26
.02139, 26.02339]", 26.0213941093583, 26.023394109358303, "", "")
````






Compute the value symbolically:

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$2\pi^2$",
 L"$2\pi + 2\pi^2$", L"$4\pi$"], 2, "", nothing, [1, 2, 3], LaTeXStrings.La
TeXString[L"$2\pi^2$", L"$2\pi + 2\pi^2$", L"$4\pi$"], "", false)
````





###### Question


Let $F(x,y) = \langle 2x^3y^2, xy^4 + 1\rangle$. What is the work done in integrating $F$ along the parabola $y=x^2$ between $(-1,1)$ and $(1,1)$? Give a numeric answer:

````
CalculusWithJulia.WeaveSupport.Numericq(0.36363636363636326, 0.001, "", "[0
.36264, 0.36464]", 0.36263636363636326, 0.36463636363636326, "", "")
````







###### Question

Let $F = \nabla{f}$ where $f:R^2 \rightarrow R$. The level curves of $f$ are curves in the $x-y$ plane where $f(x,y)=c$, for some constant $c$. Suppose $\vec{r}(t)$ describes a path on the level curve of $f$. What is the value of $\int_C F \cdot d\vec{r}$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"It will $f
(b)-f(a)$ for any $b$ or $a$", L"It will be $0$, as $\nabla{f}$ is orthogon
al to the level curve and $\vec{r}'$ is tangent to the level curve"], 2, ""
, nothing, [1, 2], LaTeXStrings.LaTeXString[L"It will $f(b)-f(a)$ for any $
b$ or $a$", L"It will be $0$, as $\nabla{f}$ is orthogonal to the level cur
ve and $\vec{r}'$ is tangent to the level curve"], "", false)
````






###### Question

Let $F(x,y) = (x^2+y^2)^{-k/2} \langle x, y \rangle$ be a radial field. The work integral around the unit circle simplifies:

$$~
\int_C F\cdot \frac{dr}{dt} dt = \int_0^{2pi} \langle (1)^{-k/2} \cos(t), \sin(t) \rangle \cdot \langle-\sin(t), \cos(t)\rangle dt.
~$$

For any $k$, this integral will be:

````
CalculusWithJulia.WeaveSupport.Numericq(0, 0, "", "[0.0, 0.0]", 0, 0, "", "
")
````





###### Question

Let $f(x,y) = \tan^{-1}(y/x)$. We will integrate $\nabla{f}$ over the unit circle. The integrand wil be:

````julia

@vars t real=true
f(x,y) =  atan(y/x)
r(t) = [cos(t), sin(t)]
∇f = subs.(∇(f(x,y)), x .=> r(t)[1], y .=> r(t)[2]) .|> simplify
drdt = diff.(r(t), t)
∇f ⋅ drdt |> simplify
````


````
1
````





So $\int_C \nabla{f}\cdot d\vec{r} = \int_0^{2\pi} \nabla{f}\cdot d\vec{r}/dt dt = 2\pi$.

Why is this surprising?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"The field 
is a potential field, but the path integral around $0$ is not path dependen
t.", L"The value of $d/dt(f\circ\vec{r})=0$, so the integral should be $0$.
"], 1, "", nothing, [1, 2], LaTeXStrings.LaTeXString[L"The field is a poten
tial field, but the path integral around $0$ is not path dependent.", L"The
 value of $d/dt(f\circ\vec{r})=0$, so the integral should be $0$."], "", fa
lse)
````





The function $F = \nabla{f}$ is

````
CalculusWithJulia.WeaveSupport.Radioq(["Not continuous everywhere", "Contin
uous everywhere"], 1, "", nothing, [1, 2], ["Not continuous everywhere", "C
ontinuous everywhere"], "", false)
````





###### Question

Let $F(x,y) = \langle F_x, F_y\rangle = \langle 2x^3y^2, xy^4 + 1\rangle$. Compute

$$~
\frac{\partial{F_y}}{\partial{x}}- \frac{\partial{F_x}}{\partial{y}}.
~$$

Is this $0$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````






###### Question

Let $F(x,y) = \langle F_x, F_y\rangle = \langle 2x^3, y^4 + 1\rangle$. Compute

$$~
\frac{\partial{F_y}}{\partial{x}} - \frac{\partial{F_x}}{\partial{y}}.
~$$

Is this $0$?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````







###### Question

It is not unusual to see a line integral, $\int F\cdot d\vec{r}$, where $F=\langle M, N \rangle$ expressed as $\int Mdx + Ndy$. This uses the notation for a differential form, so is familiar in some theoretical usages, but does not readily lend itself to computation. It does yield pleasing formulas, such as $\oint_C x dy$ to give the area of a two-dimensional region, $D$, in terms of a line integral around its perimeter. To see that this is so, let $\vec{r}(t) = \langle a\cos(t), b\sin(t)\rangle$, $0 \leq t \leq 2\pi$. This parameterizes an ellipse. Let $F(x,y) = \langle 0,x\rangle$. What does $\oint_C xdy$ become when translated into $\int_a^b (F\circ\vec{r})\cdot\vec{r}' dt$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\int_0^{2
\pi} (a\cos(t)) \cdot (a\cos(t)) dt$", L"$\int_0^{2\pi} (a\cos(t)) \cdot (b
\cos(t)) dt$", L"$\int_0^{2\pi} (-b\sin(t)) \cdot (b\cos(t)) dt$"], 2, "", 
nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"$\int_0^{2\pi} (a\cos(t)) \c
dot (a\cos(t)) dt$", L"$\int_0^{2\pi} (a\cos(t)) \cdot (b\cos(t)) dt$", L"$
\int_0^{2\pi} (-b\sin(t)) \cdot (b\cos(t)) dt$"], "", false)
````






###### Question

Let a surface be parameterized by $\Phi(u,v) = \langle u\cos(v), u\sin(v), u\rangle$.

Compute $\vec{v}_1 = \partial{\Phi}/\partial{u}$

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\langle \
cos(v), \sin(v), 1\rangle$", L"$\langle -u\sin(v), u\cos(v), 0\rangle$", L"
$u\langle -\cos(v), -\sin(v), 1\rangle$"], 1, "", nothing, [1, 2, 3], LaTeX
Strings.LaTeXString[L"$\langle \cos(v), \sin(v), 1\rangle$", L"$\langle -u\
sin(v), u\cos(v), 0\rangle$", L"$u\langle -\cos(v), -\sin(v), 1\rangle$"], 
"", false)
````





Compute $\vec{v}_2 = \partial{\Phi}/\partial{u}$

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\langle \
cos(v), \sin(v), 1\rangle$", L"$\langle -u\sin(v), u\cos(v), 0\rangle$", L"
$u\langle -\cos(v), -\sin(v), 1\rangle$"], 2, "", nothing, [1, 2, 3], LaTeX
Strings.LaTeXString[L"$\langle \cos(v), \sin(v), 1\rangle$", L"$\langle -u\
sin(v), u\cos(v), 0\rangle$", L"$u\langle -\cos(v), -\sin(v), 1\rangle$"], 
"", false)
````





Compute $\vec{v}_1 \times \vec{v}_2$


````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\langle \
cos(v), \sin(v), 1\rangle$", L"$\langle -u\sin(v), u\cos(v), 0\rangle$", L"
$u\langle -\cos(v), -\sin(v), 1\rangle$"], 3, "", nothing, [1, 2, 3], LaTeX
Strings.LaTeXString[L"$\langle \cos(v), \sin(v), 1\rangle$", L"$\langle -u\
sin(v), u\cos(v), 0\rangle$", L"$u\langle -\cos(v), -\sin(v), 1\rangle$"], 
"", false)
````






###### Question

For the surface parameterized by $\Phi(u,v) = \langle uv, u^2v, uv^2\rangle$ for $(u,v)$ in $[0,1]\times[0,1]$, numerically find the surface area.

````
CalculusWithJulia.WeaveSupport.Numericq(0.4188868549037433, 0.001, "", "[0.
41789, 0.41989]", 0.4178868549037433, 0.4198868549037433, "", "")
````





###### Question

For the surface parameterized by $\Phi(u,v) = \langle uv, u^2v, uv^2\rangle$ for $(u,v)$ in $[0,1]\times[0,1]$ and vector field $F(x,y,z) =\langle y^2, x, z\langle$, numerically find $\iint_S (F\cdot\hat{N}) dS$.

````
CalculusWithJulia.WeaveSupport.Numericq(-0.06011904761868202, 0.001, "", "[
-0.06112, -0.05912]", -0.06111904761868202, -0.059119047618682016, "", "")
````





###### Question

Let $F=\langle 0,0,1\rangle$ and $S$ be the upper-half unit sphere, parameterized by $\Phi(\theta, \phi) = \langle \sin(\phi)\cos(\theta), \sin(\phi)\sin(\theta), \cos(\phi)\rangle$. Compute $\iint_S (F\cdot\hat{N}) dS$ numerically. Choose the normal direction so that the answer is postive.

````
CalculusWithJulia.WeaveSupport.Numericq(3.1415926535899974, 0.001, "", "[3.
14059, 3.14259]", 3.1405926535899975, 3.1425926535899973, "", "")
````





###### Question

Let $\phi(x,y,z) = xy$ and $S$ be the triangle $x+y+z=1$, $x,y,z \geq 0$. The surface may be described by $z=f(x,y) = 1 - (x + y)$, $0\leq y \leq 1-x, 0 \leq x \leq 1$ is useful in describing the surface. With this, the following integral will compute $\int_S \phi dS$:

$$~
\int_0^1 \int_0^{1-x} xy \sqrt{1 + \left(\frac{\partial{f}}{\partial{x}}\right)^2 + \left(\frac{\partial{f}}{\partial{y}}\right)^2} dy dx.
~$$

Compute this.

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$1/12$", L
"$2/\sqrt{24}$", L"$\sqrt{2}/24$"], 3, "", nothing, [1, 2, 3], LaTeXStrings
.LaTeXString[L"$1/12$", L"$2/\sqrt{24}$", L"$\sqrt{2}/24$"], "", false)
````






###### Question

Let $\Phi(u,v) = \langle u^2, uv, v^2\rangle$, $(u,v)$ in $[0,1]\times[0,1]$ and $F(x,y,z) = \langle x,y^2,z^3\rangle$. Find  $\int_S (F\cdot\hat{N})dS$

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$17/252$",
 L"$7/36$", L"$1/60$", L"$0$"], 1, "", nothing, [1, 2, 3, 4], LaTeXStrings.
LaTeXString[L"$17/252$", L"$7/36$", L"$1/60$", L"$0$"], "", false)
````


