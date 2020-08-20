# Related rates





Related rates problems involve two (or more) unknown quantities that
are related through an equation. As the two variables depend on each
other, also so do their rates - change with respect to some variable
which is often time, though exactly how remains to be
discovered. Hence the name "related rates."

## Examples

The following is a typical "book" problem:

> A screen saver displays the outline of a 3 cm by 2 cm rectangle and
> then expands the rectangle in such a way that the 2 cm side is
> expanding at the rate of 4 cm/sec and the proportions of the
> rectangle never change.  How fast is the area of the rectangle
> increasing when its dimensions are 12 cm by 8 cm?
> [Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html)

````
CalculusWithJulia.WeaveSupport.ImageFile("/var/folders/k0/94d1r7xd2xlcw_jkg
qq4h57w0000gr/T/jl_SSFz3e.gif", L"
As $t$ increases, the size of the rectangle grows. The ratio of width to he
ight is fixed. If we know the rate of change in time for the width ($dw/dt$
) and the height ($dh/dt$) can we tell the rate of change of *area* with re
spect to time ($dA/dt$)?

")
````





Here we know $A = w \cdot h$ and we know some things about how $w$ and
$h$ are related *and* about the rate of how both $w$ and $h$ grow in
time $t$. That means that we could express this growth in terms of
some functions $w(t)$ and $h(t)$, then we can figure out that the area - as a function of $t$ - will be expressed as:

$$~
A(t) = w(t) \cdot h(t).
~$$

We would get by the product rule that the *rate of change* of area with respect to time, $A'(t)$ is just:

$$~
A'(t) = w'(t) h(t) + w(t) h'(t).
~$$

As an aside, it is fairly conventional to suppress the $(t)$ part of
the notation $A=wh$ and to use the Leibniz notation for derivatives:

$$~
\frac{dA}{dt} = \frac{dw}{dt} h + w \frac{dh}{dt}.
~$$

This relationship is true for all $t$, but the problem discusses a
certain value of $t$ - when $w(t)=8$ and $h(t) = 12$. At this same
value of $t$, we have $w'(t) = 4$ and so $h'(t) = 6$. Substituting these 4 values into the 4 unknowns in the formula for $A'(t)$ gives:

$$~
A'(t) = 4 \cdot 12 + 8 \cdot 6 = 96.
~$$

Summarizing, from the relationship between $A$, $w$ and $t$, there is
a relationship between their rates of growth with respect to $t$, a
time variable. Using this and known values, we can compute. In this
case $A'$ at the specific $t$.


We could also have done this differently. We would recognize the following:

-  The area of a rectangle is just:

````julia

A(w,h) = w * h
````


````
A (generic function with 1 method)
````





- The width - expanding at a rate of $4t$ from a starting value of $2$ - must satisfy:

````julia

w(t) = 2 + 4*t
````


````
w (generic function with 1 method)
````





- The height is a constant proportion of the width:

````julia

h(t) = 3/2 * w(t)
````


````
h (generic function with 1 method)
````





This means again that area depends on $t$ through this formula:

````julia

A(t) = A(w(t), h(t))
````


````
A (generic function with 2 methods)
````






This is why the rates of change are related: as $w$ and $h$ change in
time, the functional relationship with $A$ means $A$ also changes in
time.



Now to answer the question, when the width is 8, we must have that $t$ is:

````julia

using CalculusWithJulia               # loads `ForwardDiff`, `Roots`
using Plots
tstar = fzero(x -> w(x) - 8, [0, 4])  # or solve by hand to get 3/2
````


````
1.5
````





The question is to find the rate the area is increasing at the given
time $t$, which is $A'(t)$ or $dA/dt$. We get this by performing the
differentiation, the substituting in the value.

Here we do so with the aid of `Julia`, though this problem could readily be done "by hand."

We (again) re-express $A$ as a function of $t$ by composition, then differentiate that:

````julia

A(t) = A(w(t), h(t))
da_dt = A'(tstar)
````


````
96.0
````





So what? Why is 96 of any interest? It is if the value at a specific
time is needed. But in general, a better question might be to
understand if there is some pattern to the numbers in the figure,
these being $6, 54, 150, 294, 486, 726$. Their differences are the
*average* rate of change:

````julia

xs = [6, 54, 150, 294, 486, 726]
ds = diff(xs)
````


````
5-element Array{Int64,1}:
  48
  96
 144
 192
 240
````





Those seem to be increasing by a fixed amount each time, which we can see by one more application of `diff`:

````julia

diff(ds)
````


````
4-element Array{Int64,1}:
 48
 48
 48
 48
````





How can this relationship be summarized? Well, let's go back to what we know, though this time using symbolic math:

````julia

using SymPy
@vars t
diff(A(t), t)
````


````
48.0⋅t + 24.0
````





This should be clear: the rate of change, $dA/dt$, is increasing
linearly, hence the second derivative, $dA^2/dt^2$ would be constant,
just as we saw for the average rate of change.

So, for this problem, a constant rate of change in width and height
leads to a linear rate of change in area, put otherwise, linear growth
in both width and height leads to quadratic growth in area.

##### Example

A ladder, with length $l$, is leaning against a wall. We parameterize
this problem so that the top of the ladder is at $(0,h)$ and the
bottom at $(b, 0)$. Then $l^2 = h^2 + b^2$ is a constant.

If the ladder starts to slip away at the base, but remains in contact
with the wall, express the rate of change of $h$ with respect to $t$
in terms of $db/dt$.

We have from implicitly differentiating in $t$ the equation $l^2 = h^2 + b^2$,  noting that $l$ is a constant, that:

$$~
0 = 2h \frac{dh}{dt} + 2b \frac{db}{dt}.
~$$


Solving, yields:

$$~
\frac{dh}{dt} = -\frac{b}{h} \cdot \frac{db}{dt}.
~$$


* If $l = 12$ and $db/dt = 2$ when $b=4$, find $dh/dt$.

We just need to find $h$ for this value of $b$, as the other two quantities in the last equation are known. But $h = \sqrt{l^2 - b^2}$, so the answer is:

````julia

l, b, dbdt = 12, 4, 2
height = sqrt(l^2 - b^2)
-b/height * dbdt
````


````
-0.7071067811865475
````





* What happens to the rate as $b$ goes to $l$?

As $b$ goes to $l$, $h$ goes to 0, so $b/h$ blows up. Unless $db/dt$
goes to $0$, the expression will become $-\infty$.



##### Example

````
CalculusWithJulia.WeaveSupport.ImageFile("/var/folders/k0/94d1r7xd2xlcw_jkg
qq4h57w0000gr/T/jl_4cf18o.gif", L"
The flight of the ball as being tracked by a stationary outfielder.  This b
all will go over the head of the player. What can the player tell from the 
quantity $d\theta/dt$?

")
````






A baseball player stands 100 meters from home base. A batter hits the
ball directly at the player so that the distance from home plate is
$x(t)$ and the height is $y(t)$.

The player tracks the flight of the ball in terms of the angle
$\theta$ made between the ball and the player. This will satisfy:

$$~
\tan(\theta) = \frac{y(t)}{100 - x(t)}.
~$$

What is the rate of change of $\theta$ with respect to $t$ in terms of that of $x$ and $y$?

We have by the chain rule and quotient rule:

$$~
\sec^2(\theta) \theta'(t) = \frac{y'(t) \cdot (100 - x(t)) - y(t) \cdot (-x'(t))}{(100 - x(t))^2}.
~$$

If we have $x(t) = 50t$ and $y(t)=v_{0y} t - 5 t^2$ when is the rate of change of the angle happening most quickly?


The formula for $\theta'(t)$ is

$$~
\theta'(t) = \cos^2(\theta) \cdot \frac{y'(t) \cdot (100 - x(t)) - y(t) \cdot (-x'(t))}{(100 - x(t))^2}.
~$$

This question requires us to differentiate *again* in $t$. Since we
have fairly explicit function for $x$ and $y$, we will use `SymPy` to
do this.

````julia

@vars t
theta = SymFunction("theta")

v0 = 5
x(t) = 50t
y(t) = v0*t - 5 * t^2
eqn = tan(theta(t)) - y(t) / (100 - x(t))
````


````
2      
            - 5⋅t  + 5⋅t
tan(θ(t)) - ────────────
             100 - 50⋅t
````



````julia

thetap = diff(theta(t),t)
dtheta = solve(diff(eqn, t), thetap)[1]
````


````
⎛   3      2              2                2⎞    2      
⎝- t  + 3⋅t  + 2⋅t⋅(t - 2)  - 2⋅t - (t - 2) ⎠⋅cos (θ(t))
────────────────────────────────────────────────────────
                                3                       
                      10⋅(t - 2)
````





We could proceed directly by evaluating:

````julia

d2theta = diff(dtheta, t)(thetap => dtheta)
````


````
⎛     2                                  2    ⎞    2           ⎛   3      2
   
⎝- 3⋅t  + 2⋅t⋅(2⋅t - 4) + 4⋅t + 2⋅(t - 2)  + 2⎠⋅cos (θ(t))   3⋅⎝- t  + 3⋅t 
 + 
────────────────────────────────────────────────────────── - ──────────────
───
                                 3                                         
   
                       10⋅(t - 2)                                          
   

                                                                           
   
           2                2⎞    2         ⎛   3      2              2    
   
2⋅t⋅(t - 2)  - 2⋅t - (t - 2) ⎠⋅cos (θ(t))   ⎝- t  + 3⋅t  + 2⋅t⋅(t - 2)  - 2
⋅t 
───────────────────────────────────────── - ───────────────────────────────
───
                4                                                          
   
      10⋅(t - 2)                                                        50⋅
(t 

           2                     
         2⎞               3      
- (t - 2) ⎠ ⋅sin(θ(t))⋅cos (θ(t))
─────────────────────────────────
    6                            
- 2)
````





That is not so tractable, however.

It helps to simplify
$\cos^2(\theta(t))$ using basic right-triangle trigonometry. Recall, $\theta$ comes from a right triangle with
height $y(t)$ and length $(100 - x(t))$. The cosine of this angle will
be $100 - x(t)$ divided by the length of the hypotenuse. So we can
substitute:

````julia

dtheta = dtheta(cos(theta(t))^2 => (100 -x(t))^2/(y(t)^2 + (100-x(t))^2))
````


````
2 ⎛   3      2              2                2⎞
(100 - 50⋅t) ⋅⎝- t  + 3⋅t  + 2⋅t⋅(t - 2)  - 2⋅t - (t - 2) ⎠
───────────────────────────────────────────────────────────
                   ⎛                              2⎞       
                 3 ⎜            2   ⎛     2      ⎞ ⎟       
       10⋅(t - 2) ⋅⎝(100 - 50⋅t)  + ⎝- 5⋅t  + 5⋅t⎠ ⎠
````






Plotting reveals some interesting things. For $v_{0y} < 10$ we have graphs that look like:

````julia

plot(dtheta, 0, v0/5)
````


````
Plot{Plots.PlotlyBackend() n=1}
````





The ball will drop in front of the player, and the change in $d\theta/dt$ is monotonic.



But let's rerun the code with $v_{0y} > 10$:

````julia

v0 = 15
x(t) = 50t
y(t) = v0*t - 5 * t^2
eqn = tan(theta(t)) - y(t) / (100 - x(t))
thetap = diff(theta(t),t)
dtheta = solve(diff(eqn, t), thetap)[1]
dtheta = subs(dtheta, cos(theta(t))^2, (100 - x(t))^2/(y(t)^2 + (100 - x(t))^2))
plot(dtheta, 0, v0/5)
````


````
Plot{Plots.PlotlyBackend() n=1}
````






In the second case we have a different shape. The graph is not
monotonic, and before the peak there is an inflection point.  Without
thinking too hard, we can see that the greatest change in the angle is
when it is just above the head ($t=2$ has $x(t)=100$).

That these two graphs differ so, means that the player may be able to
read if the ball is going to go over his or her head by paying
attention to the how the ball is being tracked.

##### Example

Hipster pour-over coffee is made with a conical coffee filter. The
cone is actually a [frustum](http://en.wikipedia.org/wiki/Frustum) of
a cone with small diameter, say $r_0$ chopped off. We will parameterize
our cone by a value $h \geq 0$ on the $y$ axis and an angle $\theta$
formed by a side and the $y$ axis. Then the coffee filter is the part
of the cone between some $h_0$ (related  $r_0=h_0 \tan(\theta)$) and $h$.

The volume of a cone of height $h$ is $V(h) = \pi/3 h \cdot
R^2$. From the geometry, $R = h\tan(\theta)$. The volume of the
filter then is:

$$~
V = V(h) - V(h_0).
~$$

What is $dV/dh$ in terms of $dR/dh$?

Differentiating implicitly gives:


$$~
\frac{dV}{dh} = \frac{\pi}{3} ( R(h)^2 + h \cdot 2 R \frac{dR}{dh}).
~$$

We see that it depends on $R$ and the change in $R$ with respect to $h$. However, we visualize $h$ - the height - so it is better to re-express. Clearly, $dR/dh = \tan\theta$ and using $R(h) = h \tan(\theta)$ we get:

$$~
\frac{dV}{dh} = \pi h^2 \tan^2(\theta).
~$$

The rate of change goes down as $h$ gets smaller ($h \geq h_0$) and gets bigger for bigger $\theta$.

How do the quantities vary in time?

For an incompressible fluid, by balancing the volume leaving with how
it leaves we will have $dh/dt$ is the ratio of the cross-sectional
area at bottom over that at the height of the fluid $(\pi \cdot (h_0\tan(\theta))^2) /
(\pi \cdot ((h\tan\theta))^2)$ times the outward velocity of the fluid.

That is $dh/dt = (h_0/h)^2 \cdot v$. Which makes sense - larger openings
($h_0$) mean more fluid lost per unit time so the height change
follows, higher levels ($h$) means the change in height is slower, as
the cross-sections have more volume.


By [Torricelli's](http://en.wikipedia.org/wiki/Torricelli's_law) law,
the out velocity follows the law $v = \sqrt{2g(h-h_0)}$. This gives:

$$~
\frac{dh}{dt} = \frac{h_0^2}{h^2} \cdot v = \frac{h_0^2}{h^2} \sqrt{2g(h-h_0)}.
~$$

If $h >> h_0$, then $\sqrt{h-h_0} = \sqrt{h}\sqrt(1 - h_0/h) \approx \sqrt{h}(1 - (1/2)(h_0/h)) \approx \sqrt{h}$. So the rate of change of height in time is like $1/h^{3/2}$.


Now, by the chain rule, we have then the rate of change of volume with respect to time, $dV/dt$, is:

$$~
\frac{dV}{dt} =
\frac{dV}{dh} \cdot \frac{dh}{dt} =
\pi h^2 \tan^2(\theta) \cdot \frac{h_0^2}{h^2} \sqrt{2g(h-h_0)} =
\pi \sqrt{2g} \cdot (r_0)^2 \cdot \sqrt{h-h_0}
\approx \pi \sqrt{2g} \cdot r_0^2 \cdot \sqrt{h}
~$$



This rate depends on the square of the size of the
opening ($r_0^2$) and the square root of the height ($h$), but not the
angle of the cone.

## Questions

###### Question

Supply and demand. Suppose demand for product $XYZ$ is $d(x)$ and supply
is $s(x)$. The excess demand is $d(x) - s(x)$. Suppose this is positive. How does this influence
price? Guess the "law" of economics that applies:

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"The rate of change o
f price will be $0$", "The rate of change of price will increase", "The rat
e of change of price will be positive and will depend on the rate of change
 of excess demand."], 3, "", nothing, [1, 2, 3], AbstractString[L"The rate 
of change of price will be $0$", "The rate of change of price will increase
", "The rate of change of price will be positive and will depend on the rat
e of change of excess demand."], "", false)
````





###### Question

Which makes more sense from an economic viewpoint?

````
CalculusWithJulia.WeaveSupport.Radioq(["If the rate of change of unemployme
nt is negative, the rate of change of wages will be negative.", "If the rat
e of change of unemployment is negative, the rate of change of wages will b
e positive."], 2, "", nothing, [1, 2], ["If the rate of change of unemploym
ent is negative, the rate of change of wages will be negative.", "If the ra
te of change of unemployment is negative, the rate of change of wages will 
be positive."], "", false)
````







###### Question

In chemistry there is a fundamental relationship between pressure
($P$), temperature ($T)$ and volume ($V$) given by $PV=cT$ where $c$
is a constant. Which of the following would be true with respect to time?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"The rate of change o
f pressure is always increasing by $c$", "If volume is constant, the rate o
f change of pressure is proportional to the temperature", "If volume is con
stant, the rate of change of pressure is proportional to the rate of change
 of temperature", "If pressure is held constant, the rate of change of pres
sure is proportional to the rate of change of temperature"], 3, "", nothing
, [1, 2, 3, 4], AbstractString[L"The rate of change of pressure is always i
ncreasing by $c$", "If volume is constant, the rate of change of pressure i
s proportional to the temperature", "If volume is constant, the rate of cha
nge of pressure is proportional to the rate of change of temperature", "If 
pressure is held constant, the rate of change of pressure is proportional t
o the rate of change of temperature"], "", false)
````





###### Question

A pebble is thrown into a lake causing ripples to form expanding
circles. Suppose one of the circles expands at a rate of 1 foot per second and
the radius of the circle is 10 feet, what is the rate of change of
the area enclosed by the circle?

````
CalculusWithJulia.WeaveSupport.Numericq(62.83185307179586, 0.001, "", "[62.
83085, 62.83285]", 62.830853071795865, 62.83285307179586, L"feet$^2$/second
", "")
````





###### Question

A pizza maker tosses some dough in the air. The dough is formed in a
circle with radius 10. As it rotates, its area increases at a rate of
1 inch$^2$ per second. What is the rate of change of the radius?

````
CalculusWithJulia.WeaveSupport.Numericq(0.015915494309189534, 0.001, "", "[
0.01492, 0.01692]", 0.014915494309189533, 0.016915494309189535, "inches/sec
ond", "")
````





###### Question


An FBI agent with a powerful spyglass is located in a boat anchored
400 meters offshore.  A gangster under surveillance is driving along
the shore. Assume the shoreline is straight and that the gangster is 1
km from the point on the shore nearest to the boat.  If the spyglasses
must rotate at a rate of $\pi/4$ radians per minute to track
the gangster, how fast is the gangster moving? (In kilometers per minute.)
[Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html)


````
CalculusWithJulia.WeaveSupport.Numericq(2.2776546738526, 0.001, "", "[2.276
65, 2.27865]", 2.2766546738526, 2.2786546738526, "kilometers/minute", "")
````






###### Question

A flood lamp is installed on the ground 200 feet from a vertical
wall. A six foot tall man is walking towards the wall at the rate of
4 feet per second. How fast is the tip of his shadow moving down the
wall when he is 50 feet from the wall?
[Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html)
(As the question is written the answer should be positive.)

````
CalculusWithJulia.WeaveSupport.Numericq(0.21333333333333335, 0.001, "", "[0
.21233, 0.21433]", 0.21233333333333335, 0.21433333333333335, "feet/second",
 "")
````






###### Question


Consider the hyperbola $y = 1/x$ and think of it as a slide. A
particle slides along the hyperbola so that its x-coordinate is
increasing at a rate of $f(x)$ units/sec. If its $y$-coordinate is
decreasing at a constant rate of $1$ unit/sec, what is $f(x)$?
[Source.](http://oregonstate.edu/instruct/mth251/cq/Stage9/Practice/ratesProblems.html)

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$f(x) = x$
", L"$f(x) = x^0$", L"$f(x) = x^2$", L"$f(x) = 1/x$"], 3, "", nothing, [1, 
2, 3, 4], LaTeXStrings.LaTeXString[L"$f(x) = x$", L"$f(x) = x^0$", L"$f(x) 
= x^2$", L"$f(x) = 1/x$"], "", false)
````





###### Question

A balloon is in the shape of a sphere. Fortunately, as this gives
$V=4/3 \pi r^3$ for the volume. If it is being filled with a rate of
change of volume per unit time is $2$ and the radius is $3$, what is
rate of change of radius per unit time?

````
CalculusWithJulia.WeaveSupport.Numericq(0.01768388256576615, 0.001, "", "[0
.01668, 0.01868]", 0.01668388256576615, 0.01868388256576615, "units per uni
t time", "")
````





###### Question

Consider the curve $f(x) = x^2 - \log(x)$. For a given $x$, the tangent line intersects the $y$ axis. Where?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$y = 1 - x
^2$", L"$y = 1 - \log(x)$", L"$y = 1 - x^2 - \log(x)$", L"$y = x(2x - 1/x)$
"], 3, "", nothing, [1, 2, 3, 4], LaTeXStrings.LaTeXString[L"$y = 1 - x^2$"
, L"$y = 1 - \log(x)$", L"$y = 1 - x^2 - \log(x)$", L"$y = x(2x - 1/x)$"], 
"", false)
````





If $dx/dt = -1$, what is $dy/dt$?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$dy/dt = 2
x + 1/x$", L"$dy/dt = 1 - x^2 - \log(x)$", L"$dy/dt = -2x - 1/x$", L"$dy/dt
 = 1$"], 1, "", nothing, [1, 2, 3, 4], LaTeXStrings.LaTeXString[L"$dy/dt = 
2x + 1/x$", L"$dy/dt = 1 - x^2 - \log(x)$", L"$dy/dt = -2x - 1/x$", L"$dy/d
t = 1$"], "", false)
````


