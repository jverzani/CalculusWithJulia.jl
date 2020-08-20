
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots; gr()
using LinearAlgebra
nothing


using CalculusWithJulia
u, v = [1, 2, 3], [4, 3, 2]


u + v


2 * u


using Plots
gr()       # better arrows than plotly()
quiver([0],[0], quiver=([1],[2]))


unzip(vs) = Tuple(eltype(first(vs))[xyz[j] for xyz in vs] for j in eachindex(first(vs)))


u = [1, 2]
v = [4, 2]
w = u + v
p = [0,0]
quiver(unzip([p])..., quiver=unzip([u]))
quiver!(unzip([u])..., quiver=unzip([v]))
quiver!(unzip([p])..., quiver=unzip([w]))


plot(legend=false)
arrow!(p, u)
arrow!(u, v)
arrow!(p, w)


using LinearAlgebra
v = [2, 3]
u = v / norm(v)
p = [0, 0]
plot(legend=false)
arrow!(p, v)
arrow!(p, u, linewidth=5)


f(x,y,z) = x^2 + y^2 + z^2
f(v) = v[1]^2 + v[2]^2 + v[3]^2


g(x,y,z) =  x^2 + y^2 + z^2
g(v) = g(v...)


xs = ys = [0, 1]
f(x,y) = x + y
f.(xs, ys)


xs = [0, 1]; ys = [0 1]  # xs is a column vector, ys a row vector
f.(xs, ys)


u = [1, 2]
v = [2, 1]
dot(u, v)


u ⋅ v   # u \cdot[tab] v


ctheta = dot(u/norm(u), v/norm(v))
acos(ctheta)


u = [1, 2]
v = [2, -1]
u ⋅ v


u = [1, 2, 3, 4, 5]
v = [-30, 4, 3, 2, 1]
u ⋅ v


h = [2, 3]
a = [1, 0]  # unit vector
h_hat = h / norm(h)
theta = acos(h_hat ⋅ a)

plot(legend=false)
arrow!([0,0], h)
arrow!([0,0], norm(h) * cos(theta) * a)
arrow!([0,0], a, linewidth=3)


theta = pi/12
mass, gravity = 1/9.8, 9.8

l = [-sin(theta), cos(theta)]
p = -l
Fg = [0, -mass*gravity]
plot(legend=false)
arrow!(p, l)
arrow!(p, Fg)
scatter!(p[1:1], p[2:2], markersize=5)


plot(legend=false, aspect_ratio=:equal)
arrow!(p, l)
arrow!(p, Fg)
scatter!(p[1:1], p[2:2], markersize=5)

proj = (Fg ⋅ l) / (l ⋅ l) * l   # force of gravity in direction of tension
porth = Fg - proj              # force of gravity perpendicular to tension

arrow!(p, proj)
arrow!(p, porth, linewidth=3)


u = [1, 2, 3]
v = [1, 1, 2]
w = [1, 2, 4]


unit_vec(u) = u / norm(u)
projection(u, v) = (u ⋅ unit_vec(v)) * unit_vec(v)

vorth = v - projection(v, u)
worth = w - projection(w, u) - projection(w, vorth)


u ⋅ vorth, u ⋅ worth, vorth ⋅ worth


M = [3 4 -5; 5 -5 7; -3 6 9]


b = [10, 11, 12]   # not b = [10 11 12], which would a row vector.


using SymPy
@vars x1 x2 x3
x = [x1, x2, x3]


u = [10, 11, 12]
v = [13, 14, 15]
[u v]   # horizontally combine


[u; v]


2 * M


M + M


M .+ 1


M * M


M * x - b


A = [symbols("A$i$j", real=true) for i in 1:3, j in 1:2]
B = [symbols("B$i$j", real=true) for i in 1:2, j in 1:2]


A*B


[ (A*B)[i,j] == A[i,:] ⋅ B[:,j] for i in 1:3, j in 1:2]


M .* M   # component wise (Hadamard product)


using LinearAlgebra  # loaded with the CalculusWithJulia package
det(M)


transpose(M)


M'


[u' v']   # [u v] was a 3 × 2 matrix, above


[u'; v']


note("""
The adjoint is defined *recursively* in `Julia`. In the `CalculusWithJulia` package, we overload the '\'' notation for *functions* to yield a univariate derivative found with automatic differentiation. This can lead to problems: if we have a matrix of functions, `M`, and took the transpose with `M'`, then the entries of `M'` would be the derivatives of the functions in `M` - not the original functions. This is very much likely to not be what is desired. The `CalculusWithJulia` package commits **type piracy** here *and* abuses the generic idea for '\'' in Julia. In general type piracy is very much frowned upon, as it can change expected behaviour. It is defined in `CalculusWithJulia`, as that package is intended only to act as a means to ease users into the wider package ecosystem of `Julia`.
""")


u, v = [1,1,2], [3,5,8]
u' * v   # a scalar


reshape(u,(1,3)) * v


note("""
The right-hand rule is also useful to understand how standard household screws will behave when twisted with a screwdriver. If the right hand fingers curl in the direction of the twisting screwdriver, then the screw will go in or out following the direction pointed to by the thumb.
""")


a = [1, 2, 3]
b = [4, 2, 1]
cross(a, b)


a × b


b × a


[1, 2] × [3, 4]


using SymPy, LinearAlgebra  # already loaded with the CalculusWithJulia package
@vars i j k
M = [i j k; 3 4 5; 3 6 7]
det(M) |> simplify


M[2,:] × M[3,:]


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


norm(v) * norm(porth)


u = [1, 2, 0]
v = [2, 1, 0]
norm(u × v)


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


note(L"""
The triple-scalar product, $\vec{u}\cdot(\vec{v}\times\vec{w})$, gives the volume of the parallelepiped up to sign. If the sign of this is positive, the 3 vectors are said to have a *positive* orientation, if they triple-scalar product is negative, the vectors have a *negative* orientation.
""")


@vars s t u1 u2 u3 v1 v2 v3 w1 w2 w3 real=true
u = [u1, u2, u3]
v = [v1, v2, v3]
w = [w1, w2, w3]

u ⋅ (s*v + t*w) - (s*(u⋅v) + t*(u⋅w)) |> simplify


(u ⋅ v) - (v ⋅ u) |> simplify


u × (s*v + t*w) - (s*(u×v) + t*(u×w)) .|> simplify


u × v + v × u .|> simplify


u × (v × w) - (u × v) × w .|> simplify


(u × v) × w - ( (u ⋅ w) * v - (v ⋅ w) * u) .|> simplify


@vars a b c x y t

eq = c - (a*x + b*y)

p = [0, c/b]
v = [-b, a]
li = p + t * v

eq(x=>li[1], y=>li[2]) |> simplify


@vars d z s

eq = d - (a*x + b*y + c * z)

p = [0, 0, d/c]
u, v = [-b, a, 0], [0, c, -b]
pl = p + t * u + s * v

subs(eq, x=>pl[1], y=>pl[2], z=>pl[3]) |> simplify


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


u, v, p = [6,3,1], [3,2,1], [1,1,2]
n = u × v
a, b, c = n
d = n ⋅ p
"equation of plane: $a x + $b y + $c z = $d"


u,v,w = [1,2,3], [4,3,2], [5,2,1]
numericq(dot(u,v))


ans = dot(v,w) == 0
yesnoq(ans)


ctheta = (u ⋅ w)/norm(u)/norm(w)
val = acos(ctheta)
numericq(val)


choices = [
"`[-5, 10, -5]`",
"`[-1, 6, -7]`",
"`[-4, 14, -8]`"
]
ans = 1
radioq(choices, ans)


val = norm(v  × w)
numericq(val)


val = abs((u × v) ⋅ w)
numericq(val)


u,v = [1,2,3], [5,4,2]
sum(prod.(zip(u,v)))


yesnoq(true)


choices = [
"An object of type `Base.Iterators.Zip` that is only realized when used",
"A vector of values `[(1, 5), (2, 4), (3, 2)]`"
]
ans = 1
radioq(choices, ans)


choices = [
"A vector of values `[5, 8, 6]`",
"An object of type `Base.Iterators.Zip` that when realized will produce a vector of values"
]
ans = 1
radioq(choices, ans)


choices = [
L"1",
L"0",
"Can't say in general"
]
ans = 1
radioq(choices, ans)


u,v = [1,2,3], [3,2,1]
val = (u ⋅ v)/norm(v)
numericq(val)


choices = [
L"-4x + 8y - 4z = 0",
L"x + 2y + z = 0",
L"x + 2y + 3z = 6"
]
ans = 1
radioq(choices, ans)


choices = [
L"$\vec{v}$ is in plane $P_1$, as it is orthogonal to $\vec{n}_1$ and $P_2$ as it is orthogonal to $\vec{n}_2$, hence it is parallel to both planes.",
L"$\vec{n}_1$ and $\vec{n_2}$ are unit vectors, so the cross product gives the projection, which must be orthogonal to each vector, hence in the intersection"
]
ans = 1
radioq(choices, ans)


choices = [
L"\vec{0}",
L"\langle 12, 12 \rangle",
L"12 \langle 1, 0 \rangle"
]
ans = 1
radioq(choices, ans)


choices = [
L"\langle -1, 0 \rangle",
L"\langle 1, 0 \rangle",
L"\langle 11, 11 \rangle"
]
ans = 1
radioq(choices, ans)


choices = [
L"1 + \vec{u}\cdot\vec{v}",
L"\vec{u} + \vec{v}",
L"\vec{u}\cdot\vec{v} + \vec{v}\cdot \vec{v}"
]
ans = 1
radioq(choices, ans)


choices = [
L"The angle they make with $\vec{w}$ is the same",
L"The vector $\vec{w}$ must also be a unit vector",
"the two are orthogonal"
]
ans=1
radioq(choices, ans)


choices = [
L"\vec{u}\cdot\vec{v} = 0",
L"\vec{u}\cdot\vec{v} = 2",
L"\vec{u}\cdot\vec{v} = -(\vec{u}\cdot\vec{u} \vec{v}\cdot\vec{v})"
]
ans = 1
radioq(choices, ans)


choices = [
"The triple product describes a volume up to sign, this combination preserves the sign",
"The vectors are *orthogonal*, so these are all zero",
"The vectors are all unit lengths, so these are all 1"
]
ans = 1
radioq(choices, ans)


gr()
f(t) = sin(t)
p = plot(ylim=(.2,1.5), xticks=nothing, yticks=nothing, border=:none, legend=false, aspect_ratio=:equal)
plot!(f, pi/6, pi/2, linewidth=4, color=:blue)
t0 = pi/3
p0 = [t0, f(t0)]
Normal = [f'(t0), -t0]
arrow!(p0, .5 * Normal, linewidth=4, color=:red )
incident = (Normal + [.5, 0]) * .5
arrow!(p0 - incident, incident, linewidth=4, color=:black)
out = -incident + [.1,0]
arrow!(p0, -out, linewidth=4, color=:black)
annotate!([(0.8, 1.0, L"\hat{v}_1"),
        (.6, .75, L"n_1"),
        (1.075, 0.7, L"\hat{N}"),
        (1.25, 0.7, L"\hat{v}_2"),
        (1.5, .75, L"n_2")
        ])

plotly()
p


choices = [
L"n_1 (\hat{v_1}\times\hat{N}) = n_2  (\hat{v_2}\times\hat{N})",
L"n_1 (\hat{v_1}\times\hat{N}) = -n_2  (\hat{v_2}\times\hat{N})"
]
ans = 1
radioq(choices, ans)


choices = [
L"\vec{0}",
L"\vec{a}",
L"\vec{a} + \vec{b} + \vec{c}"
]
ans = 1
radioq(choices, ans)

