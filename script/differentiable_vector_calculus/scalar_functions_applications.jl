
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


using SymPy
@vars f_x f_y
n = [1, 0, f_x] × [0, 1, f_y]


f(x,y) = 6 - x^2 -y^2
f(x)= f(x...)

a,b = 1, -1/2


# draw surface
xr = 7/4
xs = ys = range(-xr, xr, length=100)
surface(xs, ys, f, legend=false)

# visualize tangent plane as 3d polygon
pt = [a,b]
tplane(x) = f(pt) + gradient(f)(pt) ⋅ (x - [a,b])

pts = [[a-1,b-1], [a+1, b-1], [a+1, b+1], [a-1, b+1], [a-1, b-1]]
plot!(unzip([[pt..., tplane(pt)] for pt in pts])...)

# plot paths in x and y direction through (a,b)
γ_x(t) = pt + t*[1,0]
γ_y(t) = pt + t*[0,1]

plot_parametric_curve!(t -> [γ_x(t)..., (f∘γ_x)(t)], -xr-a, xr-a, linewidth=3)
plot_parametric_curve!(t -> [γ_y(t)..., (f∘γ_y)(t)], -xr-b, xr-b, linewidth=3)

# draw directional derivatives in 3d and normal
pt = [a, b, f(a,b)]
fx, fy = gradient(f)(a,b)
arrow!(pt, [1, 0, fx], linewidth=3)
arrow!(pt, [0, 1, fy], linewidth=3)
arrow!(pt, [-fx, -fy, 1], linewidth=3) # normal

# draw point in base, x-y, plane
pt = [a, b, 0]
scatter!(unzip([pt])...)
arrow!(pt, [1,0,0], linestyle=:dash)
arrow!(pt, [0,1,0], linestyle=:dash)


function tangent_plane(f, pt)
  fx, fy = ForwardDiff.gradient(f, pt)
  x -> f(x...) + fx * (x[1]-pt[1]) + fy * (x[2]-pt[2])
end


function tangent_plane(f, pt)
  ∇f = ForwardDiff.gradient(f, pt) # using a variable ∇f
  x -> f(pt) + ∇f ⋅ (x - pt)
end


@vars x y
vars = [x, y]
f(x,y) = sin(x) * cos(x-y)
f(x) = f(x...)

gradf = diff.(f(x,y), vars)  # or use gradient(f, vars) or ∇((f,vars))

pt = [PI/4, PI/3]
gradfa = subs.(gradf, x.=>pt[1], y.=>pt[2])

f(pt) + gradfa ⋅ (vars - pt)


a = 1
gamma(t) = a * [1 + cos(t), sin(t), 2sin(t/2) ]
P = gamma(1/2)
n1(x,y,z)= [2*(x-a), 2y, 0]
n2(x,y,z) = [2x,2y,2z]
n1(x) = n1(x...)
n2(x) = n2(x...)

t = 1/2
(n1(gamma(t)) × n2(gamma(t))) × gamma'(t)


import Contour # installed with the Plots package, so should be available
               # import -- not using -- to avoid name collision
function plot_implicit_surface(F, c=0;
                       xlim=(-5,5), ylim=xlim, zlim=xlim,
                       nlevels=25,         # number of levels in a direction
                       slices=Dict(:z => :blue), # Dict(:x => :color, :y=>:color, :z=>:color)
                       kwargs...          # passed to initial `plot` call
                       )

    _linspace(rng, n=150) = range(rng[1], stop=rng[2], length=n)

    X1, Y1, Z1 = _linspace(xlim), _linspace(ylim), _linspace(zlim)

    p = Plots.plot(;legend=false,kwargs...)

    if :x ∈ keys(slices)
        for x in _linspace(xlim, nlevels)
            local X1 = [F(x,y,z) for y in Y1, z in Z1]
            cnt = Contour.contours(Y1,Z1,X1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                ys, zs = Contour.coordinates(line) # coordinates of this line segment
                plot!(p, x .+ 0 * ys, ys, zs, color=slices[:x])
          end
        end
    end

    if :y ∈ keys(slices)
        for y in _linspace(ylim, nlevels)
            local Y1 = [F(x,y,z) for x in X1, z in Z1]
            cnt = Contour.contours(Z1,X1,Y1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                xs, zs = Contour.coordinates(line) # coordinates of this line segment
                plot!(p, xs, y .+ 0 * xs, zs, color=slices[:y])
            end
        end
    end

    if :z ∈ keys(slices)
        for z in _linspace(zlim, nlevels)
            local Z1 = [F(x, y, z) for x in X1, y in Y1]
            cnt = Contour.contours(X1, Y1, Z1, [c])
            for line in Contour.lines(Contour.levels(cnt)[1])
                xs, ys = Contour.coordinates(line) # coordinates of this line segment
                plot!(p, xs, ys, z .+ 0 * xs, color=slices[:z])
            end
        end
    end


    p
end


a,b = 1,3
f(x,y,z) = (x^2+((1+b)*y)^2+z^2-1)^3-x^2*z^3-a*y^2*z^3

plot_implicit_surface(f, xlim=(-2,2), ylim=(-1,1), zlim=(-1,2))


V(r, h) = pi * r^2 * h
V(v) = V(v...)
a = [1,2]
dx = [0.01, 0.01]
ForwardDiff.gradient(V, a) ⋅ dx   # or use ∇(V)(a)


V(a + dx) - V(a)


f(x,y,z) = x^4 -x^3 + y^2 + z^2
a, b,c = ∇(f)(2,2,2)
"$a x + $b y  + $c z = $([a,b,c] ⋅ [2,2,2])"


@vars a b c d u v
M = [a b; c d]
B = [u, v]
M \ B .|> simplify


import Contour: contours, levels, level, lines, coordinates


f(x,y) = 2 - x^2 - y^2
g(x,y) = 3 - 2x^2 - (1/3)y^2
xs = ys = range(-3, stop=3, length=100)
zfs = [f(x,y) for x in xs, y in ys]
zgs = [g(x,y) for x in xs, y in ys]


ps = Any[]
pf = surface(xs, ys, f, alpha=0.5, legend=false)

for cl in levels(contours(xs, ys, zfs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pf, _xs, _ys, 0*_xs, linewidth=3, color=:blue)
    end
end


pg = surface(xs, ys, g, alpha=0.5, legend=false)
for cl in levels(contours(xs, ys, zgs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pg, _xs, _ys, 0*_xs, linewidth=3, color=:red)
    end
end

pcnt = plot(legend=false)
for cl in levels(contours(xs, ys, zfs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pcnt, _xs, _ys, linewidth=3, color=:blue)
    end
end

for cl in levels(contours(xs, ys, zgs, [0.0]))
    for line in lines(cl)
        _xs, _ys = coordinates(line)
        plot!(pcnt, _xs, _ys, linewidth=3, color=:red)
    end
end

l = @layout([a b c])
plot(pf, pg, pcnt, layout=l)


function newton_step(f, g, xn)
    M = [ForwardDiff.gradient(f, xn)'; ForwardDiff.gradient(g, xn)']
    b = -[f(xn), g(xn)]
    Delta = M \ b
    xn + Delta
end


f(x,y) = 2 - x^2 - y^2
g(x,y) = 3 - 2x^2 - (1/3)y^2
f(v) = f(v...); g(v) = g(v...)
x0 = [1,1]
x1 = newton_step(f, g, x0)


f(x1), g(x1)


x2 = newton_step(f, g, x1)
x3 = newton_step(f, g, x2)
x4 = newton_step(f, g, x3)
x5 = newton_step(f, g, x4)
x5, f(x5), g(x5)


function nm(f, g, x, n=5)
    for i in 1:n
      x = newton_step(f, g, x)
    end
    x
end


c = 1/2
f(x,y) = 1 - y^2 - c^2
g(x,y) = (1 - x^2) - c^2
f(v) = f(v...); g(v) = g(v...)
nm(f, g, [1/2, 1/3])


Z = SymFunction("Z")
@vars x y
solve(diff(x^4 -x^3 + y^2 + Z(x,y)^2, x), diff(Z(x,y),x))


Z = SymFunction("Z")
@vars x y
solve(diff(x^4 -x^3 + y^2 + Z(x,y)^2, y), diff(Z(x,y),y))


plotly()


f(x,y)= exp(-(x^2 + y^2)/5) * cos(x^2 + y^2)
xs = ys = range(-4, 4, length=100)
surface(xs, ys, f, legend=false)


f(x,y) = x*y
xs = ys = range(-3, 3, length=100)
surface(xs, ys, f, legend=false)

plot_parametric_curve!(t -> [t, 0, f(t, 0)], -4, 4, linewidth=5)
plot_parametric_curve!(t -> [0, t, f(0, t)], -4, 4, linewidth=5)


f(x,y) =  exp(-(x^2 + y^2)/5) * cos(x^2 + y^2)
@vars x y
H = sympy.hessian(f(x,y), [x,y])


H_00 = subs.(H, x.=>0, y.=>0)


H_00[1,1] < 0 && det(H_00) > 0


gradf = gradient(f(x,y), [x,y])
a = [sqrt(2PI + atan(-Sym(1)//5)), 0]
subs.(gradf, x.=> a[1], y.=> a[2])


a = [sqrt(PI + atan(-Sym(1)//5)), 0]
H_a = subs.(H, x.=> a[1], y.=> a[2])
det(H_a)


@vars x y real=true
f(x,y) = 4x*y - x^4 - y^4
gradf = gradient(f(x,y), [x,y])


pts = solve(gradf, [x,y])


H = sympy.hessian(f(x,y), [x,y])
function classify(H, pt)
  Ha = subs.(H, x .=> pt[1], y .=> pt[2])
  (det=det(Ha), f_xx=Ha[1,1])
end
[classify(H, pt) for pt in pts]


xs = ys = range(-3/2, 3/2, length=100)
surface(xs, ys, f, legend=false)
scatter!(unzip([N.([pt...,f(pt...)]) for pt in pts])...)  # add each pt on surface


f(x,y) = x^2 + 2y^2 - x
f(v) = f(v...)
gamma(t) = [cos(t), sin(t)]  # traces out x^2 + y^2 = 1 over [0, 2pi]
g(t) = f(gamma(t))

using Roots
cps = fzeros(g', 0, 2pi) # critical points of g
append!(cps, [0, 2pi])
unique!(cps)
g.(cps)


inds = [2,4]
cps = cps[inds]


cps/pi


f(x,y) = x^2 + 2y^2 - x
h(x,y) = f(x,y) * (x^2 + y^2 <= 1 ? 1 : NaN)
xs = ys = range(-1,1, length=100)
surface(xs, ys, h)

ts = cps  # 2pi/3 and 4pi/3 by above
xs, ys = cos.(ts), sin.(ts)
zs = f.(xs, ys)
scatter!(xs, ys, zs)


h(x,y) = f(x,y) * (x^2 + y^2 <= 1 ? 1 : NaN)
xs = ys = range(-1,1, length=100)
contour(xs, ys, h)


@vars x y x1 y1 x2 y2 x3 y3
d2(p,x) = (p[1] - x[1])^2 + (p[2]-x[2])^2
d2_1, d2_2, d2_3 = d2((x,y), (x1, y1)), d2((x,y), (x2, y2)), d2((x,y), (x3, y3))
ex = d2_1 + d2_2 + d2_3


gradf = diff.(ex, [x,y])
xstar = solve(gradf, [x,y])


H = subs.(hessian(ex, [x,y]), x.=>xstar[x], y.=>xstar[y])


gr()


us = [[cos(t), sin(t)] for t in (0, 2pi/3, 4pi/3)]
polygon(ps) = unzip(vcat(ps, ps[1:1])) # easier way to plot a polygon

p = scatter([0],[0], markersize=2, legend=false, aspect_ratio=:equal)

as = (1,2,3)
plot!(p, polygon([a*u for (a,u) in zip(as, us)])...)
[arrow!([0,0], a*u, alpha=0.5) for (a,u) in zip(as, us)]
p


as = (1, -1, 3)
p = scatter([0],[0], markersize=2, legend=false)
p1, p2, p3 = ps = [a*u for (a,u) in zip(as, us)]
plot!(p, polygon(ps)...)
p


function polygon(ps)
    unzip(vcat(ps, ps[1:1]))
end

euclid_dist(x) = sum(norm(x-p) for p in ps)
euclid_dist(x,y) = euclid_dist([x,y])
xs = range(-1.5, 1.5, length=100)
ys = range(-3, 1.0, length=100)

p = plot(polygon(ps)..., linewidth=3, legend=false)
scatter!(p, unzip(ps)..., markersize=3)
contour!(p, xs, ys, euclid_dist)

# add some gradients along boundary
li(t, p1, p2) = p1 + t*(p2-p1)  # t in [0,1]
for t in range(1/100, 1/2, length=3)
    pt = li(t, p2, p3)
    arrow!(pt, ForwardDiff.gradient(euclid_dist, pt))
    pt = li(t, p2, p1)
    arrow!(pt, ForwardDiff.gradient(euclid_dist, pt))
end

p


p = plot(legend=false)
for i in 1:2, j in (i+1):3
  plot!(p, t -> euclid_dist(li(t, ps[i], ps[j])), 0, 1)
end
p


x1, x2, x3 = xs = Sym["x$i" for i in 1:3]
y1, y2, y3 = ys = Sym["y$i" for i in 1:3]
li(x, alpha, beta) =  alpha + beta * x
d2(alpha, beta) = sum((y - li(x, alpha, beta))^2 for (y,x) in zip(ys, xs))

@vars α β
d2(α, β)


grad_d2 = diff.(d2(α, β), [α, β])


out = solve(grad_d2, [α, β])


subs(out[β], x1 + x2 + x3 => 0)


[k => subs(v, x1=>1, y1=>1, x2=>2, y2=>3, x3=>5, y3=>8) for (k,v) in out]


f(x,y) = -exp(-((x-1)^2 + 2(y-1/2)^2))
f(x) = f(x...)

xs = [[0.0, 0.0]] # we store a vector
gammas = [1.0]

for n in 1:5
    xn = xs[end]
    gamma = gammas[end]
    xn1 = xn - gamma * gradient(f)(xn)
    dx, dy = xn1 - xn, gradient(f)(xn1) - gradient(f)(xn)
    gamman1 = abs( (dx ⋅ dy) / (dy ⋅ dy) )

    push!(xs, xn1)
    push!(gammas, gamman1)
end

[(x, f(x)) for x in xs]


import Contour: contours, levels, level, lines, coordinates

function surface_contour(xs, ys, f; offset=0)
  p = surface(xs, ys, f, legend=false, fillalpha=0.5)

  ## we add to the graphic p, then plot
  zs = [f(x,y) for x in xs, y in ys]  # reverse order for use with Contour package
  for cl in levels(contours(xs, ys, zs))
    lvl = level(cl) # the z-value of this contour level
    for line in lines(cl)
        _xs, _ys = coordinates(line) # coordinates of this line segment
        _zs = offset * _xs
        plot!(p, _xs, _ys, _zs, alpha=0.5)        # add curve on x-y plane
    end
  end
  p
end


offset = 0
us = vs = range(-1, 2, length=100)
surface_contour(vs, vs, f, offset=offset)
pts = [[pt..., offset] for pt in xs]
scatter!(unzip(pts)...)
plot!(unzip(pts)..., linewidth=3)


function peaks(x, y)
    z = 3 * (1 - x)^2 * exp(-x^2 - (y + 1)^2)
    z += -10 * (x / 5 - x^3 - y^5) * exp(-x^2 - y^2)
    z += -1/3 * exp(-(x+1)^2 - y^2)
    return z
end

xs = range(-3, stop=3, length=100)
ys = range(-2, stop=2, length=100)
surface(xs, ys, peaks)


contour(xs, ys, peaks)


function newton_step(f, x)
  M = ForwardDiff.hessian(f, x)
  b = ForwardDiff.gradient(f, x)
  x - M \ b
end


peaks(v) = peaks(v...)
x = [0, 1.5]
x = newton_step(peaks, x)
x = newton_step(peaks, x)
x = newton_step(peaks, x)
x, ForwardDiff.gradient(peaks, x)


H = ForwardDiff.hessian(peaks, x)


fxx = H[1,1]
d = det(H)
fxx, d


note(""" The `Optim.jl` package provides efficient implementations of these two numeric methods, and others. """)


gr()

g(x,y) = x^2 + 2y^2 -1
g(v) = g(v...)

xs = range(-3, 3, length=100)
ys = range(-1, 4, length=100)

p = plot(aspect_ratio=:equal, legend=false)
contour!(xs, ys, g, levels=[0])

gi(x) = sqrt(1/2*(1-x^2)) # solve for y in terms of x
pts = [[x, gi(x)] for x in (-3/4, -1/4, 1/4, 3/4)]

for pt in pts
  arrow!(pt, ForwardDiff.gradient(g, pt) )
end

p


r(t) = [cos(t), sin(t)/2]
plot_parametric_curve(r, pi/12, pi/3, legend=false, aspect_ratio=true, linewidth=3)
T(t) = -r'(t) / norm(r'(t))
No(t) = T'(t) / norm(T'(t))
t = pi/4
lambda=1/10
scatter!(unzip([r(t)])...)
arrow!(r(t), T(t)*lambda)
arrow!(r(t), No(t)* lambda)

f(x,y)= x^2 + y^2
f(v) = f(v...)
arrow!(r(t), lambda*ForwardDiff.gradient(f, r(t)))

xs = range(0.5,1, length=100)
ys = range(0.1, 0.5, length=100)
contour!(xs, ys, f)


r(t) = [cos(t), sin(t)/2]
plot_parametric_curve(r, -pi/6, pi/6, legend=false, aspect_ratio=true, linewidth=3)
T(t) = -r'(t) / norm(r'(t))
No(t) = T'(t) / norm(T'(t))
t = 0
lambda=1/10
scatter!(unzip([r(t)])...)
arrow!(r(t), T(t)*lambda)
arrow!(r(t), No(t)* lambda)

f(x,y)= x^2 + y^2
f(v) = f(v...)
arrow!(r(t), lambda*ForwardDiff.gradient(f, r(t)))

xs = range(0.5,1.5, length=100)
ys = range(-0.5, 0.5, length=100)
contour!(xs, ys, f,  levels = [.7, .85, 1, 1.15, 1.3])


@vars x y lambda
f(x, y) = x^2 - y^2
g(x, y) = x^2 + y^2
k = 1
L(x,y,lambda) = f(x,y) - lambda*(g(x,y) - k)
ds = solve(diff.(L(x,y,lambda), [x, y, lambda]))


[f(d[x], d[y]) for d in ds]


@vars x y z lambda1 lambda2
g1(x, y, z) = x^2 + y^2 - z^2
g2(x, y, z) = x - 2z - 3
f(x,y,z)= x^2 + y^2 + z^2
L(x,y,z,lambda1, lambda2) = f(x,y,z) - lambda1*(g1(x,y,z) - 0) - lambda2*(g2(x,y,z) - 0)

∇L = diff.(L(x,y,z,lambda1, lambda2), [x, y, z,lambda1, lambda2])


solve(subs.(∇L, lambda1 .=> 1))


out = solve(subs.(∇L, y .=> 0))


[f(d[x], 0, d[z]) for d in out]


struct MultiIndex
  alpha::Vector{Int}
  end
Base.show(io::IO, α::MultiIndex) = println(io, "α = ($(join(α.alpha, ", ")))")

## |α| = α_1 + ... + α_m
Base.length(α::MultiIndex) = sum(α.alpha)

## factorial(α) computes α!
Base.factorial(α::MultiIndex) = prod(factorial(Sym(a)) for a in α.alpha)

## x^α = x_1^α_1 * x_2^α^2 * ... * x_n^α_n
import Base: ^
^(x, α::MultiIndex) = prod(u^a for (u,a) in zip(x, α.alpha))

## ∂^α(ex) = ∂_1^α_1 ∘ ∂_2^α_2 ∘ ... ∘ ∂_n^α_n (ex)
partial(ex::SymPy.SymbolicObject, α::MultiIndex, vars=free_symbols(ex)) = diff(ex, zip(vars, α.alpha)...)


@vars w x y z
alpha = MultiIndex([1,2,1,3])
length(alpha)  # 1 + 2 + 1 + 3=7
[1,2,3,4]^alpha
ex = x^3 * cos(w*y*z)
partial(ex, alpha, [w,x,y,z])


struct MultiIndices
    n::Int
    k::Int
end

function Base.length(as::MultiIndices)
  n,k = as.n, as.k
  n == 1 && return 1
  sum(length(MultiIndices(n-1, j)) for j in 0:k)  # recursively identify length
end

function Base.iterate(alphas::MultiIndices)
    k, n = alphas.k, alphas.n
    n == 1 && return ([k],(0, MultiIndices(0,0), nothing))

    m = zeros(Int, n)
    m[1] = k
    betas = MultiIndices(n-1, 0)
    stb = iterate(betas)
    st = (k, MultiIndices(n-1, 0), stb)
    return (m, st)
end

function Base.iterate(alphas::MultiIndices, st)

    st == nothing && return nothing
    k,n = alphas.k, alphas.n
    k == 0 && return nothing
    n == 1 && return nothing

    # can we iterate the next on
    bk, bs, stb = st

    if stb==nothing
        bk = bk-1
        bk < 0 && return nothing
        bs = MultiIndices(bs.n, bs.k+1)
        val, stb = iterate(bs)
        return (vcat(bk,val), (bk, bs, stb))
    end

    resp = iterate(bs, stb)
    if resp == nothing
        bk = bk-1
        bk < 0 && return nothing
        bs = MultiIndices(bs.n, bs.k+1)
        val, stb = iterate(bs)
        return (vcat(bk, val), (bk, bs, stb))
    end

    val, stb = resp
    return (vcat(bk, val), (bk, bs, stb))

end


collect(MultiIndices(2, 3))


union((collect(MultiIndices(2, i)) for i in 0:3)...)


k = 4
length(MultiIndices(3, k+1))


F = SymFunction("F")
a = Sym["a$i" for i in 1:3]    # n=3
dx = Sym["dx$i" for i in 1:3]

sum(partial(F(a...), α, a) / factorial(α) * dx^α for k in 0:3 for α in MultiIndex.(MultiIndices(3, k)))  # 3rd order


f(x,y) = sqrt(x + y)
f(v) = f(v...)
pt = [2,2]
dxdy = [.1, .2]
val = f(pt) + dot(ForwardDiff.gradient(f, pt), dxdy)
numericq(val)


f(x,y,z) = x*y + y*z + z*x
f(v) = f(v...)
pt = [1,1,1]
dx = [0.1, 0.0, -0.1]
val = f(pt) + ∇(f)(pt) ⋅ dx
numericq(val)


f(x,y,z) = x*y + y*z + z*x - 8
f(v) = f(v...)
pt = [1,1,1]
n = ∇(f)(pt)
d = dot(n, pt)
choices = [L"x + y + z = 3",
L"2x + y - 2z = 1",
L"x + 2y + 3z = 6"
]
ans = 1
radioq(choices, ans)


choices = [L"\langle 2xy + y^2 + y, 2xy + x^2 + x\rangle",
L"y^2 + y, x^2 + x",
L"\langle 2y + y^2, 2x + x^2"
]
ans = 1
radioq(choices, ans)


yesnoq(true)


f(x,y) = x*y + x*y^2 + x^2 * y
f(v) = f(v...)
val = det(ForwardDiff.hessian(f, [-1/3, -1/3]))
numericq(val)


choices = [
L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
L"The function $f$ has a saddle point, as $d  < 0$",
L"Nothing can be said, as $d=0$"
]
ans = 2
radioq(choices, ans, keep_order=true)


f(x,y) = x + 2x^2 + x^3 + y + 2x*y + y^2
@vars x y real=true
gradf = gradient(f(x,y), [x,y])


yesnoq(true)


solve(gradf, [x,y])


numericq(2)


sympy.hessian(f(x,y), [x,y])


choices = [
L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
L"The function $f$ has a saddle point, as $d  < 0$",
L"Nothing can be said, as $d=0$",
L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
L"The function $f$ has a saddle point, as $d  < 0$",
L"Nothing can be said, as $d=0$",
L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"The function $f$ has a local minimum, as $f_{xx} > 0$ and $d >0$",
L"The function $f$ has a local maximum, as $f_{xx} < 0$ and $d >0$",
L"The function $f$ has a saddle point, as $d  < 0$",
L"Nothing can be said, as $d=0$",
L"The test does not apply, as $\nabla{f}$ is not $0$ at this point."
]
ans = 5
radioq(choices, ans, keep_order=true)


yesnoq(true)


yesnoq(false)


choices =[
"It is the determinant of the Hessian",
L"It isn't, $b^2-4ac$ is from the quadratic formula"
]
ans = 1
radioq(choices, ans)


choices = [
L"That $a>0$ and $ac-b^2 > 0$",
L"That $a<0$ and $ac-b^2 > 0$",
L"That $ac-b^2 < 0$"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"That $a>0$ and $ac-b^2 > 0$",
L"That $a<0$ and $ac-b^2 > 0$",
L"That $ac-b^2 < 0$"
]
ans = 3
radioq(choices, ans, keep_order=true)


yesnoq(true)


choices = [
L"\langle 2x, 2y\rangle",
L"\langle 2x, y^2\rangle",
L"\langle x^2, 2y \rangle"
]
ans = 1
radioq(choices, ans)


f(x,y) = exp(-x^2-y^2) * (2x^2 + y^2)
f(v) = f(v...)
r(t) = 3*[cos(t), sin(t)]
rat(x) = abs(x[1]/x[2]) - 1
fn = rat ∘ ∇(f) ∘ r
ts = fzeros(fn, 0, 2pi)


val = maximum((f∘r).(ts))
numericq(val)

