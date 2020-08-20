# Partial Fractions





Integration is facilitated when an antiderivative for $f$ can be found, as then definite integrals can be evaluated through the fundamental theorem of calculus.

However, despite integration being an algorithmic procedure,
integration is not. There are "tricks" to try, such as substitution
and integration by parts. These work in some cases. However, there are
classes of functions for which algorithms exist. For example, the
`SymPy` `integrate` function implements an algorithm that decides if
an elementary function has an antiderivative. The
[elementary](http://en.wikipedia.org/wiki/Elementary_function)
functions include exponentials, their inverses (logarithms),
trigonometric functions, their inverses, and powers, including $n$th
roots. Not every elementary function will have an antiderivative
comprised of (finite) combinations of elementary functions. The
typical example is $e^{x^2}$, which has no simple antiderivative,
despite its ubiquitousness.

There are classes of functions where an (elementary) antiderivative can always be
found. Polynomials provide a case. More surprisingly, so do their
ratios, *rational functions*.

## Partial fraction decomposition

Let $f(x) = p(x)/q(x)$, where  $p$ and $q$ are polynomial
functions. Further, we assume without comment that $p$ and $q$ have no common
factors. (If they did, we can divide them out, an act which has no
effect on the integrability of $f(x)$.


The function $q(x)$ will factor over the real numbers. The fundamental
theorem of algebra can be applied to say that $q(x)=q_1(x)^{n_1}
\cdots q_k(x)^{n_k}$ where $q_i(x)$ is a linear or quadratic
polynomial and $n_k$ a positive integer.


> **Partial Fraction Decomposition**: There are unique polynomials $a_{ij}$ with degree $a_{ij} <$
> degree $q_i$ such that
> $$~
> \frac{p(x)}{q(x)} = a(x) + \sum_{i=1}^k \sum_{j=1}^{n_i} \frac{a_{ij}(x)}{q_i(x)^j}.
> ~$$

The method is attributed to John Bernoulli, one of the prolific
Bernoulli brothers who put a stamp on several areas of math. This
Bernoulli was a mentor to Euler.

This basically says that each factor $q_i(x)^{n_i}$ contributes a term like:

$$~
\frac{a_{i1}}{q_i(x)^1} + \frac{a_{i2}}{q_i(x)^2} + \cdots + \frac{a_{in_i}}{q_i(x)^{n_i}},
~$$

where each $a_{ij}$ has degree less than the degree of $q_i$.

The value of this decomposition is that the terms $a_{ij}(x)/q_i(x)^j$
each have an antiderivative, and so the sum of them will also have an
antiderivative.

````
CalculusWithJulia.WeaveSupport.Alert("\nMany calculus texts will give some 
examples for finding a partial\nfraction decomposition. We push that work o
ff to `SymPy`, as for all\nbut the easiest cases - a few are in the problem
s - it can be a bit tedious.\n\n", Dict{Any,Any}(:class => "info"))
````





In `SymPy`, the `apart` function will find the partial fraction
decomposition. For example, here we see $n_i$ terms for each power of
$q_i$

````julia

using CalculusWithJulia  # loads `SymPy`
@vars a b c A B x real=true
````


````
(a, b, c, A, B, x)
````



````julia

apart((x-2)*(x-3) / (x*(x-1)^2*(x^2 + 2)^3))
````


````
8⋅x - 13     35⋅x - 34      45⋅x - 28         1            2         3 
- ─────────── - ──────────── - ──────────── - ───────── + ─────────── + ───
            3              2       ⎛ 2    ⎞   3⋅(x - 1)             2   4⋅x
    ⎛ 2    ⎞       ⎛ 2    ⎞    108⋅⎝x  + 2⎠               27⋅(x - 1)       
  9⋅⎝x  + 2⎠    54⋅⎝x  + 2⎠
````






### Sketch of proof

A standard proof uses two facts of number systems: the division
algorithm and a representation of the greatest common divisor in terms
of sum, extended to polynomials. Our sketch shows how these are used.

Take one of the factors of the denominators, and consider this
representation of the rational function $P(x)/(q(x)^k Q(x))$ where
there are no common factors to any of the three polynomials.

Since $q(x)$ and $Q(x)$ share no factors,
[Bezout's](http://tinyurl.com/kd6prns)
identity says there exists polynomials $a(x)$ and $b(x)$  with:

$$~
a(x) Q(x) + b(x) q(x) = 1.
~$$


Then dividing by $q^k(x)Q(x)$ gives the decomposition

$$~
\frac{1}{q(x)^k Q(x)} = \frac{a(x)}{q(x)^k} + \frac{b(x)}{q(x)^{k-1}Q(x)}.
~$$

So we get by multiplying the $P(x)$:

$$~
\frac{P(x)}{q(x)^k Q(x)} = \frac{A(x)}{q(x)^k} + \frac{B(x)}{q(x)^{k-1}Q(x)}.
~$$

This may look more complicated, but what it does is peel off one term
(The first) and leave something which is smaller, in this case by a
factor of $q(x)$. This process can be repeated pulling off a power of a factor at a time until nothing is left to do.


What remains is to establish that we can take $A(x) = a(x)\cdot P(x)$ with a degree less than that of $q(x)$.

In Proposition 3.8 of
[Bradley](http://www.m-hikari.com/imf/imf-2012/29-32-2012/cookIMF29-32-2012.pdf)
and Cook it is shown how an expression of the form $A(x)/a(x)^k$ can
be written as $q_1(x) + r_k(x)/a(x)^k + \cdots + r_2(x)/a(x)^2 +
r_1(x)/a(x)$ with the degree of each $r_i(x)$ less than that of $a(x)$
by repeated application of the division algorithm. This fact can be used to
finish the proof.

To generate the $r_1$, $r_2$, $\dots$, $r_k$, the division
algorithm is applied $k$ times giving: $A=aq_k + r_k$, $q_k = a q_{k-1} +
r_{k-1}$, $\dots$, $q_2 = a q_1 + r_1$. These are put together to show
$A/a^k=q_1 + r_k/a^k + r_{k-1}/a^{k-1} + \cdots + r_2/a^2 + r_1/a$.



## Integrating the terms in a partial fraction decomposition

We discuss by example how each type of possible terms in a partial
fraction decomposition has an antiderivative. Hence, rational
functions will *always* have an antiderivative that can be computed.

### Linear factors

For $j=1$, if $q_i$ is linear, then $a_{ij}/q_i^j$ must look like a constant over a linear term, or something like:

````julia

p = a/(x-c)
````


````
a   
──────
-c + x
````





This has a logarithmic antiderivative:

````julia

integrate(p, x)
````


````
a⋅log(-c + x)
````






For $j > 1$, we have powers.

````julia

@vars j positive=true
integrate(a/(x-c)^j, x)
````


````
⎛⎧        1 - j           ⎞
  ⎜⎪(-c + x)                ⎟
  ⎜⎪─────────────  for j ≠ 1⎟
a⋅⎜⎨    1 - j               ⎟
  ⎜⎪                        ⎟
  ⎜⎪ log(-c + x)   otherwise⎟
  ⎝⎩                        ⎠
````






### Quadratic factors

When $q_i$ is quadratic, it looks like $ax^2 + bx + c$. Then $a_{ij}$
can be a constant or a linear polynomial. The latter can be written as
$Ax + B$.


Rather than try to consider the general case of

$$~
\frac{Ax +B }{(ax^2  + bx + c)^j},
~$$

which can be handled, it is best to shift the value of $x$ so that this is no more than a constant times:

$$~
\frac{Ax + B}{((ax)^2 \pm 1)^j}
~$$

This can be done by finding a $d$ so that $a(x-d)^2 + b(x-d) + c = dx^2 + e = e((\sqrt{d/e}x^2 \pm 1)$.

The integrals of the type $Ax/((ax)^2 \pm 1)$ can completed by $u$-substitution, with $u=(ax)^2 \pm 1$.

For example,

````julia

integrate(A*x/((a*x)^2 + 1)^4, x)
````


````
-A                  
────────────────────────────────────
   8  6       6  4       4  2      2
6⋅a ⋅x  + 18⋅a ⋅x  + 18⋅a ⋅x  + 6⋅a
````





The integrals of the type $B/((ax)^2\pm 1)$ are completed by
trigonometric substitution and various reduction formulas. They can get involved, but are tractable. For
example:


````julia

integrate(B/((a*x)^2 + 1)^4, x)
````


````
⎛          4  5       2  3                          ⎞
  ⎜      15⋅a ⋅x  + 40⋅a ⋅x  + 33⋅x        5⋅atan(a⋅x)⎟
B⋅⎜───────────────────────────────────── + ───────────⎟
  ⎜    6  6        4  4        2  2            16⋅a   ⎟
  ⎝48⋅a ⋅x  + 144⋅a ⋅x  + 144⋅a ⋅x  + 48              ⎠
````




and

````julia

integrate(B/((a*x)^2 - 1)^4, x)
````


````
⎛                                               ⎛    1⎞        ⎛    1⎞⎞
  ⎜            4  5       2  3               5⋅log⎜x - ─⎟   5⋅log⎜x + ─⎟⎟
  ⎜        15⋅a ⋅x  - 40⋅a ⋅x  + 33⋅x             ⎝    a⎠        ⎝    a⎠⎟
B⋅⎜- ───────────────────────────────────── - ──────────── + ────────────⎟
  ⎜      6  6        4  4        2  2            32⋅a           32⋅a    ⎟
  ⎝  48⋅a ⋅x  - 144⋅a ⋅x  + 144⋅a ⋅x  - 48                              ⎠
````





## Examples

Find an antiderivative for $1/(x\cdot(x^2+1)^2)$.

We have a partial fraction decomposition is:

````julia

q = (x * (x^2 + 1)^2)
apart(1/q)
````


````
x          x       1
- ────── - ───────── + ─
   2               2   x
  x  + 1   ⎛ 2    ⎞     
           ⎝x  + 1⎠
````





We see three terms. The first and second will be done by $u$-substitution, the third by a logarithm:

````julia

integrate(1/q, x)
````


````
⎛ 2    ⎞           
         log⎝x  + 1⎠      1    
log(x) - ─────────── + ────────
              2           2    
                       2⋅x  + 2
````





----

Find an antiderivative of $1/(x^2 - 2x-3)$.

We again just let `SymPy` do the work. A partial fraction decomposition is given by:

````julia

q =  (x^2 - 2x - 3)
apart(1/q)
````


````
1           1    
- ───────── + ─────────
  4⋅(x + 1)   4⋅(x - 3)
````





We see what should yield two logarithmic terms:

````julia

integrate(1/q, x)
````


````
log(x - 3)   log(x + 1)
────────── - ──────────
    4            4
````



````
CalculusWithJulia.WeaveSupport.Alert(L"
`SymPy` will find $\log(x)$ as an antiderivative for $1/x$, but more
generally, $\log(\lvert x\rvert)$ is one.

", Dict{Any,Any}(:class => "info"))
````





## Questions

###### Question

The partial fraction decomposition of $1/(x(x-1))$ must be of the form $A/x + B/(x-1)$.

What is $A$? (Use `SymPy` or just put the sum over a common denominator and solve for $A$ and $B$.)

````
CalculusWithJulia.WeaveSupport.Numericq(-1, 0, "", "[-1.0, -1.0]", -1, -1, 
"", "")
````





What is $B$?

````
CalculusWithJulia.WeaveSupport.Numericq(1, 0, "", "[1.0, 1.0]", 1, 1, "", "
")
````





###### Question

The following gives the partial fraction decomposition for a rational expression:

$$~
\frac{3x+5}{(1-2x)^2} = \frac{A}{1-2x} + \frac{B}{(1-2x)^2}.
~$$

Find $A$ (being careful with the sign):

````
CalculusWithJulia.WeaveSupport.Numericq(-1.5, 0.001, "", "[-1.501, -1.499]"
, -1.501, -1.499, "", "")
````





Find $B$:

````
CalculusWithJulia.WeaveSupport.Numericq(6.5, 0.001, "", "[6.499, 6.501]", 6
.499, 6.501, "", "")
````





###### Question

The following specifies the general partial fraction decomposition for a rational expression:

$$~
\frac{1}{(x+1)(x-1)^2} = \frac{A}{x+1} + \frac{B}{x-1} + \frac{C}{(x-1)^2}.
~$$

Find $A$:

````
CalculusWithJulia.WeaveSupport.Numericq(0.25, 0.001, "", "[0.249, 0.251]", 
0.249, 0.251, "", "")
````





Find $B$:

````
CalculusWithJulia.WeaveSupport.Numericq(-0.25, 0.001, "", "[-0.251, -0.249]
", -0.251, -0.249, "", "")
````





Find $C$:

````
CalculusWithJulia.WeaveSupport.Numericq(0.5, 0.001, "", "[0.499, 0.501]", 0
.499, 0.501, "", "")
````






###### Question

Compute the following exactly:

$$~
\int_0^1 \frac{(x-2)(x-3)}{(x-4)^2\cdot(x-5)} dx
~$$

Is $-6\log(5) - 5\log(3) - 1/6 + 11\log(4)$ the answer?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````





###### Question

In the assumptions for the partial fraction decomposition is the fact that $p(x)$ and $q(x)$ share no common factors. Suppose, this isn't the case and in fact we have:

$$~
\frac{p(x)}{q(x)} = \frac{(x-c)^m s(x)}{(x-c)^n t(x)}.
~$$

Here $s$ and $t$ are polynomials such that $s(c)$ and $t(c)$ are non-zero.

If $m > n$, then why can we cancel out the $(x-c)^n$ and not have a concern?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString["`SymPy` allows it.", 
L"The value $c$ is a removable singularity, so the integral will be identic
al.", L"The resulting function has an identical domain and is equivalent fo
r all $x$."], 2, "", nothing, [1, 2, 3], AbstractString["`SymPy` allows it.
", L"The value $c$ is a removable singularity, so the integral will be iden
tical.", L"The resulting function has an identical domain and is equivalent
 for all $x$."], "", false)
````






If $m = n$, then why can we cancel out the $(x-c)^n$ and not have a concern?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString["`SymPy` allows it.", 
L"The value $c$ is a removable singularity, so the integral will be identic
al.", L"The resulting function has an identical domain and is equivalent fo
r all $x$."], 2, "", nothing, [1, 2, 3], AbstractString["`SymPy` allows it.
", L"The value $c$ is a removable singularity, so the integral will be iden
tical.", L"The resulting function has an identical domain and is equivalent
 for all $x$."], "", false)
````






If $m < n$, then why can we cancel out the $(x-c)^n$ and not have a concern?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString["`SymPy` allows it.", 
L"The value $c$ is a removable singularity, so the integral will be identic
al.", L"The resulting function has an identical domain and is equivalent fo
r all $x$."], 3, "", nothing, [1, 2, 3], AbstractString["`SymPy` allows it.
", L"The value $c$ is a removable singularity, so the integral will be iden
tical.", L"The resulting function has an identical domain and is equivalent
 for all $x$."], "", false)
````


