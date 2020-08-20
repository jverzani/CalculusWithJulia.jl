
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
using LaTeXStrings
nothing


using CalculusWithJulia
using Plots


imgfile = "figures/chrysler-building-in-new-york.jpg"
caption = """How to estimate the volume contained within the Chrysler Building? One way might be to break the building up into tall vertical blocks based on its skyline;  compute the volume of each block using the formula of volume as area of the base times the height; and, finally, adding up the computed volumes This is the basic idea of finding volumes under surfaces using Riemann integration."""
ImageFile(imgfile, caption)


imgfile ="figures/chrysler-nano-block.png"
caption = """
Computing the volume of a nano-block construction of the Chrysler building is easier than trying to find an actual tree at the Chrysler building, as we can easily compute the volume of columns of equal-sized blocks. Riemann sums are similar.
"""

ImageFile(imgfile, caption)


using HCubature  # loaded by CalculusWithJulia

f(x,y) = x^2 + 5y^2
f(v) = f(v...)  # f accepts a vector
a0, b0 = 0, 1
a1, b1 = 0, 2
hcubature(f, (a0, a1), (b0, b1))


f(x,y) = 3
f(v) = f(v...)
a0, b0 = 0, 4
a1, b1 = 0, 5  # R is area 20, so V = 60 = 3 ⋅ 20
hcubature(f, (a0, a1), (b0, b1))


f(x,y) = x
f(v) = f(v...)
a0, b0 = 0, 1
a1, b1 = 0, 1
hcubature(f, (a0, a1), (b0, b1))


d(x, y)  = sqrt(x^2 + y^2)
function l(x, y, a)
    theta = atan(y,x)
    atheta = abs(theta)
    if (pi/4 <= atheta < 3pi/4) # this is the y=a or y=-a case
        (a/2)/sin(atheta)
    else
        (a/2)/abs(cos(atheta))
    end
end


f(x,y,a,h) = h * (l(x,y,a) - d(x,y))/l(x,y,a)
a, height = 2, 3
f(v) = f(v[1],v[2], a, height)  # fix a and h


f(x,y) = f(x,y, a, height)
xs = ys = range(-1, 1, length=20)
surface(xs, ys, f)


hcubature(f, (-a/2, -a/2), (a/2, a/2))


function f(x,y, r)
    if x^2 + y^2 < r
        sqrt(z - x^2 + y^2)
    else
        0.0
    end
end


note("""
The `Quadrature` package provides a uniform interface for `QuadGK`, `HCubature`, and other numeric integration routines available in `Julia`.""")


function cassini(theta)
    a, b = .75, 1
    A = 1; B = -2a^2*cos(2theta)
    C = a^4 - b^4
    (-B - sqrt(B^2 - 4*A*C))/(2A)
end

polar_plot(r, a, b) = plot(t -> r(t)*cos(t), t->r(t)*sin(t), a, b, legend=false, linewidth=3)
p = polar_plot(cassini, 0, 8pi)
n=10
a1,b1 = -1, 1
a2, b2 = -2, 2
for a in range(a1, b1, length=n+1)
    for b in range(a2, b2, length=n+1)
        plot!(p, [a,a],[a2, b2], alpha=0.75)
        plot!(p, [a1,b1],[b,b], alpha=0.75)
    end
end
p


function cassini(theta)
    a, b = .75, 1
    A = 1; B = -2a^2*cos(2theta)
    C = a^4 - b^4
    (-B - sqrt(B^2 - 4*A*C))/(2A)
end

polar_plot(r, a, b) = plot(t -> r(t)*cos(t), t->r(t)*sin(t), a, b, legend=false, linewidth=3)
p = polar_plot(cassini, 0, 8pi)
n=10
a1,b1 = -1, 1
a2, b2 = -2, 2
for a in range(a1, b1, length=n+1)
    for b in range(a2, b2, length=n+1)
        plot!(p, [a,a],[a2, b2], alpha=0.75)
        plot!(p, [a1,b1],[b,b], alpha=0.75)
    end
end
p


imgfile ="figures/strang-slicing.png"
caption = L"""Figure 14.2 of Strang illustrating the slice when either $x$ is fixed or $y$ is fixed. The inner integral computes the shared area, the outer integral adds the areas up to compute volume."""

ImageFile(imgfile, caption)


integrate(f(x,y), (y, h(x), g(x)), (x, a, b))


@vars x y a height
8 * integrate(height * (1 - 2x/a), (y, 0, x), (x, 0, a/2))


@vars x y
integrate( y * sin(x^2), (x, y^2, 1), (y, 0, 1))


f(x, y) = x^2
h(x) = x^2
g(x) = 5
integrate(f(x,y), (y, h(x), g(x)), (x, -sqrt(Sym(5)), sqrt(Sym(5))))


f(x,y) = 6 - 3x - 4y
g(x) = sqrt(2^2 - x^2)
h(x) = -sqrt(2^2 - x^2)
(1//5) * integrate(f(x,y), (y, h(x), g(x)), (x, -2, 2))


g1(x) = (20 - 2x)/3
g2(x) = (10 - x)/3
plot(g1, 0, 20)
plot!(g2, 0, 20)


f(x,y) = 10 - x - y
h(x) = (10 - x)/3
g(x) = (20 - 3x)/3
integrate(f(x,y), (y, h(x), g(x)), (x, 0, 10))


rad(theta) = 1
plot(t -> rad(t)*cos(t), t -> rad(t)*sin(t), 0, pi/4, legend=false, linewidth=3)
plot!([0,cos(pi/4)], [0, sin(pi/4)], linewidth=3)
plot!([0, 1], [0, 0], linewidth=3)
plot!([cos(pi/4), cos(pi/4)], [0, sin(pi/4)], linewidth=3)


@vars x y real=true
r = 1 # if using r as a symbolic variable specify `positive=true`
f(x,y) = sqrt(r^2 - x^2)
16 * integrate(f(x,y), (x, y, sqrt(r^2-y^2)), (y, 0, r*cos(PI/4)))


f(x,y) = x*y
g(y) = sqrt(1 - y^2)
h(y) = y
integrate(f(x,y), (x, h(y), g(y)), (y, 0, sin(PI/4)))


f(x,y) = x^2 + y^2
g(x) = x  # solve x - y = 0 for y
h(x) = 0
A = integrate(f(x,y), (y, h(x), g(x)), (x, 0, 1))
B = integrate(Sym(1), (y, h(x), g(x)), (x, 0, 1))
A/B


rho(x,y) = x^2*y^2
g(x) = 2 - x^2
h(x) = -3 + 2x^2
a = sqrt(Sym(5))
integrate(rho(x,y), (y, h(x), g(x)), (x, -a, a))


integrate(cos(x^2), (y, 0, x), (x, 0, 1))


using QuadGK
struct FWrapper
    f
end
(F::FWrapper)(x) = F.f(x)

# adjust endpoints when expressed as a functions of outer variables
endpoints(ys,x) = ((f,x) -> isa(f, Function) ? f(x...) : f).(ys, Ref(x))

# integrate f(x) dx
fubini(f, xs) = quadgk(FWrapper(f), xs...)[1] # drop error estimate

# integrate int_a^b int_h(x)^g(y) f(x,y) dy dx
fubini(f, ys, xs) = fubini(x -> fubini(y -> f(x,y), endpoints(ys, x)), xs)

# integrate f(x,y,z) dz dy dx
fubini(f, zs, ys, xs) = fubini(x ->
    fubini(y ->
        fubini(z -> f(x,y,z),
            endpoints(zs, (x,y))),
        endpoints(ys,x)),
    xs)


f(x,y) = exp(-x^2 - 2y^2)
f(v) = f(v...)
hcubature(f, (0,0), (3,3))  # (a0, a1), (b0, b1)


fubini(f, (0,3), (0,3))     # (a1, b1), (a0, b0)


f(x,y) = 1
a = fubini(f, (x-> -sqrt(1-x^2), x-> sqrt(1-x^2)), (-1, 1))
a, a - pi   # answer and error


f(x,y) = sqrt(1 - x^2 - y^2)
a = 2 *fubini(f, (x-> -sqrt(1-x^2), x-> sqrt(1-x^2)), (-1, 1))
a, a - 4/3*pi


fubini((y,x) -> cos(x^2), (y -> y, 1), (0, 1))


sin(1)/2


@vars x y z a b c
f(x,y,z) = Sym(1)   # need to integrate a symbolic object in integrand or call `sympy.integrate`
integrate(f(x,y,z), (x, 0, a), (y, 0, b), (z, 0, c))


f(x,y,z) = Sym(1)
integrate(f(x,y,z), (z, 0, (1 - a*y)/b), (y, 0, 1/a), (x, 0, c))


@vars x y z a b c
f(x,y,z) = Sym(1)
integrate(f(x,y,z), (z, 0, (1 - a*x - b*y)/c), (y, 0, (1 - a*x)/b), (x, 0, 1/a))


imgfile ="figures/euler-rotation.png"
caption = "Figure from Katz showing rotation of Euler."
ImageFile(imgfile, caption)


G(u, v) = u * [cos(v), sin(v)]

G(v) = G(v...)
J(v) = ForwardDiff.jacobian(G, v)  # [∇g1', ∇g2']

n = 6
us = range(0, 1, length=3n)     # radius
vs = range(0, 2pi, length=3n)   # angle

plot(unzip(G.(us', vs))..., legend = false, aspect_ratio=:equal)  # plots constant u lines
plot!(unzip(G.(us, vs'))...)                                      # plots constant v lines

pt = [us[n],vs[n]]


arrow!(G(pt), J(pt)*[1,0], color=:blue)
arrow!(G(pt), J(pt)*[0,1], color=:blue)


function showG(G, a=1, b=1;a0=0, b0=0, an = 3, bn=3, n=5, lambda=1/2, k1=1, k2=1)

J(v) = ForwardDiff.jacobian(v -> G(v...), v)  # [∇g1', ∇g2']

us = range(0, a, length=an*n)     # radius
vs = range(0, b, length=bn*n)   # angle

p = plot(unzip(G.(us', vs))..., legend = false, aspect_ratio=:equal)  # plots constant u lines
plot!(p,unzip(G.(us, vs'))...)                                      # plots constant v lines

pt = [us[k1 * n],vs[k2*n]]
P, U, V = G(pt...), lambda * J(pt)*[1,0], lambda *  J(pt)*[0,1]
arrow!(P, U, color=:blue, linewidth=2)
arrow!(P+V, U, color=:red, linewidth=1)
arrow!(P, V, color=:blue, linewidth=2)
arrow!(P+U, V, color=:red, linewidth=1)
p
end


G(u,v) = [cosh(u)*cos(v), sinh(u)*sin(v)]
showG(G, 1, 2pi)


G(u,v) = v * [exp(u), exp(-u)]
showG(G, 1, 2pi, bn = 6, k2=4)


G(u,v) = [u^2 - v^2, u*v]
showG(G, 1, 1)


note(L"""

The term "functional determinant" is found for the value $\det(J_G)$, as is the notation $\partial(x_1, x_2, \dots x_n)/\partial(u_1, u_2, \dots, u_n)$.

""")


k = 2
G(u,v) = [k*u, v]
showG(G, 1, 1)


theta = pi/6
G(u,v) = [cos(theta)*u + sin(theta)*v, -sin(theta)*u + cos(theta)*v]
showG(G, 1, 1)


k = 2
G(u, v) = [u + 2v, v]
showG(G)


T(u, v, a, b) = [u+a, v+b]
G(u, v) = [-u, v]
@vars u v
a,b = 1//2, 0
x1, y1 = T(u,v, -a, -b)
x2, y2 = G(x1, y1)
x, y = T(x2, y2, a, b)


G(u,v) = [u,u*v]
showG(G, lambda=1/3)


@vars n m positive=true
f(x,y) = x^n*y^m
@vars x y
integrate(f(x,y), (y, 0, x), (x, 0, 1))


@vars u v
integrate(f(u, u*v)*u, (u,0,1), (v,0,1))


G1(u,v) = [u, u*v]
G1(v) = G1(v...)
G2(u,v) = [1-u, v]
G2(v) = G2(v...)
f(x,y) = x^2*y^3
f(v) = f(v...)
A = fubini((y,x) -> f(x,y), (0, x -> 1 - x), (0, 1))
B = hcubature(v -> (f∘G2∘G1)(v) * v[1] * 1, (0,0), (1, 1))
A, B[1], A - B[1]


@vars u v n
G(u,v) = v * [exp(u), exp(-u)]
Jac = G(u,v).jacobian([u,v])
f(x,y) = x^2 * y^3
f(v) = f(v...)
integrate(f(G(u,v)) * abs(det(Jac)), (u, -n, n), (v, 0, 1))


@vars r theta
x = r*cos(theta)
y = r*sin(theta)
rho(x,y) = x*y^2
integrate(x^2 * rho(x, y), (theta, -PI/2, PI/2), (r, 0, 1))


@vars x y u v alpha
f(x,y) = x^2
G(u,v) = [cos(alpha)*u - sin(alpha)*v, sin(alpha)*u + cos(alpha)*v]
Jac = det(G(u,v).jacobian([u,v])) |> simplify
integrate(f(G(u,v)...) * Jac , (u,  0, 1), (v, 0, 1))


@vars r theta
x = r*cos(theta)
integrate(x^2 * r, (r, 4, 5), (theta, 0, 2PI))


@vars r theta z a b
f(x,y,z) = x
x = r*cos(theta)
y = r*sin(theta)
Jac = r
integrate(f(x,y,z) * Jac, (z, 0, a - b*r), (r, 0, a/b), (theta, 0, 2PI))


@vars r theta z
f(x,y,z) = z
x = r*cos(theta)
y = r*sin(theta)
Jac = r
A = integrate(f(x,y,z) * Jac, (z, 0, a - b*r), (r, 0, a/b), (theta, 0, 2PI))
B = integrate(1 * Jac, (z, 0, a - b*r), (r, 0, a/b), (theta, 0, 2PI))
A, B, A/B


@vars r theta z real=true
integrate(1 * r, (z, -sqrt(4-r^2), sqrt(4-r^2)), (r, 0, 1), (theta, 0, 2PI))


@vars a
integrate(1 * r, (z, -sqrt(4-r^2), sqrt(4-r^2)), (r, 0, a), (theta,0, 2PI))


imgfile = "figures/spherical-coordinates.png"
caption = "Figure showing the parameterization by spherical coordinates. (Wikipedia)"

ImageFile(imgfile, caption)


@vars ρ theta phi
G(ρ, theta, phi) = ρ * [sin(phi)*cos(theta), sin(phi)*sin(theta), cos(phi)]
det(G(ρ, theta, phi).jacobian([ρ, theta, phi])) |> simplify |> abs


@vars u v w a b c
G(u,v,w) = [u*a, v*b, w*c]
det(G(u,v,w).jacobian([u,v,w]))


choices = [
L"Yes. As an inner integral $\int_{a^2}^{b_2} f(x,y) dy = f_1(x) \int_{a_2}^{b_2} f_2(y) dy$.",
"No."
]
ans = 1
radioq(choices, ans)


choices = [
L"Both $a$ and $b$",
L"Both $a$ and $c$",
L"Both $b$ and $c$"
]
ans = 2
radioq(choices, ans)


choices = [
L"Both $a$ and $b$",
L"Both $a$ and $c$",
L"Both $b$ and $c$"
]
ans = 1
radioq(choices, ans)


choices = [
L"\int_0^1 \int_0^{(1-x^3)^{1/3}} 1\cdot dy dx",
L"\int_0^1 \int_0^{(1-y^3)^{1/3}} 1\cdot dx dy",
L"\int_0^1 \int_0^{(1-y^3)^{1/3}} 1\cdot dy dx"
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"\int_0^b\int_{y/b}^{2-y/b} dx dy",
L"\int_0^2\int_0^{bx} dy dx",
L"\int_0^2 \int_0^{2b - bx} dy dx"
]
ans = 1
radioq(choices, ans)


choices = [
L"\int_a^b \int_0^{f(x)} dy dx",
L"\int_a^b \int_0^{f(x)} dx dy",
L"\int_0^{f(x)} \int_a^b dx dy"
]
ans = 1
radioq(choices, ans)


choices = [
L"G(u,v) = \langle u-v, u+v \rangle",
L"G(u,v) = \langle u^2-v^2, u^2+v^2 \rangle",
L"G(u,v) = \langle u-v, u \rangle"
]
ans = 1
radioq(choices, ans)


G(u,v) = [cosh(u)*cos(v), sinh(u)*sin(v)]
pt = [1,2]
val = det(ForwardDiff.jacobian(v -> G(v...), [1,2]))
numericq(val)


choices = [
L"\sin^{2}{\left (v \right )} \cosh^{2}{\left (u \right )} + \cos^{2}{\left (v \right )} \sinh^{2}{\left (u \right )}",
L"1",
L"\sinh(u)\cosh(v)"
]
ans = 1
radioq(choices, ans)


choices = [
L"It is $1$, as each is area preserving",
L"It is $r$, as the rotation uses polar coordinates",
L"It is $r^2 \sin(\phi)$, as the rotations use spherical coordinates"
]
ans = 1
radioq(choices, ans)


@vars r theta a b
x = r*cos(theta)
y = r*sin(theta)
A = integrate(r, (r, 0, a), (theta, 0, b))
B = integrate(x * r, (r, 0, a), (theta, 0, b))
C = integrate(y * r, (r, 0, a), (theta, 0, b))


choices = [
L"The area of $R$",
L"The value $\bar{x}$ of the centroid",
L"The value $\bar{y}$ of the centroid",
L"The moment of inertia of $R$ about the $x$ axis"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"The area of $R$",
L"The value $\bar{x}$ of the centroid",
L"The value $\bar{y}$ of the centroid",
L"The moment of inertia of $R$ about the $x$ axis"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"dtdv",
L"(1-2m^2)dt dv",
L"m\sqrt{1-m^2}dt^2+(1-2m^2)dtdv -m\sqrt{1-m^2}dv^2"
]
ans = 1
radioq(choices, ans)

