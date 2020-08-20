
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


function drawf!(p,f, m, dx)
    a,b = m-dx, m+dx
    xs = range(a,b,length=100)
    plot!(p, [a,a,b,b],[f(a),0,0,f(b)], color=:black, linewidth=2)
    plot!(p, xs, f.(xs), color=:blue, linewidth=3)
    p
end

a, b,n = 1/10,2, 10
dx = (b-a)/n
f(x) = x^x
xs = range(a-dx/2, b+dx/2, length=251)
ms = a:dx:b

using LaTeXStrings
p = plot(legend=false, xticks=nothing, yticks=nothing, border=:none, ylim=(-1/2, f(b)+1/2))
#plot!(p, xs, f.(xs), color=:blue, linewidth=3)
for m in ms
    drawf!(p, f, m, 0.9*dx/2)
end
annotate!([(ms[6]-dx/2,-0.3, L"x_{i-1}"), (ms[6]+dx/2,-0.3, L"x_{i}")])
p


gr()
using LaTeXStrings
_bar(x) = sum(x)/length(x)
_shrink(x, xbar, offset) = xbar + (1-offset/100)*(x-xbar)
function apoly!(plt::Plots.Plot, ps; offset=5, kwargs...)
    xs, ys = unzip(ps)
    xbar, ybar = _bar.((xs, ys))
    xs, ys = _shrink.(xs, xbar, offset), _shrink.(ys, ybar, offset)

    plot!(plt, xs, ys; kwargs...)
    xn = [xs[end],ys[end]]
    x0 = [xs[1], ys[1]]
    dxn = 0.95*(x0 - xn)

    arrow!(plt, xn, dxn; kwargs...)

    plt
end
apoly!(ps;offset=5,kwargs...) = apoly!(Plots.current(), ps; offset=offset, kwargs...)

a = 1
ps = [[0,a],[0,0],[a,0],[a,a]]
p = plot(; legend=false, aspect_ratio=:equal, xticks=nothing, yticks=nothing,  border=:none)
apoly!(p, ps, linewidth=3, color=:blue)
a = 1/2
ps = [[0,a],[0,0],[a,0],[a,a]]
del = 2/100
apoly!(p, ([del,del],) .+ ps, linewidth=3, color=:red, offset=20)
apoly!(p, ([0+del,a-del],) .+ ps, linewidth=3, color=:red, offset=20)
apoly!(p, ([a-del,0+del],) .+ ps, linewidth=3, color=:red, offset=20)
apoly!(p, ([a-del,a-del],) .+ ps, linewidth=3, color=:red, offset=20)

a = 1/4
ps = [[del,del]] .+ [[0,a],[0,0],[a,0],[a,a]]
del = 4/100
apoly!(p, ([del,del],) .+ ps, linewidth=3, color=:green, offset=40)
apoly!(p, ([0+del,a-del],) .+ ps, linewidth=3, color=:green, offset=40)
apoly!(p, ([a-del,0+del],) .+ ps, linewidth=3, color=:green, offset=40)
apoly!(p, ([a-del,a-del],) .+ ps, linewidth=3, color=:green, offset=40)

p


F(x,y) = [-y,x]
F(v) = F(v...)

r(t) = [a*cos(t),b*sin(t)]

@vars a b t positive=true
(1//2) * integrate( F(r(t)) ⋅ diff.(r(t),t), (t, 0, 2PI))


R(x,y) = [-y,x]
F(x,y) = R(x,y)/(R(x,y)⋅R(x,y))

@vars x y real=true
Fx, Fy = F(x,y)
diff(Fy, x) - diff(Fx, y) |> simplify


gr()
a, b = pi/2, 3pi/2
f(x) = sin(x)
p = plot(f, a, b, legend=false,  xticks=nothing,  border=:none, color=:green)
arrow!(p, [3pi/4, f(3pi/4)], 0.01*[1,cos(3pi/4)], color = :green)
arrow!(p, [5pi/4, f(5pi/4)], 0.01*[1,cos(5pi/4)], color = :green)
arrow!(p, [a,0], [0, f(a)], color=:red)
arrow!(p, [b, f(b)], [0, -f(b)], color=:blue)
arrow!(p, [b, 0], [a-b, 0], color=:black)
del = -0.1
annotate!(p, [(a,del, "a"), (b,-del,"b")])
p


a, b = 1, 2
theta = pi/48
alpha = asin(b/a*sin(theta))
f1(t) = b*[cos(t), sin(t)]
f2(t) = a*[cos(t), sin(t)]
yflip(x) = [x[1],-x[2]]
p = plot(unzip(f1, theta, 2pi-theta)..., legend=false, aspect_ratio=:equal, color=:blue)
plot!(p, unzip(f2, alpha, 2pi-alpha)..., color=:red)
arrow!(p, [0,2], [-.1,0], color=:blue)
arrow!(p, [0,1], [.1,0], color=:red)
arrow!(p, yflip(f1(theta)), yflip(f2(alpha)) - yflip(f1(theta)), color=:green)
arrow!(p, f2(alpha), f1(theta) - f2(alpha), color=:black)
p


## This isn't used
r4(t) = cos(2t) + sqrt(1.5^4 - sin(2t)^2)
ts = range(0, pi/2, length=100)
f(t) = r4(t) * [cos(t),sin(t)]
plot(unzip(f, 0, pi/2)..., xticks=nothing, yticks=nothing,  border=:none, legend=false, aspect_ratio=:equal)
t0 = pi/6
xs = f.(t0)
ys = f'.(t0)
plot!(unzip([f(t0)+1/5*ys, f(t0)-1/5*ys])..., color=:red)
arrow!(f(t0),1/5*xs, color=:red)
arrow!(f(t0), -1/10*[-ys[2],ys[1]], color=:black)
arrow!(f(t0),-1/5*xs, color=:red, linestyle=:dash)
arrow!(f(t0), 1/10*[-ys[2],ys[1]], color=:black, linestyle=:dash)


a = 1
ps = [[0,a],[0,0],[a,0],[a,a]]
p = plot(; legend=false, aspect_ratio=:equal, xticks=nothing,  border=:none, yticks=nothing)
apoly!(p, ps, linewidth=3, color=:blue)
apoly!(p, ([1,0],) .+ ps, linewidth=3, color=:red)
pt = [1, 1/4]
scatter!(unzip([pt])..., markersize=4, color=:green)
arrow!(pt, [1/2,1/4], linewidth=3, color=:green)
arrow!(pt, [1/4,0], color=:blue )
arrow!(pt, -[1/4, 0], color=:red)
annotate!([(7/8, 1/8, "A"), (1+7/8, 1/8, "B")])
p


# arrow square
# start 1,2,3,4: 1 upper left, 2 lower left
function cpoly!(p, c, r, st=1, orient=:ccw; linewidth=1,linealpha=1.0, color=[:red,:red,:red,:black])

    ps = [[-1,1], [1,1],[1,-1],[-1,-1]]
    if orient == :ccw
        ps = [[-1,1],[-1,-1],[1,-1],[1,1]]
    end
    k = 1
    for i in st:(st+2)
        plot!(p, unzip([c+r*ps[mod1(i,4)], c+r*ps[mod1(i+1,4)]])..., linewidth=linewidth, linealpha=linealpha, color=color[mod1(k,length(color))])
        k = k+1
    end
        i = mod1(st+3,4)
        j = mod1(i+1, 4)
        arrow!(p, c+r*ps[i], 0.95*r*(ps[j]-ps[i]), linewidth=linewidth, linealpha= linealpha, color=color[mod1(k,length(color))])
    p
end

p = plot( legend=false, xticks=nothing, yticks=nothing,  border=:none)
for i in 1:8

    for j in 1:8
        color = repeat([:red],4)
        st = 1
        if i == 1
            color[1] = :black
            st = 2
        elseif i==8
            color[3] = :black
            st = 4
        end
        if j == 1
            color[2] = :black
            st = 3
        elseif j == 8
            color[4] = :black
            st = 1
        end
    cpoly!(p, [i-1/2, j-1/2], .8*1/2,1, :ccw, linewidth=3,linealpha=0.5, color=color)
    end
end
p


n = 2
f(r,theta) = r^n * cos(n*theta)
g(r, theta) = r^n * sin(n*theta)

f(v) = f(v...); g(v)= g(v...)

Φ(x,y) = [sqrt(x^2 + y^2), atan(y,x)]
Φ(v) = Φ(v...)

xs = ys = range(-2,2, length=50)
contour(xs, ys, f∘Φ, color=:red, legend=false, aspect_ratio=:equal)
contour!(xs, ys, g∘Φ, color=:blue, linewidth=3)


# https://en.wikipedia.org/wiki/Jiffy_Pop#/media/File:JiffyPop.jpg
imgfile ="figures/jiffy-pop.png"
caption ="""
The Jiffy Pop popcorn design has a top surface that is designed to expand to accommodate the popped popcorn. Viewed as a surface, the surface area grows, but the boundary - where the surface meets the pan - stays the same. This is an example that many different surfaces can have the same bounding curve. Stokes' theorem will relate a surface integral over the surface to a line integral about the bounding curve.
"""
ImageFile(imgfile, caption)


@vars x y z real=true
F(x,y,z) = [x^2, 0, y^2]
CurlF = curl(F(x,y,z), [x,y,z])


@vars t real=true
r(t) = [cos(t), 0, sin(t)]
rp = diff.(r(t), t)
integrand = F(r(t)...) ⋅ rp


integrate(integrand, (t, 0, 2PI))


F(x,y,z) = [y*z^2, x*z^2, 2*x*y*z]
@vars x y z real=true
curl(F(x,y,z), [x,y,z])


@vars x y z t
Fxyz = ∇(x*y^2*z^3)
r(t) = [cos(t), sin(t), 0]
rp = diff.(r(t), t)
Ft = subs.(Fxyz, x .=> r(t)[1], y.=> r(t)[2], z .=> r(t)[3])
integrate(Ft ⋅ rp, (t, 0, 2PI))


r(t) = [0, cos(t), sin(t)]
rp = diff.(r(t), t)
Ft = subs.(Fxyz, x .=> r(t)[1], y.=> r(t)[2], z .=> r(t)[3])
integrate(Ft ⋅ rp, (t, 0, 2PI))


F(x,y,z) = [x*y, y*z, z*x]
@vars x y z real=true
DivF = divergence(F(x,y,z), [x,y,z])
integrate(DivF, (x, -1,1), (y,-1,1), (z, -1,1))


Nhat = [1,0,0]
integrate((F(x,y,z) ⋅ Nhat), (y, -1, 1), (z, -1,1)) # at x=1


@vars x y z real=true
R(x,y,z) = norm([x,y,z])
T(x,y,z) = log(1/R(x,y,z))
HeatFlow = -diff.(T(x,y,z), [x,y,z])


DivF = divergence(HeatFlow, [x,y,z]) |> simplify


@vars rho rho_0 phi theta real=true
Jac = rho^2 * sin(phi)
integrate(1/rho^2 * Jac, (rho, 0, rho_0), (theta, 0, 2PI), (phi, 0, PI))


R(x,y,z) = [x,y,z]
F(x,y,z) = R(x,y,z) / norm(R(x,y,z))^3


@vars x y z real=true
divergence(F(x,y,z), [x,y,z]) |> simplify


choices = [
L"We must have $\text{curl}(F) = 1$",
L"We must have $\text{curl}(F) = 0$",
L"We must have $\text{curl}(F) = x$"
]
ans = 1
radioq(choices, ans)


val, err = quadgk(t -> (sin(t)*cos(t)* ForwardDiff.derivative(u->sin(u)^2, t)), 0, 2pi)
numericq(val)


choices = [
L"\int rd\theta",
L"(1/2) \int r d\theta",
L"\int r^2 d\theta",
L"(1/2) \int r^2d\theta"
]
ans=4
radioq(choices, ans)


r(t) = [cos(t)^3, sin(t)^3]
@vars x y t real=true
F(x,y) = [-y,x]/2
F_t = subs.(F(x,y), x.=>r(t)[1], y.=>r(t)[2])
Tangent = diff.(r(t),t)
integrate(F_t ⋅ Tangent, (t, 0, 2PI))
choices = [
L"3\pi/8",
L"\pi/4",
L"\pi/2"
]
ans = 1
radioq(choices, ans)


choices = [
L"0",
L"1",
L"2"
]
ans =1
radioq(choices, ans, keep_order=true)


choices = [
L"0",
L"1",
L"2"
]
ans =1
radioq(choices, ans, keep_order=true)


choices = [L"A",L"B",L"C",L"D"]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L"-1",
L"0",
L"1"
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"0",
L"1",
L"2"
]
ans =1
radioq(choices, ans, keep_order=true)


choices = [
L"They are the same, as Green's theorem applies to the area, $S$, between $C_1$ and $C_2$ so $\iint_S \nabla\cdot{F}dA = 0$."
L"They  differ by a minus sign, as Green's theorem applies to the area, $S$, between $C_1$ and $C_2$ so $\iint_S \nabla\cdot{F}dA = 0$."
]
ans = 1
radioq(choices, ans)


choices = [
L"Also $2\pi$, as Green's theorem applies to the region formed by the square minus the circle and so the overall flow integral around the boundary is $0$, so the two will be the same.",
L"It is $-2\pi$, as Green's theorem applies to the region formed by the square minus the circle and so the overall flow integral around the boundary is $0$, so the two will have opposite signs, but the same magnitude."
]
ans = 1
radioq(choices, ans)


choices = [
L"4/3 \pi",
L"4\pi",
L"\pi"
]
ans = 1
radioq(choices, ans)


choices = [
L"1",
L"2",
L"3"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
L"\log(\rho)",
L"1/\rho",
L"\rho"
]
ans = 1
radioq(choices, ans)


choices = [
L"It is $0$, as, by Stoke's theorem, it is equivalent to $\iint_S (\nabla\times\nabla{\phi})dS = \iint_S 0 dS = 0$.",
L"It is $2\pi$, as this is the circumference of the unit circle"
]
ans = 1
radioq(choices, ans)


choices = [
L"2\pi",
L"2",
L"0"
]
ans = 1
radioq(choices, ans)


choices = [
"the field could be conservative or not. One must work harder to answer the question.",
"the field is *not* conservative.",
"the field *is* conservative"
]
ans=1
radioq(choices, ans)


choices = [
"Zero, by the vanishing properties of these operations",
"The maximum number in a row",
"The row number plus 1"
]
ans = 1
radioq(choices, ans)


choices = [
"Green's theorem",
"The divergence (Gauss') theorem",
"Stokes' theorem"
]
ans = 1
radioq(choices, ans, keep_order=true)

