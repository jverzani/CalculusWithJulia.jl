# Vectors and matrices






In [vectors](../precalc/vectors.html) we introduced the concept of a vector.
A [vector](https://en.wikipedia.org/wiki/Euclidean_vector) mathematically is a geometric object with two attributes a magnitude and a direction. (The direction is undefined in the case the magnitude is $0$.) Vectors are typically visualized with an arrow, where the anchoring of the arrow is context dependent and is not particular to a given vector.

Vectors and points are related, but distinct. Let's focus on 3 dimensions. Mathematically, the notation for a point is $p=(x,y,z)$ while the notation for a vector is $\vec{v} = \langle x, y, z \rangle$. The $i$th component in a vector is referenced by a subscript: $v_i$. With this, we may write a typical vector as $\vec{v} = \langle v_1, v_2, \dots, v_n \rangle$ and a vector in $n=3$ as $\vec{v} =\langle v_1, v_2, v_3 \rangle$.
The different grouping notation distinguishes the two objects. As another example, the notation $\{x, y, z\}$ indicates a set. Vectors and points may be *identified* by anchoring the vector at the origin. Set's are quite different from both, as the order of their entries is not unique.




In `Julia`, the notation to define a point and a vector would be identical, using square brackets to group like-type values: `[x, y, z]`. The notation `(x,y,z)` would form a [tuple](https://en.wikipedia.org/wiki/Euclidean_vector) which though similar in many respects, tuples do not have the operations associated with a point or a vector defined for them.

The square bracket constructor has some subtleties:

* `[x,y,z]` calls `vect` and creates a 1-dimensional array
* `[x; y; z]` calls `vcat` to **v**ertically con**cat**enate values together. With simple numbers the two are identical, but not in other cases. (For example, is `A` is a matrix then `[A,A]` is a vector of matrices, `[A;A]` is a matrix combined from the two pieces.
* `[x y z]`	 calls `hcat` to **h**orizontally con**cat**enate values together. If `x`, `y` are numbers then `[x y]` is *not* a vector, but rather a 2D array with a single row and two columns.
* finally `[w x; y z]` calls `hvcat` to horizontally and vertically concatenate values together to create a container in two dimensions, like a matrix.

(A vector, mathematically, is a one-dimensional collection of numbers, a matrix a two-dimensional *rectangular* collection of numbers, and an array an $n$-dimensional rectangular-like collection of numbers. In `Julia`, a vector can hold a collection of objects of arbitrary type, though generally all of the same type.)


## Vector addition, scalar multiplication

As seen earlier, vectors have some arithmetic operations defined for them. As a typical use of vectors, mathematically, is to collect the $x$, $y$, and  $z$ (in 3D) components together, operations like addition and subtraction operate component wise. With this, addition can be visualized geometrically: put the tail of $\vec{v}$ at the tip of $\vec{u}$ and draw a vector from the tail of $\vec{u}$ to the tip of $\vec{v}$ and you have $\vec{u}+\vec{v}$. This is identical by $\vec{v} + \vec{u}$ as vector addition is commutative. Unless $\vec{u}$ and $\vec{v}$ are parallel or one has $0$ length, the addition will create a vector with a different direction from the two.

Another operation for vectors is *scalar* multiplication. Geometrically this changes the magnitude, but not the direction of a vector, when the *scalar* is positive. Scalar multiplication is defined component wise, like addition so the $i$th component of $c \vec{v}$ is $c$ times the $i$th component of $\vec{v}$. When the scalar is negative, the direction is "reversed."

To illustrate we first load our package and define two 3D vectors:

````julia

using CalculusWithJulia
u, v = [1, 2, 3], [4, 3, 2]
````


````
([1, 2, 3], [4, 3, 2])
````





The sum is component-wise summation (`1+4, 2+3, 3+2`):

````julia

u + v
````


````
3-element Array{Int64,1}:
 5
 5
 5
````





For addition, as the components must pair off, the two vectors being added must be the same dimension.

Scalar multiplication by `2`, say, multiplies each entry by `2`:

````julia

2 * u
````


````
3-element Array{Int64,1}:
 2
 4
 6
````





## The length and direction of a vector


If a vector $\vec{v} = \langle v_1, v_2, \dots, v_n\rangle$ then the *norm* (also Euclidean norm or length) of $\vec{v}$ is defined by:

$$~
\| \vec{v} \| = \sqrt{ v_1^2 + v_2^2 + \cdots + v_n^2}.
~$$


The definition of a norm leads to a few properties. First, if $c$ is a scalar, $\| c\vec{v} \| = |c| \| \vec{v} \|$ - which says scalar multiplication by $c$ changes the length by $|c|$. (Sometimes, scalar multiplication is described as "scaling by....")
The other property is an analog of the triangle inequality, in which for any two vectors $\| \vec{v} + \vec{w} \| \leq \| \vec{v} \| + \| \vec{w} \|$. The right hand side is equal only when the two vectors are parallel and addition is viewed as laying them end to end.


A vector with length $1$ is called a *unit* vector. Dividing a non-zero vector by its norm will yield a unit vector, a consequence of the first property above. Unit vectors are often written with a "hat:" $\hat{v}$.


The direction indicated by $\vec{v}$ can be visualized as an angle in 2 or 3 dimensions, but in higher dimensions, visualization is harder. For 2-dimensions, we might
associate with a vector, it's unit vector. This in turn may be identified with a point on the unit circle, which from basic trigonometry can be associated with an angle. Something similar, can be done in 3 dimensions, using two angles. However, the "direction" of a vector is best thought of in terms of its associated unit vector. With this, we have a decomposition of a vector $\vec{v}$ into a magnitude scalar and a direction when we write $\vec{v} = \|\vec{v}\| \cdot (\vec{v} / \|\vec{v}\|)=\|\vec{v}\| \hat{v}$.


## Visualization of vectors


Vectors may be visualized in 2 or 3 dimensions using `Plots`. In 2 dimensions, the `quiver` function may be used. To graph a vector, it must have its tail placed at a point, so two values are needed.

To plot `u=[1,2]` from `p=[0,0]` we have the following usage:

````julia

using Plots
gr()       # better arrows than plotly()
quiver([0],[0], quiver=([1],[2]))
````


![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/vectors_5_1.png)



The cumbersome syntax is typical here. We naturally describe vectors and points using `[a,b,c]` to combine them, but the plotting functions want to plot many such at a time and expect vectors containing just the `x` values, just the `y` values, etc. The above usage looks a bit odd, as these vectors of `x` and `y` values have only one entry. Converting from the one representation to the other requires reshaping the data, which we will do with the following function from the `CalculusWithJulia` package:

````julia

unzip(vs) = Tuple(eltype(first(vs))[xyz[j] for xyz in vs] for j in eachindex(first(vs)))
````




This takes a vector of vectors, and returns a tuple containing the `x` values, the `y` values, etc. So if `u=[1,2,3]`, the `unzip([u])` becomes `([1],[2],[3])`. And if `v=[4,5,6]`, then `unzip([u,v])` becomes `([1,4],[2,5],[3,6])`, etc. (The `zip` function in base does essentially the reverse operation.)


With `unzip` defined, we can plot a 2-D vector `v` anchored at point `p` through `quiver(unzip([p])..., quiver=unzip([v]))`.

To illustrate, the following defines 3 vectors (the third through addition), then graphs all three, though in different starting points to emphasize the geometric interpretation of vector addition.

````julia

u = [1, 2]
v = [4, 2]
w = u + v
p = [0,0]
quiver(unzip([p])..., quiver=unzip([u]))
quiver!(unzip([u])..., quiver=unzip([v]))
quiver!(unzip([p])..., quiver=unzip([w]))
````


![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/vectors_7_1.png)





Plotting a 3-d vector is not supported in all toolkits with
`quiver`. A line segment may be substituted and can be produced
with `plot(unzip([p,p+v])...)`. To avoid all these details, the `CalculusWithJulia` provides the `arrow!` function to *add* a vector to an existing plot. The function requires a point, `p`, and the vector, `v`:


With this, the above simplifies to:

````julia
plot(legend=false)
arrow!(p, u)
arrow!(u, v)
arrow!(p, w)
````






The distinction between a point and a vector within `Julia` is only mental. We use the same storage type. Mathematically, we can **identify** a point and a vector, by considering the vector with its tail placed at the origin. In this case, the tip of the arrow is located at the point. But this is only an identification, though a useful one. It allows us to "add" a point and a vector (e.g., writing $P + \vec{v}$) by imagining the point as a vector anchored at the origin.



To see that a unit vector has the same "direction" as the vector, we might draw them with different widths:

````julia
using LinearAlgebra
v = [2, 3]
u = v / norm(v)
p = [0, 0]
plot(legend=false)
arrow!(p, v)
arrow!(p, u, linewidth=5)
````






The `norm` function is in the standard library, `LinearAlgebra`, which must be loaded first through the command `using LinearAlgebra`. (Though here it is redundant, as that package is loaded when the `CalculusWithJulia` package is loaded.)

## Aside: review of `Julia`'s use of dots to work with containers

`Julia` makes use of the dot, "`.`", in a few ways to simplify usage when containers, such as vectors, are involved:


* **Splatting**. The use of three dots, "`...`", to "splat" the values from a container like a vector (or tuple) into *arguments* of a function can be very convenient. It was used above in the definition for the `arrow!` function: essentially `quiver!(unzip([p])..., quiver=unzip([v]))`. The `quiver` function expects 2 (or 3) arguments describing the `xs` and `ys` (and sometimes `zs`). The `unzip` function returns these in a container, so splatting is used to turn the values in the container into distinct arguments of the function. Whereas the `quiver` argument expects a tuple of vectors, so no splatting is used for that part of the definition. Another use of splatting we will see is with functions of vectors. These can be defined in terms of the vector's components or the vector as a whole, as below:

````julia

f(x,y,z) = x^2 + y^2 + z^2
f(v) = v[1]^2 + v[2]^2 + v[3]^2
````


````
f (generic function with 2 methods)
````





The first uses the components and is arguably, much easier to read. The second uses indexing in the function body to access the components. Both uses have their merits.
If a function is easier to write in terms of its components, but an interface expects a vector of components as it argument, then splatting can be useful, to go from one style to another, similar to this:

````julia

g(x,y,z) =  x^2 + y^2 + z^2
g(v) = g(v...)
````


````
g (generic function with 2 methods)
````





The splatting will mean `g(v)` eventually calls `g(x,y,z)` through `Julia`'s multiple dispatch machinery when `v = [x,y,z]`.

(The three dots can also appear in the definition of the arguments to a function, but there the usage is not splatting but rather a specification of a variable number of arguments.)

* **Broadcasting**. For a univariate function, `f`, and vector, `xs`, the call `f.(xs)` *broadcasts* `f` over each value of `xs` and returns a container holding all the values. This is a compact alternative to a comprehension when a function is defined. The `map` function is similar. When `f` depends on more than one value, broadcasting can still be used: `f.(xs, ys)` will broadcast `f` over values formed from *both* `xs` and `ys`. The `map` function is similar, but broadcasting has the extra feature of attempting to match up the shapes of `xs` and `ys` when they are not identical. (See the help page for `broadcast` for more details.)

For example, if `xs` is a vector and `ys` a scalar, then the value in `ys` is repeated many times to match up with the values of `xs`. Or if `xs` and `ys` have different dimensions, the values of one will be repeated. Consider this:

````julia

xs = ys = [0, 1]
f(x,y) = x + y
f.(xs, ys)
````


````
2-element Array{Int64,1}:
 0
 2
````





This matches `xs` and `ys` to pass `(0,0)` and then `(1,1)` to `f`, returning `0` and `2`. Now consider

````julia

xs = [0, 1]; ys = [0 1]  # xs is a column vector, ys a row vector
f.(xs, ys)
````


````
2×2 Array{Int64,2}:
 0  1
 1  2
````





The two dimensions are different so for each value of `xs` the vector of `ys` is broadcast. This returns a matrix now.

At times using the "apply" notation: `x |> f`, in place of using `f(x)` is useful, as it can move the wrapping function to the right of the expression. To broadcast,  `.|>` is available.


At times the automatic broadcasting is not as desired. A case involving "pairs" will come up where we want to broadcast the pair as a whole, not the two sides.



## The dot product

There is no concept of multiplying two vectors, or for that matter dividing two vectors. However, there are two operations between vectors that are somewhat similar to multiplication, these being the dot product and the cross product. Each has an algebraic definition, but their geometric properties are what motivate their usage. We begin by discussing the dot product.


The dot product between two vectors can be viewed algebraically in terms of the following product. If $\vec{v} = \langle v_1, v_2, \dots, v_n\rangle$ and $\vec{w} = \langle w_1, w_2, \dots, w_n\rangle$, then the *dot product* of $\vec{v}$ and $\vec{w}$ is defined by:

$$~
\vec{v} \cdot \vec{w} = v_1 w_1 + v_2 w_2 + \cdots + v_n w_n.
~$$

From this, we can see the relationship between the norm, or Euclidean length of a vector: $\vec{v} \cdot \vec{v} = \| \vec{v} \|^2$. We can also see that the dot product is commutative, that is $\vec{v} \cdot \vec{w} = \vec{w} \cdot \vec{v}$.

The dot product has an important geometrical interpolation. Two (non-parallel) vectors will lie in the same "plane", even in higher dimensions. Within this plane, there will be an angle between them within $[0, \pi]$. Call this angle $\theta$. (This means the angle between the two vectors is the same regardless of their order of consideration.) Then

$$~
\vec{v} \cdot \vec{w} = \|\vec{v}\| \|\vec{w}\| \cos(\theta).
~$$

If we denoted $\hat{v} = \vec{v} / \| \vec{v} \|$, the unit vector in the direction of $\vec{v}$, then by dividing, we see that
$\cos(\theta) = \hat{v} \cdot \hat{w}$. That is the angle does not depend on the magnitude of the vectors involved.

The dot product is computed in `Julia` by the `dot` function, which is in the `LinearAlgebra` package of the standard library. This must be loaded (as above) before its use either directly or through the `CalculusWithJulia` package:

````julia

u = [1, 2]
v = [2, 1]
dot(u, v)
````


````
4
````





!!! note

    In `Julia`, the unicode operator entered by `\cdot[tab]` can also be used to mirror the math notation:

````julia

u ⋅ v   # u \cdot[tab] v
````


````
4
````






Continuing, to find the angle between $\vec{u}$ and $\vec{v}$, we might do this:

````julia

ctheta = dot(u/norm(u), v/norm(v))
acos(ctheta)
````


````
0.6435011087932845
````






The cosine of $\pi/2$ is $0$, so two vectors which are at right angles to each other will have a dot product of  $0$:

````julia

u = [1, 2]
v = [2, -1]
u ⋅ v
````


````
0
````





In two dimensions, we learn that a perpendicular line to a line with slope $m$ will have slope $-1/m$. From a 2-dimensional vector, say $\vec{u} = \langle u_1, u_2 \rangle$ the slope is $u_2/u_1$ so a perpendicular vector to $\vec{u}$ will be $\langle u_2, -u_1 \rangle$, as above. For higher dimensions, where the angle is harder to visualize, the dot product defines perpendicularness, or *orthogonality*.

For example, these two vectors are orthogonal, as their dot product is $0$, even though we can't readily visualize them:

````julia

u = [1, 2, 3, 4, 5]
v = [-30, 4, 3, 2, 1]
u ⋅ v
````


````
0
````






#### Projection

From right triangle trigonometry, we learn that $\cos(\theta) = \text{adjacent}/\text{hypotenuse}$. If we use a vector, $\vec{h}$ for the hypotenuse, and $\vec{a} = \langle 1, 0 \rangle$, we have this picture:

````julia
h = [2, 3]
a = [1, 0]  # unit vector
h_hat = h / norm(h)
theta = acos(h_hat ⋅ a)

plot(legend=false)
arrow!([0,0], h)
arrow!([0,0], norm(h) * cos(theta) * a)
arrow!([0,0], a, linewidth=3)
````





We used vectors to find the angle made by `h`, and from there, using the length of the hypotenuse is `norm(h)`, we can identify the length of the adjacent side, it being the length of the hypotenuse times the cosine of $\theta$. Geometrically, we call the vector `norm(h) * cos(theta) * a` the *projection* of $\vec{h}$ onto $\vec{a}$, the word coming from the shadow $\vec{h}$ would cast on the direction of $\vec{a}$ were there light coming perpendicular to $\vec{a}$.

The projection can be made for any pair of vectors, and in any dimension $n > 1$. The projection of $\vec{u}$ on $\vec{v}$ would be a vector of length $\vec{u}$ (the hypotenuse) times the cosine of the angle in the direction of $\vec{v}$. In dot-product notation:

$$~
proj_{\vec{v}}(\vec{u}) = \| \vec{u} \| \frac{\vec{u}\cdot\vec{v}}{\|\vec{u}\|\|\vec{v}\|} \frac{\vec{v}}{\|\vec{v}\|}.
~$$

This can simplify. After cancelling, and expressing norms in terms of dot products, we have:

$$~
proj_{\vec{v}}(\vec{u}) = \frac{\vec{u} \cdot \vec{v}}{\vec{v} \cdot \vec{v}} \vec{v} = (\vec{u} \cdot \hat{v}) \hat{v},
~$$

where $\hat{v}$ is the unit vector in the direction of $\vec{v}$.


##### Example

A pendulum, a bob on a string, swings back and forth due to the force of gravity. When the bob is displaced from rest by an angle $\theta$, then the tension force of the string on the bob is directed along the string and has magnitude given by the *projection* of the force due to gravity.


A [force diagram](https://en.wikipedia.org/wiki/Free_body_diagram) is a useful visualization device of physics to illustrate the applied forces involved in a scenario. In this case the bob has two forces acting on it: a force due to tension in the string of unknown magnitude, but in the direction of the string; and a force due to gravity. The latter is in the downward direction and has magnitude $mg$, $g=9.8m/sec^2$ being the gravitational constant.

````julia

theta = pi/12
mass, gravity = 1/9.8, 9.8

l = [-sin(theta), cos(theta)]
p = -l
Fg = [0, -mass*gravity]
plot(legend=false)
arrow!(p, l)
arrow!(p, Fg)
scatter!(p[1:1], p[2:2], markersize=5)
````


![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/vectors_20_1.png)



The magnitude of the tension force is exactly that of the force of gravity projected onto $\vec{l}$, as the bob is not accelerating in that direction. The component of the gravity force in the perpendicular direction is the part of the gravitational force that causes acceleration in the pendulum. Here we find the projection onto $\vec{l}$ and visualize the two components of the gravitational force.

````julia
plot(legend=false, aspect_ratio=:equal)
arrow!(p, l)
arrow!(p, Fg)
scatter!(p[1:1], p[2:2], markersize=5)

proj = (Fg ⋅ l) / (l ⋅ l) * l   # force of gravity in direction of tension
porth = Fg - proj              # force of gravity perpendicular to tension

arrow!(p, proj)
arrow!(p, porth, linewidth=3)
````







##### Example

Starting with three vectors, we can create three orthogonal vectors using projection and subtraction. The creation of `porth` above is the pattern we will exploit.

Let's begin with three vectors in $R^3$:

````julia

u = [1, 2, 3]
v = [1, 1, 2]
w = [1, 2, 4]
````


````
3-element Array{Int64,1}:
 1
 2
 4
````





We can find a vector from `v` orthogonal to `u` using:

````julia

unit_vec(u) = u / norm(u)
projection(u, v) = (u ⋅ unit_vec(v)) * unit_vec(v)

vorth = v - projection(v, u)
worth = w - projection(w, u) - projection(w, vorth)
````


````
3-element Array{Float64,1}:
 -0.33333333333333265
 -0.3333333333333336
  0.33333333333333354
````





We can verify the orthogonality through:

````julia

u ⋅ vorth, u ⋅ worth, vorth ⋅ worth
````


````
(-3.3306690738754696e-16, 8.881784197001252e-16, 3.677613769070831e-16)
````





This only works when the three vectors do not all lie in the same plane. In general, this is the beginnings of the [Gram-Schmidt](https://en.wikipedia.org/wiki/Gram-Schmidt_process) process for creating *orthogonal* vectors from a collection of vectors.



#### Algebraic properties

The dot product is similar to multiplication, but different, as it is an operation defined between vectors of the same dimension. However, many algebraic properties carry over:

* commutative: $\vec{u} \cdot \vec{v} = \vec{v} \cdot \vec{u}$

* scalar multiplication: $(c\vec{u})\cdot\vec{v} = c(\vec{u}\cdot\vec{v})$.

* distributive $\vec{u} \cdot (\vec{v} + \vec{w}) = \vec{u} \cdot \vec{v} + \vec{u} \cdot \vec{w}$

The last two can be combined: $\vec{u}\cdot(s \vec{v} + t \vec{w}) = s(\vec{u}\cdot\vec{v}) + t (\vec{u}\cdot\vec{w})$.

But associative does not make sense, as $(\vec{u} \cdot \vec{v}) \cdot \vec{w}$ does not make sense as two dot products: the result of the first is not a vector, but a scalar.

## Matrices

Algebraically, the dot product of two vectors - pair off by components, multiply these, then add - is a common operation. Take for example, the general equation of a line, or a plane:

$$~
ax + by  = c, \quad ax + by + cz = d.
~$$

The left hand sides are in the form of a dot product, in this case $\langle a,b \rangle \cdot \langle x, y\rangle$ and  $\langle a,b,c \rangle \cdot \langle x, y, z\rangle$ respectively. When there is a system of equations, something like:

$$~
\begin{array}{}
3x  &+& 4y  &- &5z &= 10\\
3x  &-& 5y  &+ &7z &= 11\\
-3x &+& 6y  &+ &9z &= 12,
\end{array}
~$$

Then we might think of $3$ vectors $\langle 3,4,-5\rangle$, $\langle 3,-5,7\rangle$, and $\langle -3,6,9\rangle$ being dotted with $\langle x,y,z\rangle$. Mathematically, matrices and their associated algebra are used to represent this. In this example, the system of equations above would be represented by a matrix and two vectors:

$$~
M = \left[
\begin{array}{}
3 & 4 & -5\\
5 &-5 &  7\\
-3& 6 & 9
\end{array}
\right],\quad
\vec{x} = \langle x, y , z\rangle,\quad
\vec{b} = \langle 10, 11, 12\rangle,
~$$

and the expression $M\vec{x} = \vec{b}$. The matrix $M$ is a rectangular collection of numbers or expressions arranged in rows and columns with certain algebraic definitions. There are $m$ rows and $n$ columns in an $m\times n$ matrix. In this example $m=n=3$, and in such a case the matrix is called square. A vector, like $\vec{x}$ is usually identified with the $n \times 1$ matrix (a column vector). Were that done, the system of equations would be written $Mx=b$.

If we refer to a matrix $M$ by its components, a convention is to use $(M)_{ij}$ or $m_{ij}$ to denote the entry in the $i$th *row* and $j$th *column*. Following `Julia`'s syntax, we would use $m_{i:}$ to refer to *all* entries in the $i$th row, and $m_{:j}$ to denote *all* entries in the $j$ column.

In addition to square matrices, there are some other common types of
matrices worth naming: square matrices with $0$ entries below the
diagonal are called upper triangular; square matrices with $0$ entries
above the diagonal are called lower triangular matrices; square
matrices which are $0$ except possibly along the diagonal are diagonal
matrices; and a diagonal matrix whose diagonal entries are all $1$ is
called an identify matrix.


Matrices, like vectors, have scalar multiplication defined for them. then scalar multiplication of a matrix $M$ by $c$ just multiplies each entry by $c$, so the new matrix would have components defined by $cm_{ij}$.

Matrices of the same size, like vectors, have addition defined for them. As with scalar multiplication, addition is defined component wise. So $A+B$ is the matrix with $ij$ entry $A_{ij} + B_{ij}$.

### Matrix multiplication

Matrix multiplication may be viewed as a collection of dot product operations. First, matrix multiplication is only  defined between $A$ and $B$, as $AB$, if the size of $A$ is $m\times n$ and the size of $B$ is $n \times k$. That is the number of columns of $A$ must match the number of rows of $B$ for the left multiplication of $AB$ to be defined. It this is so, then we have the $ij$ entry of $AB$ is:

$$~
(AB)_{ij} = A_{i:} \cdot B_{:j}.
~$$

That is, if we view the $i$th row of $A$ and the $j$th column of B as  *vectors*, then the $ij$ entry is the dot product.

This is why $M$ in the example above, has the coefficients for each equation in a row and not a column, and why $\vec{x}$ is thought of as a $n\times 1$ matrix (a column vector) and not as a row vector.

Matrix multiplication between $A$ and $B$ is not, in general, commutative. Not only may the sizes not permit $BA$ to be found when $AB$ may be, there is just no guarantee when the sizes match that the components will be the same.

----

Matrices have other operations defined on them. We mention three here:

* The tranpose of a matrix flips the difference between row and column, so the $ij$ entry of the transpose is the $ji$ entry of the matrix. This means the transpose will have size $n \times m$ when $M$ has size $m \times n$. Mathematically, the transpose is denoted $M^t$.

* The *determinant* of a *square* matrix is a number that can be used to characterize the matrix. The determinant may be computed different ways, but its [definition](https://en.wikipedia.org/wiki/Leibniz_formula_for_determinants) by the Leibniz formula is common. Two special cases are all we need. The $2\times 2$ case and the $3 \times 3$ case:

$$~
\left|
\begin{array}{}
a&b\\
c&d
\end{array}
\right| =
ad - bc, \quad
\left|
\begin{array}{}
a&b&c\\
d&e&f\\
g&h&i
\end{array}
\right| =
a \left|
\begin{array}{}
e&f\\
h&i
\end{array}
\right|
- b \left|
\begin{array}{}
d&f\\
g&i
\end{array}
\right|
+c \left|
\begin{array}{}
d&e\\
g&h
\end{array}
\right|.
~$$

The $3\times 3$ case shows how determinants may be [computed recursively](https://en.wikipedia.org/wiki/Determinant#Definition), using "cofactor" expansion.

* The *inverse* of a square matrix. If $M$ is a square matrix and its determinant is non-zero, then there is an *inverse* matrix, denoted $M^{-1}$, with the properties that $MM^{-1} = M^{-1}M = I$, where $I$ is the diagonal matrix of all $1$s called the identify matrix.
### Matrices in Julia


As mentioned previously, a matrix in `Julia` is defined component by component with `[]`. We separate row entries with spaces and columns with semicolons:

````julia

M = [3 4 -5; 5 -5 7; -3 6 9]
````


````
3×3 Array{Int64,2}:
  3   4  -5
  5  -5   7
 -3   6   9
````





Space is the separator, which means computing a component during definition (i.e., writing `2 + 3` in place of `5`) can be problematic, as no space can be used in the computation, lest it be parsed as a separator.

Vectors are defined similarly. As they are *column* vectors, we use a semicolon (or a comma) to separate:

````julia

b = [10, 11, 12]   # not b = [10 11 12], which would a row vector.
````


````
3-element Array{Int64,1}:
 10
 11
 12
````






In `Julia`, entries in a matrix (or a vector) are stored in a container with a type wide enough accomodate each entry. Here the type is SymPy's `Sym` type:

````julia

using SymPy
@vars x1 x2 x3
x = [x1, x2, x3]
````


````
3-element Array{Sym,1}:
 x₁
 x₂
 x₃
````





Matrices may also be defined from blocks. This example shows how to make two column vectors into a matrix:

````julia

u = [10, 11, 12]
v = [13, 14, 15]
[u v]   # horizontally combine
````


````
3×2 Array{Int64,2}:
 10  13
 11  14
 12  15
````





Vertically combining the two will stack themL

````julia

[u; v]
````


````
6-element Array{Int64,1}:
 10
 11
 12
 13
 14
 15
````







Scalar multiplication will just work as expected:

````julia

2 * M
````


````
3×3 Array{Int64,2}:
  6    8  -10
 10  -10   14
 -6   12   18
````





Matrix addition is also straightforward:

````julia

M + M
````


````
3×3 Array{Int64,2}:
  6    8  -10
 10  -10   14
 -6   12   18
````





Matrix addition expects matrices of the same size. An error will otherwise be thrown. However, if addition is *broadcasted* then the sizes need only be commensurate. For example, this will add `1` to each entry of `M`:

````julia

M .+ 1
````


````
3×3 Array{Int64,2}:
  4   5  -4
  6  -4   8
 -2   7  10
````





Matrix multiplication is defined by `*`:

````julia

M * M
````


````
3×3 Array{Int64,2}:
  44  -38  -32
 -31   87    3
  -6   12  138
````





We can then see how the system of equations is represented with matrices:

````julia

M * x - b
````


````
3-element Array{Sym,1}:
  3⋅x₁ + 4⋅x₂ - 5⋅x₃ - 10
  5⋅x₁ - 5⋅x₂ + 7⋅x₃ - 11
 -3⋅x₁ + 6⋅x₂ + 9⋅x₃ - 12
````





Here we use `SymPy` to verify the above:

````julia

A = [symbols("A$i$j", real=true) for i in 1:3, j in 1:2]
B = [symbols("B$i$j", real=true) for i in 1:2, j in 1:2]
````


````
2×2 Array{Sym,2}:
 B₁₁  B₁₂
 B₂₁  B₂₂
````





The matrix product has the expected size: the number of rows of `A` (3) by the number of columns of `B` (2):

````julia

A*B
````


````
3×2 Array{Sym,2}:
 A₁₁⋅B₁₁ + A₁₂⋅B₂₁  A₁₁⋅B₁₂ + A₁₂⋅B₂₂
 A₂₁⋅B₁₁ + A₂₂⋅B₂₁  A₂₁⋅B₁₂ + A₂₂⋅B₂₂
 A₃₁⋅B₁₁ + A₃₂⋅B₂₁  A₃₁⋅B₁₂ + A₃₂⋅B₂₂
````





This confirms how each entry (`(A*B)[i,j]`) is from a dot product (`A[i,:]  ⋅ B[:,j]`):

````julia

[ (A*B)[i,j] == A[i,:] ⋅ B[:,j] for i in 1:3, j in 1:2]
````


````
3×2 Array{Bool,2}:
 1  1
 1  1
 1  1
````






When the multiplication is broadcasted though, with `.*`, the operation will be component wise:

````julia

M .* M   # component wise (Hadamard product)
````


````
3×3 Array{Int64,2}:
  9  16  25
 25  25  49
  9  36  81
````





----


The determinant is found through `det` provided by the built-in `LinearAlgebra` package:

````julia

using LinearAlgebra  # loaded with the CalculusWithJulia package
det(M)
````


````
-600.0000000000001
````





----

The transpose of a matrix is found through `transpose` which doesn't create a new object, but rather an object which knows to switch indices when referenced:

````julia

transpose(M)
````


````
3×3 Transpose{Int64,Array{Int64,2}}:
  3   5  -3
  4  -5   6
 -5   7   9
````





For matrices with *real* numbers, the transpose can be performed with the postfix operation `'`:

````julia

M'
````


````
3×3 Adjoint{Int64,Array{Int64,2}}:
  3   5  -3
  4  -5   6
 -5   7   9
````





(However, this is not true for matrices with complex numbers as `'` is the "adjoint," that is, the transpose of the matrix *after* taking complex conjugates.)



With `u` and `v`, vectors from above, we have:

````julia

[u' v']   # [u v] was a 3 × 2 matrix, above
````


````
1×6 Adjoint{Int64,Array{Int64,1}}:
 10  11  12  13  14  15
````





and

````julia

[u'; v']
````


````
2×3 Array{Int64,2}:
 10  11  12
 13  14  15
````



````
CalculusWithJulia.WeaveSupport.Alert("The adjoint is defined *recursively* 
in `Julia`. In the `CalculusWithJulia` package, we overload the ''' notatio
n for *functions* to yield a univariate derivative found with automatic dif
ferentiation. This can lead to problems: if we have a matrix of functions, 
`M`, and took the transpose with `M'`, then the entries of `M'` would be th
e derivatives of the functions in `M` - not the original functions. This is
 very much likely to not be what is desired. The `CalculusWithJulia` packag
e commits **type piracy** here *and* abuses the generic idea for ''' in Jul
ia. In general type piracy is very much frowned upon, as it can change expe
cted behaviour. It is defined in `CalculusWithJulia`, as that package is in
tended only to act as a means to ease users into the wider package ecosyste
m of `Julia`.\n", Dict{Any,Any}(:class => "info"))
````





----

The dot product and matrix multiplication are related, and mathematically  identified through the relation: $\vec{u} \cdot \vec{v} = u^t v$, where the right hand side identifies $\vec{u}$ and $\vec{v}$ with a $n\times 1$ column matrix, and $u^t$ is the transpose, or a $1\times n$ row matrix. However, mathematically the left side is a scalar, but the right side a $1\times 1$ matrix. While distinct, the two are identified as the same. This is similar to the useful identification of a point and a vector. Within `Julia`, these identifications are context dependent. `Julia` stores vectors as 1-dimensional arrays, transposes as $1$-dimensional objects, and matrices as $2$-dimensional arrays. The product of a transpose and a vector is a scalar:

````julia

u, v = [1,1,2], [3,5,8]
u' * v   # a scalar
````


````
24
````





But if we make `u` a matrix (here  by "`reshape`ing" in a matrix with $1$ row and $3$ columns), we will get a matrix (actually a vector) in return:

````julia

reshape(u,(1,3)) * v
````


````
1-element Array{Int64,1}:
 24
````







## Cross product

In three dimensions, there is a another operation between vectors that is similar to multiplication, though we will see with many differences.

Let $\vec{u}$ and $\vec{v}$ be two 3-dimensional vectors, then the *cross* product, $\vec{u} \times \vec{v}$, is defined as a vector with length:

$$~
\| \vec{u} \times \vec{v} \| = \| \vec{u} \| \| \vec{v} \| \sin(\theta),
~$$

with $\theta$ being the angle in $[0, \pi]$ between $\vec{u}$ and $\vec{v}$. Consequently, $\sin(\theta) \geq 0$.

The direction of the cross product is such that it is *orthogonal* to *both* $\vec{u}$ and $\vec{v}$. To identify this, the [right-hand rule](https://en.wikipedia.org/wiki/Cross_product#Definition) is used. This rule points the right hand fingers in the direction of $\vec{u}$ and curls them towards $\vec{v}$ (so that the angle between the two vectors is in $[0, \pi]$). The thumb will point in the direction. Call this direction $\hat{n}$, a normal unit vector. Then the cross product can be defined by:

$$~
\vec{u} \times \vec{v} =  \| \vec{u} \| \| \vec{v} \| \sin(\theta) \hat{n}.
~$$

````
CalculusWithJulia.WeaveSupport.Alert("The right-hand rule is also useful to
 understand how standard household screws will behave when twisted with a s
crewdriver. If the right hand fingers curl in the direction of the twisting
 screwdriver, then the screw will go in or out following the direction poin
ted to by the thumb.\n", Dict{Any,Any}(:class => "info"))
````






The right-hand rule depends on the order of consideration of the vectors. If they are reversed, the opposite direction is determined. A consequence is that the cross product is **anti**-commutative, unlike multiplication:

$$~
\vec{u} \times \vec{v} = - \vec{v} \times \vec{u}.
~$$

Mathematically, the definition in terms of its components is a bit involved:

$$~
\vec{u} \times \vec{v} = \langle u_2 v_3 - u_3 v_2, u_3 v_1 - u_1 v_3, u_1 v_2 - u_2 v_1 \rangle.
~$$

There is a matrix notation that can simplify this computation. If we *formally* define $\hat{i}$, $\hat{j}$, and $\hat{k}$ to represent unit vectors in the $x$, $y$, and $z$ direction, then a vector $\langle u_1, u_2, u_3 \rangle$ could be written $u_1\hat{i} + u_2\hat{j} + u_3\hat{k}$. With this the cross product of $\vec{u}$ and $\vec{v}$ is the vector associated with the *determinant* of the matrix

$$~
\left[
\begin{array}{}
\hat{i} & \hat{j} & \hat{k}\\
u_1   & u_2   & u_3\\
v_1   & v_2   & v_3
\end{array}
\right] =
~$$

From the $\sin(\theta)$ term in the definition, we see that $\vec{u}\times\vec{u}=0$. In fact, the cross product is $0$ only if the two vectors involved are parallel or there is a zero vector.



In `Julia`, the `cross` function from the `LinearAlgebra` package (part of the standard library) implements the cross product. For example:

````julia

a = [1, 2, 3]
b = [4, 2, 1]
cross(a, b)
````


````
3-element Array{Int64,1}:
 -4
 11
 -6
````





There is also the *infix* unicode operator `\times[tab]` that can be used for similarity to traditional mathematical syntax.

````julia

a × b
````


````
3-element Array{Int64,1}:
 -4
 11
 -6
````





We can see the cross product is anti-commutative by comparing the last answer with:

````julia

b × a
````


````
3-element Array{Int64,1}:
   4
 -11
   6
````






Using vectors of size different than $n=3$ produces a dimension mismatch error:

````julia

[1, 2] × [3, 4]
````


````
Error: DimensionMismatch("cross product is only defined for vectors of leng
th 3")
````





(It can prove useful to pad 2-dimensional vectors into 3-dimensional vectors by adding a $0$ third component. We will see this in the discussion on curvature in the plane.)


Let's see that the matrix definition will be identical (after identifications) to `cross`:

````julia

using SymPy, LinearAlgebra  # already loaded with the CalculusWithJulia package
@vars i j k
M = [i j k; 3 4 5; 3 6 7]
det(M) |> simplify
````


````
-2⋅i - 6⋅j + 6⋅k
````





Compare with

````julia

M[2,:] × M[3,:]
````


````
3-element Array{Sym,1}:
 -2
 -6
  6
````





----


Consider this extended picture involving two vectors $\vec{u}$ and $\vec{v}$ drawn in two dimensions:

````julia
u = [1, 2]
v = [2, 1]
p = [0,0]

plot(aspect_ratio=:equal)
arrow!(p, u)
arrow!(p, v)
arrow!(u, v)
arrow!(v, u)

puv = (u ⋅ v) / (v ⋅ v) * v
porth = u - puv
arrow!(puv, porth)
````





The enclosed shape is a parallelogram. To this we added the projection of $\vec{u}$ onto $\vec{v}$ (`puv`) and then the *orthogonal* part (`porth`).

The *area* of a parallelogram is the length of one side times the perpendicular height. The perpendicular height could be found from `norm(porth)`, so the area is:

````julia

norm(v) * norm(porth)
````


````
3.0
````





However, from trigonometry we have the height would also be the norm of $\vec{u}$ times $\sin(\theta)$, a value that is given through the length of the cross product of $\vec{u}$ and $\hat{v}$, the unit vector, were these vectors viewed as 3 dimensional by adding a $0$ third component. In formulas, this is also the case:

$$~
\text{area of the parallelogram} = \| \vec{u} \times \hat{v} \| \| \vec{v} \| = \| \vec{u} \times \vec{v} \|.
~$$

We have, for our figure, after extending `u` and `v` to be three dimensional the area of the parallelogram:

````julia

u = [1, 2, 0]
v = [2, 1, 0]
norm(u × v)
````


````
3.0
````





----

This analysis can be extended to the case of 3 vectors, which - when not co-planar - will form a *parallelepiped*.

````julia
plotly()
u,v,w = [1,2,3], [2,1,0], [1,1,2]
plot()
p = [0,0,0]

plot(legend=false)
arrow!(p, u); arrow!(p, v); arrow!(p, w)
arrow!(u, v); arrow!(u, w)
arrow!(v, u); arrow!(v, w)
arrow!(w, u); arrow!(w, v)
arrow!(u+v, w); arrow!(u+w, v); arrow!(v+w,u)
````





The volume of a parallelepiped is the area of a base parallelogram times the height of a perpendicular. If $\vec{u}$ and $\vec{v}$ form the base parallelogram, then the perpendicular will have height $\|\vec{w}\| \cos(\theta)$ where the angle is the one made by $\vec{w}$ with the normal, $\vec{n}$. Since $\vec{u} \times \vec{v} = \| \vec{u} \times \vec{v}\|  \hat{n} = \hat{n}$ times the area of the base parallelogram, we have if we dot this answer with $\vec{w}$:

$$~
(\vec{u} \times \vec{v}) \cdot \vec{w} =
\|\vec{u} \times \vec{v}\| (\vec{n} \cdot \vec{w}) =
\|\vec{u} \times \vec{v}\| \| \vec{w}\| \cos(\theta),
~$$

that is, the area of the parallelepiped. Wait, what about $(\vec{v}\times\vec{u})\cdot\vec{w}$? That will have an opposite sign. Yes, in the above, there is an assumption that $\vec{n}$ and $\vec{w}$ have a an angle between them within $[0, \pi/2]$, otherwise an absolute value must be used, as volume is non-negative.


````
CalculusWithJulia.WeaveSupport.Alert(L"The triple-scalar product, $\vec{u}\
cdot(\vec{v}\times\vec{w})$, gives the volume of the parallelepiped up to s
ign. If the sign of this is positive, the 3 vectors are said to have a *pos
itive* orientation, if they triple-scalar product is negative, the vectors 
have a *negative* orientation.
", Dict{Any,Any}(:class => "info"))
````






#### Algebraic properties

The cross product has many properties, some different from regular multiplication:

* scalar multiplication: $(c\vec{u})\times\vec{v} = c(\vec{u}\times\vec{v})$

* distributive over addition: $\vec{u} \times (\vec{v} + \vec{w}) = \vec{u}\times\vec{v} + \vec{u}\times\vec{w}$.

* *anti*-commutative: $\vec{u} \times \vec{v} = - \vec{v} \times \vec{u}$


* *not* associative: that is there is no guarantee that $(\vec{u}\times\vec{v})\times\vec{w}$ will be equivalent to $\vec{u}\times(\vec{v}\times\vec{w})$.

* The triple cross product $(\vec{u}\times\vec{v}) \times \vec{w}$ must be orthogonal to $\vec{u}\times\vec{v}$ so lies in a plane with this as a normal vector. But, $\vec{u}$ and $\vec{v}$ will generate this plane, so it should be possible to express this triple product in terms of a sum involving $\vec{u}$ and $\vec{v}$ and indeed:

$$~
(\vec{u}\times\vec{v})\times\vec{w} = (\vec{u}\cdot\vec{w})\vec{v} - (\vec{v}\cdot\vec{w})\vec{u}.
~$$

----

The following shows the algebraic properties stated above hold for
symbolic vectors. First the linearity of the dot product:

````julia

@vars s t u1 u2 u3 v1 v2 v3 w1 w2 w3 real=true
u = [u1, u2, u3]
v = [v1, v2, v3]
w = [w1, w2, w3]

u ⋅ (s*v + t*w) - (s*(u⋅v) + t*(u⋅w)) |> simplify
````


````
0
````





This shows the dot product is commutative:

````julia

(u ⋅ v) - (v ⋅ u) |> simplify
````


````
0
````





This shows the linearity of the cross product over scalar multiplication and vector addition:

````julia

u × (s*v + t*w) - (s*(u×v) + t*(u×w)) .|> simplify
````


````
3-element Array{Sym,1}:
 0
 0
 0
````





(We use `.|>` to broadcast `simplify` over each component.)

The cross product is anti-commutative:

````julia

u × v + v × u .|> simplify
````


````
3-element Array{Sym,1}:
 0
 0
 0
````





but not associative:

````julia

u × (v × w) - (u × v) × w .|> simplify
````


````
3-element Array{Sym,1}:
  u₁⋅v₂⋅w₂ + u₁⋅v₃⋅w₃ - u₂⋅v₂⋅w₁ - u₃⋅v₃⋅w₁
 -u₁⋅v₁⋅w₂ + u₂⋅v₁⋅w₁ + u₂⋅v₃⋅w₃ - u₃⋅v₃⋅w₂
 -u₁⋅v₁⋅w₃ - u₂⋅v₂⋅w₃ + u₃⋅v₁⋅w₁ + u₃⋅v₂⋅w₂
````





Finally we verify the decomposition of the triple cross product:

````julia

(u × v) × w - ( (u ⋅ w) * v - (v ⋅ w) * u) .|> simplify
````


````
3-element Array{Sym,1}:
 0
 0
 0
````






----

This table shows common usages of the symbols for various multiplication types: `*`, $\cdot$, and $\times$:


| Symbol   | inputs         | output      | type                  |
|:--------:|:-------------- |:----------- |:------                |
| `*`      | scalar, scalar | scalar      | regular multiplication |
| `*`      | scalar, vector | vector      | scalar multiplication |
| `*`      | vector, vector | *undefined* |                       |
| $\cdot$  | scalar, scalar | scalar      | regular multiplication |
| $\cdot$  | scalar, vector | vector      | scalar multiplication  |
| $\cdot$  | vector, vector | scalar      | dot product           |
| $\times$ | scalar, scalar | scalar      | regular multiplication |
| $\times$ | scalar, vector | undefined   |                       |
| $\times$ | vector, vector | vector      | cross product         |


----



##### Example: lines and planes

A line in two dimensions satisfies the equation $ax + by = c$. Suppose $a$ and $b$ are non-zero. This can be represented in vector form, as the collection of all points associated to the vectors: $p + t \vec{v}$ where $p$ is a point on the line, say $(0,c/b)$, and v is the vector $\langle b, -a \rangle$. We can verify, this for values of `t` as follows:

````julia

@vars a b c x y t

eq = c - (a*x + b*y)

p = [0, c/b]
v = [-b, a]
li = p + t * v

eq(x=>li[1], y=>li[2]) |> simplify
````


````
0
````






Let $\vec{n} = \langle a , b \rangle$, taken from the coefficients in the equation. We can see directly that $\vec{n}$ is orthogonal to $\vec{v}$. The line may then be seen as the collection of all vectors that are orthogonal to $\vec{n}$ that have their tail at the point $p$.

In three dimensions, the equation of a plane is $ax + by + cz = d$. Suppose, $a$, $b$, and $c$ are non-zero, for simplicity. Setting $\vec{n} = \langle a,b,c\rangle$ by comparison, it can be seen that plane is identified with the set of all vectors orthogonal to $\vec{n}$ that are anchored at $p$.

First, let $p = (0, 0, d/c)$ be a point on the plane. We find two vectors $u = \langle -b, a, 0 \rangle$ and $v = \langle 0, c, -b \rangle$. Then any point on the plane may be identified with the vector $p + s\vec{u} + t\vec{v}$. We can verify this algebraically through:

````julia

@vars d z s

eq = d - (a*x + b*y + c * z)

p = [0, 0, d/c]
u, v = [-b, a, 0], [0, c, -b]
pl = p + t * u + s * v

subs(eq, x=>pl[1], y=>pl[2], z=>pl[3]) |> simplify
````


````
0
````





The above viewpoint can be reversed:

> a plane is determined by two (non-parallel) vectors and a point.

The parameterized version of the plane would be $p + t \vec{u} + s
\vec{v}$, as used above.

The equation of the plane can be given from $\vec{u}$ and
$\vec{v}$. Let $\vec{n} = \vec{u} \times \vec{v}$. Then $\vec{n} \cdot
\vec{u} = \vec{n} \cdot \vec{v} = 0$, from the properties of the cross product. As such, $\vec{n} \cdot (s
\vec{u} + t \vec{v}) = 0$. That is, the cross product is orthogonal to
any *linear* combination of the two vectors. This figure shows one such linear combination:



````julia
u = [1,2,3]
v = [2,3,1]
n = u × v
p = [0,0,1]

plot(legend=false)

arrow!(p, u)
arrow!(p, v)
arrow!(p + u, v)
arrow!(p + v, u)
arrow!(p, n)

s, t = 1/2, 1/4
arrow!(p, s*u + t*v)
````






So if $\vec{n} \cdot p = d$ (identifying the point $p$ with a vector so the dot product is defined), we will have for any vector $\vec{v} = \langle x, y, z \rangle = s \vec{u} + t \vec{v}$ that

$$~
\vec{n} \cdot (p + s\vec{u} + t \vec{v}) = \vec{n} \cdot p + \vec{n} \cdot (s \vec{u} + t \vec{v}) = d + 0 = d,
~$$

But if $\vec{n} = \langle a, b, c \rangle$, then this says $d = ax + by + cz$, so from $\vec{n}$ and $p$ the equation of the plane is given.

In summary:

|  Object | Equation           | vector equation                  |
|:------- |:------------------:|:-------------------------------- |
|Line     | $ax + by = c$      | line: $p + t\vec{u}$             |
|Plane    | $ax + by + cz = d$ | plane: $p + s\vec{u} + t\vec{v}$ |

----


##### Example

You are given that the vectors $\vec{u} =\langle 6, 3, 1 \rangle$ and $\vec{v} = \langle 3, 2, 1 \rangle$ describe a plane through the point $p=[1,1,2]$. Find the equation of the plane.

The key is to find the normal vector to the plane, $\vec{n} = \vec{u} \times \vec{v}$:

````julia

u, v, p = [6,3,1], [3,2,1], [1,1,2]
n = u × v
a, b, c = n
d = n ⋅ p
"equation of plane: $a x + $b y + $c z = $d"
````


````
"equation of plane: 1 x + -3 y + 3 z = 4"
````







## Questions

###### Question

Let `u=[1,2,3]`, `v=[4,3,2]`, and `w=[5,2,1]`.

Find `u ⋅ v`:

````
CalculusWithJulia.WeaveSupport.Numericq(16, 0, "", "[16.0, 16.0]", 16, 16, 
"", "")
````





Are `v` and `w` orthogonal?

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 2, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````





Find the angle between `u` and `w`:

````
CalculusWithJulia.WeaveSupport.Numericq(0.945250237728822, 0.001, "", "[0.9
4425, 0.94625]", 0.944250237728822, 0.946250237728822, "", "")
````






Find `u ×  v`:

````
CalculusWithJulia.WeaveSupport.Radioq(["`[-1, 6, -7]`", "`[-4, 14, -8]`", "
`[-5, 10, -5]`"], 3, "", nothing, [1, 2, 3], ["`[-1, 6, -7]`", "`[-4, 14, -
8]`", "`[-5, 10, -5]`"], "", false)
````





Find the area of the parallelogram formed by `v` and `w`

````
CalculusWithJulia.WeaveSupport.Numericq(9.273618495495704, 0.001, "", "[9.2
7262, 9.27462]", 9.272618495495704, 9.274618495495703, "", "")
````







Find the  volume of the parallelepiped formed by `u`, `v`, and `w`:

````
CalculusWithJulia.WeaveSupport.Numericq(10, 0, "", "[10.0, 10.0]", 10, 10, 
"", "")
````






###### Question

The dot product of two vectors may be described in words: pair off the corresponding values, multiply them, then add. In `Julia` the `zip` command will pair off two iterable objects, like vectors, so it seems like this command: `sum(prod.(zip(u,v)))` will find a dot product. Investigate  if it is does or doesn't by testing the following command and comparing to the dot product:

````julia

u,v = [1,2,3], [5,4,2]
sum(prod.(zip(u,v)))
````




Does this return the same answer:

````
CalculusWithJulia.WeaveSupport.Radioq(["Yes", "No"], 1, "", nothing, [1, 2]
, ["Yes", "No"], "", false)
````






What does command `zip(u,v)` return?

````
CalculusWithJulia.WeaveSupport.Radioq(["An object of type `Base.Iterators.Z
ip` that is only realized when used", "A vector of values `[(1, 5), (2, 4),
 (3, 2)]`"], 1, "", nothing, [1, 2], ["An object of type `Base.Iterators.Zi
p` that is only realized when used", "A vector of values `[(1, 5), (2, 4), 
(3, 2)]`"], "", false)
````





What does `prod.(zip(u,v))` return?

````
CalculusWithJulia.WeaveSupport.Radioq(["A vector of values `[5, 8, 6]`", "A
n object of type `Base.Iterators.Zip` that when realized will produce a vec
tor of values"], 1, "", nothing, [1, 2], ["A vector of values `[5, 8, 6]`",
 "An object of type `Base.Iterators.Zip` that when realized will produce a 
vector of values"], "", false)
````





###### Question

Let $\vec{u}$ and $\vec{v}$ be 3-dimensional **unit** vectors. What is the value of

$$~
(\vec{u} \times \vec{v}) \cdot (\vec{u} \times \vec{v}) + (\vec{u} \cdot \vec{v})^2?
~$$

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"$1$", "Can't say in 
general", L"$0$"], 1, "", nothing, [1, 2, 3], AbstractString[L"$1$", "Can't
 say in general", L"$0$"], "", false)
````





###### Question

Consider the projection of $\langle 1, 2, 3\rangle$ on $\langle 3, 2, 1\rangle$. What is its length?

````
CalculusWithJulia.WeaveSupport.Numericq(2.6726124191242437, 0.001, "", "[2.
67161, 2.67361]", 2.671612419124244, 2.6736124191242436, "", "")
````





###### Question

Let $\vec{u} = \langle 1, 2, 3 \rangle$ and $\vec{v} = \langle 3, 2, 1 \rangle$. Describe the plane created by these two non-parallel vectors going through the origin.

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$x + 2y + 
z = 0$", L"$x + 2y + 3z = 6$", L"$-4x + 8y - 4z = 0$"], 3, "", nothing, [1,
 2, 3], LaTeXStrings.LaTeXString[L"$x + 2y + z = 0$", L"$x + 2y + 3z = 6$",
 L"$-4x + 8y - 4z = 0$"], "", false)
````






###### Question

A plane $P_1$ is *orthogonal* to $\vec{n}_1$, a plane $P_2$ is *orthogonal* to $\vec{n}_2$. Explain why vector $\vec{v} = \vec{n}_1 \times \vec{n}_2$ is parallel to the *intersection* of $P_1$ and $P_2$.

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\vec{n}_1
$ and $\vec{n_2}$ are unit vectors, so the cross product gives the projecti
on, which must be orthogonal to each vector, hence in the intersection", L"
$\vec{v}$ is in plane $P_1$, as it is orthogonal to $\vec{n}_1$ and $P_2$ a
s it is orthogonal to $\vec{n}_2$, hence it is parallel to both planes."], 
2, "", nothing, [1, 2], LaTeXStrings.LaTeXString[L"$\vec{n}_1$ and $\vec{n_
2}$ are unit vectors, so the cross product gives the projection, which must
 be orthogonal to each vector, hence in the intersection", L"$\vec{v}$ is i
n plane $P_1$, as it is orthogonal to $\vec{n}_1$ and $P_2$ as it is orthog
onal to $\vec{n}_2$, hence it is parallel to both planes."], "", false)
````





###### Question

(From Strang). For an (analog) clock draw vectors from the center out to each of the 12 hours marked on the clock. What is the vector sum of these 12 vectors?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\vec{0}$"
, L"$12 \langle 1, 0 \rangle$", L"$\langle 12, 12 \rangle$"], 1, "", nothin
g, [1, 2, 3], LaTeXStrings.LaTeXString[L"$\vec{0}$", L"$12 \langle 1, 0 \ra
ngle$", L"$\langle 12, 12 \rangle$"], "", false)
````





If the vector to 3 o'clock is removed, (call this $\langle 1, 0 \rangle$) what expresses the sum of *all* the remaining vectors?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\langle 1
1, 11 \rangle$", L"$\langle 1, 0 \rangle$", L"$\langle -1, 0 \rangle$"], 3,
 "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"$\langle 11, 11 \rangle
$", L"$\langle 1, 0 \rangle$", L"$\langle -1, 0 \rangle$"], "", false)
````





###### Question

Let $\vec{u}$ and $\vec{v}$ be unit vectors. Let $\vec{w} = \vec{u} + \vec{v}$. Then $\vec{u} \cdot \vec{w} = \vec{v} \cdot \vec{w}$. What is the value?

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\vec{u} +
 \vec{v}$", L"$\vec{u}\cdot\vec{v} + \vec{v}\cdot \vec{v}$", L"$1 + \vec{u}
\cdot\vec{v}$"], 3, "", nothing, [1, 2, 3], LaTeXStrings.LaTeXString[L"$\ve
c{u} + \vec{v}$", L"$\vec{u}\cdot\vec{v} + \vec{v}\cdot \vec{v}$", L"$1 + \
vec{u}\cdot\vec{v}$"], "", false)
````





As the two are equal, which interpretation is true?

````
CalculusWithJulia.WeaveSupport.Radioq(AbstractString[L"The vector $\vec{w}$
 must also be a unit vector", "the two are orthogonal", L"The angle they ma
ke with $\vec{w}$ is the same"], 3, "", nothing, [1, 2, 3], AbstractString[
L"The vector $\vec{w}$ must also be a unit vector", "the two are orthogonal
", L"The angle they make with $\vec{w}$ is the same"], "", false)
````







###### Question

Suppose $\| \vec{u} + \vec{v} \|^2 = \|\vec{u}\|^2 + \|\vec{v}\|^2$. What is $\vec{u}\cdot\vec{v}$?

We have $(\vec{u} + \vec{v})\cdot(\vec{u} + \vec{v}) = \vec{u}\cdot \vec{u} + 2 \vec{u}\cdot\vec{v} + \vec{v}\cdot\vec{v}$. From this, we can infer that:

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\vec{u}\c
dot\vec{v} = 2$", L"$\vec{u}\cdot\vec{v} = 0$", L"$\vec{u}\cdot\vec{v} = -(
\vec{u}\cdot\vec{u} \vec{v}\cdot\vec{v})$"], 2, "", nothing, [1, 2, 3], LaT
eXStrings.LaTeXString[L"$\vec{u}\cdot\vec{v} = 2$", L"$\vec{u}\cdot\vec{v} 
= 0$", L"$\vec{u}\cdot\vec{v} = -(\vec{u}\cdot\vec{u} \vec{v}\cdot\vec{v})$
"], "", false)
````






###### Question


Give a geometric reason for this identity:

$$~
\vec{u} \cdot (\vec{v} \times \vec{w}) =
\vec{v} \cdot (\vec{w} \times \vec{u}) =
\vec{w} \cdot (\vec{u} \times \vec{v})
~$$


````
CalculusWithJulia.WeaveSupport.Radioq(["The vectors are *orthogonal*, so th
ese are all zero", "The triple product describes a volume up to sign, this 
combination preserves the sign", "The vectors are all unit lengths, so thes
e are all 1"], 2, "", nothing, [1, 2, 3], ["The vectors are *orthogonal*, s
o these are all zero", "The triple product describes a volume up to sign, t
his combination preserves the sign", "The vectors are all unit lengths, so 
these are all 1"], "", false)
````





###### Question

Snell's law in planar form is $n_1\sin(\theta_1) = n_2\sin(\theta_2)$ where $n_i$ is a constant depending on the medium.

![](/var/folders/k0/94d1r7xd2xlcw_jkgqq4h57w0000gr/T/vectors_89_1.png)



In vector form, we can express it using *unit* vectors through:

````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$n_1 (\hat
{v_1}\times\hat{N}) = n_2  (\hat{v_2}\times\hat{N})$", L"$n_1 (\hat{v_1}\ti
mes\hat{N}) = -n_2  (\hat{v_2}\times\hat{N})$"], 1, "", nothing, [1, 2], La
TeXStrings.LaTeXString[L"$n_1 (\hat{v_1}\times\hat{N}) = n_2  (\hat{v_2}\ti
mes\hat{N})$", L"$n_1 (\hat{v_1}\times\hat{N}) = -n_2  (\hat{v_2}\times\hat
{N})$"], "", false)
````





###### Question

The Jacobi relationship show that for *any* $3$ randomly chosen vectors:

$$~
\vec{a}\times(\vec{b}\times\vec{c})+
\vec{b}\times(\vec{c}\times\vec{a})+
\vec{c}\times(\vec{a}\times\vec{b})
~$$

simplifies. To what? (Use `SymPy` or randomly generated vectors to see.)


````
CalculusWithJulia.WeaveSupport.Radioq(LaTeXStrings.LaTeXString[L"$\vec{a}$"
, L"$\vec{0}$", L"$\vec{a} + \vec{b} + \vec{c}$"], 2, "", nothing, [1, 2, 3
], LaTeXStrings.LaTeXString[L"$\vec{a}$", L"$\vec{0}$", L"$\vec{a} + \vec{b
} + \vec{c}$"], "", false)
````


