
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
gr()
nothing


using Measures
const px = 0.26mm
fig_size = (400, 300)
x0 = [0, 64]
v0 = [20, 0]
g  = [0, -32]

unit(v::Vector) = v / norm(v)
x_ticks = collect(0:10:80)
y_ticks = collect(0:10:80)


function make_plot(t)

    xn = (t) -> x0 + v0*t + 1/2*g*t^2
    vn = (t) -> v0 + g*t
    an = (t) -> g


    t = 1/10 + t*2/10

    ts = range(0, stop=2, length=100)
    xys = map(xn, ts)

    xs, ys = [p[1] for p in xys], [p[2] for p in xys]

    plt = Plots.plot(xs, ys, legend=false, size=fig_size, xlims=(0,45), ylims=(0,70))
    plot!(plt, zero, extrema(xs)...)
    arrow!(xn(t), 10*unit(xn(t)), color="black")
    arrow!(xn(t), 10*unit(vn(t)), color="red")
    arrow!(xn(t), 10*unit(an(t)), color="green")

    plt


end

imgfile = tempname() * ".gif"
caption = """

Position, velocity, and acceleration vectors (scaled) for projectile
motion. Vectors are drawn with tail on the projectile. The position
vector (black) points from the origin to the projectile, the velocity
vector (red) is in the direction of the trajectory, and the
acceleration vector (green) is a constant pointing downward.

"""

n = 8
anim = @animate for i=1:n
    make_plot(i)
end

gif(anim, imgfile, fps = 1)

ImageFile(imgfile, caption)


## generic vector
p0 = [0,0]
a1 = [4,1]
b1 = [-2,2]

plt = plot(legend=false, size=fig_size)
arrow!(p0, a1, color="blue")
arrow!([1,1], unit(a1), color="red")
annotate!([(2, .4, L"v"), (1.6, 1.05, L"\hat{v}")])

imgfile = tempname() * ".png"
png(plt, imgfile)

caption = "A vector and its unit vector. They share the same direction, but the unit vector has a standardized magnitude."

ImageFile(imgfile, caption)


## vector_addition_image

p0 = [0,0]
a1 = [4,1]
b1 = [-2,2]


plt = Plots.plot(legend=false, size=fig_size)
arrow!(p0, a1, color="blue")
arrow!(p0+a1, b1, color="red")
arrow!(p0, a1+b1, color="black")
annotate!([(2, .25, L"a"), (3, 2.25, L"b"), (1.35, 1.5, L"a+b")])

imgfile = tempname() * ".png"
png(plt, imgfile)

caption = "The sum of two vectors can be visualized by placing the tail of one at the tip of the other"

ImageFile(imgfile, caption)


## vector_subtraction_image

p0 = [0,0]
a1 = [4,1]
b1 = [-2,2]

plt = plot(legend=false, size=fig_size)
arrow!(p0, a1, color="blue")
arrow!(p0, b1, color="red")
arrow!(b1, a1-b1, color="black")
annotate!(plt, [(-1, .5, L"a"), (2.45, .5, L"b"), (1, 1.75, L"a-b")])


imgfile = tempname() * ".png"
png(plt, imgfile)

caption = "The sum of two vectors can be visualized by placing the tail of one at the tip of the other"

ImageFile(imgfile, caption)


### {{{vector_decomp}}}

aa = [1,2]
bb = [2,1]
cc = [4,3]
alpha = 2/3
beta = 5/3

plt = plot(legend=false, size=fig_size)
arrow!(p0, cc, color="black", width=1)
arrow!(p0, aa, color="black", width=1)
arrow!(alpha*aa, bb, color="black", width=1)
arrow!(p0, alpha*aa, color="orange", width=4, opacity=0.5)
arrow!(alpha*aa, beta*bb, color="orange", width=4, opacity=0.5)
annotate!(plt, collect(zip([2, .5, 1.75], [1.25,1.0,2.25], [L"c",L"2/3 \cdot a", L"5/3 \cdot b"])))


imgfile = tempname() * ".png"
png(plt, imgfile)

caption = L"""
The vector $\langle 4,3 \rangle$ is written as
$2$/$3$ $\cdot\langle 1,2 \rangle$ $+$ $5$/$3$ $\cdot\langle 2,1 \rangle$. Any vector $\vec{c}$ can be
written uniquely as $\alpha\cdot\vec{a} + \beta \cdot \vec{b}$ provided
$\vec{a}$ and $\vec{b}$ are not parallel."""

ImageFile(imgfile, caption)


## vector_rtheta

plt = plot(legend=false, size=fig_size)
arrow!(p0, [2,3], color="black")
arrow!(p0, [2,0], color="orange")
arrow!(p0+[2,0], [0,3], color="orange")
annotate!(plt, collect(zip([.25, 1,1,1.75], [.35, 1.9,.25,1], [L"t",L"r", L"r \cdot \cos(t)", L"r \cdot \sin(t)"]))) #["θ","r", "r ⋅ cos(θ)", "r ⋅ sin(θ)"]

imgfile = tempname() * ".png"
png(plt, imgfile)

caption = L"""

A vector $\langle x, y \rangle$ can be written as $\langle r\cdot
\cos(\theta), r\cdot\sin(\theta) \rangle$ for values $r$ and
$\theta$. The value $r$ is a magnitude, the direction parameterized by
$\theta$."""

ImageFile(imgfile, caption)


x, y = 1, 2
v = [x, y]        # square brackets, not angles


10 * v


import LinearAlgebra: norm
norm(v)


v / norm(v)


w = [3, 2]
v + w, v - 2w


# v  = [x, y]
norm(v), atan(y, x)


fibs = [1,1,2,3,5,8,13]


["one", "two", "three"]  # Array{T, 1} is shorthand for Vector{T}. Here T - the type - is String


[true, false, true]		# vector of Bool values


[1, 2.0, 3//1]


["one", 2, 3.0, 4//1]


v = [1, 2]
x, y = v


v[2]


note("""
There is [much more](http://julia.readthedocs.org/en/latest/manual/arrays/#indexing)
to indexing than just indexing by a single integer value. For example, the following can be used for indexing:

* a scalar integer (as seen)

* a range

* a vector of integers

* a boolean vector

Some add-on packages extend this further.
""",
title="More on indexing", label="More on indexing")


v[2] = 10


v


v = [1,1,2,3,5,8]
sum(v), prod(v)


unique(v) # drop a `1`


v = [1,4,2,3]
maximum(v)


extrema(v)


sort(v)


sort(v, rev=false)


push!(v, 5)


append!(v, [6,8,7])


xs = [1, 1, 3, 4, 7]
sqrt.(xs)


sin.(xs)


xs .^ 2


xs = [1/5000, 1/500, 1/50, 1/5, 5, 50]
b = (100)^(1/5)
log.(b, xs)


import Statistics: mean
xs = [1, 1, 2, 3, 5, 8, 13]
n = length(xs)
(1/(n-1)) * sum(abs2.(xs .- mean(xs)))


note("""The `map` function is very much related to broadcasting and similarly named functions are found in many different programming languages. (The "dot" broadcast is mostly limited to `Julia` and based on a similar usage of a dot in `MATLAB`.) For those familiar with other programming languages, using `map` may seem more natural. Its syntax is `map(f, xs)`.
""")


xs = [1,2,3,4,5]
[x^3 for x in xs ]


xs .^ 3


[x for x in 1:100 if rem(x,7) == 0]


a,b, n = -1, 1, 7
d = (b-a) // (n-1)
xs = [a, a+d, a+2d, a+3d, a+4d, a+5d, a+6d]  # 7 points


ys = [x^2 for x in xs]


[xs ys]


note(L"""

The style generally employed here is to use plural variable names for a collection
of values, such as the vector of $y$ values and singular names when a
single value is being referred to, leading to expressions like "`x in xs`".

""")


choices = [
q"v = [4,3]",
q"v = {4, 3}",
q"v = '4, 3'",
q"v = (4,3)",
q"v = <4,3>"]
ans = 1
radioq(choices, ans)


choices = [q"v = [4,3,2,1]", q"v = (4,3,2,1)", q"v = {4,3,2,1}", q"v = '4, 3, 2, 1'", q"v = <4,3,2,1>"]
ans = 1
radioq(choices, ans)


v = [10, 15]
val = norm(v)
numericq(val)


choices = [q"[3, 4]", q"[0.6, 0.8]", q"[1.0, 1.33333]", q"[1, 1]"]
ans = 2
radioq(choices, ans)


choices = [q"[3, 4]", q"[30, 40]", q"[9.48683, 12.6491 ]", q"[10, 10]"]
ans = 2
radioq(choices, ans)


choices = [q"[4, 6]", q"[6, 8]", q"[11, 18]", q"[5, 10]"]
ans = 3
radioq(choices, ans)


v = [1, 1, 2, 3, 5, 8, 13, 21]


v = [1, 1, 2, 3, 5, 8, 13, 21]
val = length(v)
numericq(val)


v = [1, 1, 2, 3, 5, 8, 13, 21]
val = sum(v)
numericq(val)


v = [1,1,2,3,5,8,13,21]
val = prod(v)
numericq(val)


using Plots
#gr()

p = plot(xlim=(0,10), ylim=(0,5), legend=false, framestyle=:none)
for j in (-3):10
    plot!(p, [j, j + 5], [0, 5*sqrt(3)], color=:blue, alpha=0.5)
    plot!(p, [j - 5, j], [5*sqrt(3), 0], color=:blue, alpha=0.5)
end
for i in 1/2:1/2:3
    plot!(p, [0,10],sqrt(3)*[i,i], color=:blue, alpha=0.5)
end

quiver!(p, [(3/2, 3/2*sqrt(3))], quiver=[(1,0)], color=:black,  linewidth=5)        # a
quiver!(p, [(2, sqrt(3))], quiver=[(1/2,-sqrt(3)/2)], color=:black,  linewidth=5)   # b

quiver!(p, [(3 + 3/2, 3/2*sqrt(3))], quiver=[(3,0)], color=:black,  linewidth=5)        # c
quiver!(p, [(4 , sqrt(3))], quiver=[(3/2,-sqrt(3)/2)], color=:black,  linewidth=5)        # d
quiver!(p, [(6+1/2 , sqrt(3)/2)], quiver=[(1/2, sqrt(3)/2)], color=:black,  linewidth=5)        # e

delta = 1/4
annotate!(p, [(2, 3/2*sqrt(3) -delta, L"a"),
              (2+1/4, sqrt(3), L"b"),
              (3+3/2+3/2, 3/2*sqrt(3)-delta, L"c"),
              (4+3/4, sqrt(3) - sqrt(3)/4-delta, L"d"),
              (6+3/4+delta, sqrt(3)/2 + sqrt(3)/4-delta, L"e")
              ])


p


choices = ["3a", "3b", "a + b", "a - b", "b-a"]
ans = 1
radioq(choices, ans)


choices = ["3a", "3b", "a + b", "a - b", "b-a"]
ans = 3
radioq(choices, ans)


choices = ["3a", "3b", "a + b", "a - b", "b-a"]
ans = 4
radioq(choices, ans)


choices = [q"f.(xs)", q"map(f, xs)", q"[f(x) for x in xs]", "All three of them work"]
ans = 4
radioq(choices, ans, keep_order=true)


zs = [pi/2, 3pi/2]


choices = [q"sin(zs)", q"sin.(zs)", q"sin(.zs)", q".sin(zs)"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
q"sqrt(zs)",
q"sqrt.(zs)",
q"zs^(1/2)",
q"zs^(1./2)"
]
ans = 2
radioq(choices, ans, keep_order=true)

