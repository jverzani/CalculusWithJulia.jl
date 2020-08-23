
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


using CalculusWithJulia
using Plots


gr()         # renders vectors better than plotly()


f(t) = [sin(t), 2*cos(t)]
g(t) = [sin(t), cos(t), t]
h(t) = [2, 3] + t * [1, 2]


h(2)


unzip(vs) = Tuple(eltype(first(vs))[xyz[j] for xyz in vs] for j in eachindex(first(vs)))


ts = range(0, 2pi, length=200)
plot(unzip(f.(ts))...)
arrow!([0, 0], f(1))


plotly()


ts = range(0, 6pi, length=200)
plot(unzip(g.(ts))...)
arrow!([0, 0, 0], g(2pi))


gr()


plot(unzip(g.(ts))..., camera=(0, 90))


ts = range(-2, 2, length=200)
plot(unzip(h.(ts))...)


plot_parametric_curve(h, -2, 2)


note("""
Defining plotting functions in `Julia` for `Plots` is facilitated by the `RecipesBase` package. There are two common choices: creating a new function for plotting, as is done with `plot_parametric_curve` and `plot_polar`; or creating a new type so that `plot` can dispatch to an appropriate plotting method. The latter would also be a reasonable choice, but wasn't taken here.
""")


a, ecc = 20, 3/4
f(t) = a*(1-ecc^2)/(1 + ecc*cos(t)) * [cos(t), sin(t)]
plot_parametric_curve(f, 0, 2pi, legend=false)
scatter!([0],[0], markersize=4)


circle!(P, R; kwargs...) = plot_parametric_curve!(t -> P + R*[cos(t), sin(t)], 0, 2pi;kwargs...)


function spiro(t; r=2, R=5, rho=0.8*r)

    cent(t) = (R-r) * [cos(t), sin(t)]

    p = plot(legend=false, aspect_ratio=:equal)
    circle!([0,0], R, color=:blue)
    circle!(cent(t), r, color=:black)

    tp(t) = -R/r * t

    s(t) = cent(t) + rho * [cos(tp(t)), sin(tp(t))]
    plot_parametric_curve!(s, 0, t, n=1000, color=:red)

    p
end


spiro(pi)


spiro(2pi)


spiro(4pi)


plotly()
M, m = 25, 5
height = 5
S, T = 8, 2
outer(t) = [M * sin(2pi*t/T), M * cos(2pi*t/T), height*(1 +sin(2pi * (t-pi/2)/T))]
inner(t) = [m * sin(2pi*t/S), m * cos(2pi*t/S), 0]
f(t) = outer(t) + inner(t)
plot_parametric_curve(f, 0, 8, n=1000)


gr()  # better arrows
f(t) = [3cos(t), 2sin(t)]
t, Deltat = pi/4, pi/16
df = f(t + Deltat) - f(t)

plot(legend=false)
arrow!([0,0], f(t))
arrow!([0,0], f(t+Deltat))
arrow!(f(t), df)


using ForwardDiff
D(f,n=1) = n > 1 ? D(D(f),n-1) : x -> ForwardDiff.derivative(f, float(x))
Base.adjoint(f::Function) = D(f)         # allow f' to compute derivative


f(t) = [3cos(t), 2sin(t)]
p = plot_parametric_curve(f, 0, 2pi, legend=false, aspect_ratio=:equal)
for t in [1,2,3]
    arrow!(f(t), f'(t))   # add arrow with tail on curve, in direction of derivative
end
p


using SymPy
@vars t
vvf = [cos(t), sin(t), t]


plotly()


plot(vvf..., 0, 2pi)


gr()


subs.(vvf, t.=>2)


@syms delta
limit.((subs.(vvf, t .=> t + delta) - vvf) / delta, delta .=> 0)


diff.(vvf, t)


diff.(vvf, t, t)


note("""
If these differences are too subtle, it might be best to work with a function and when a symbolic expression is desirable, simply evaluate the function for a symbolic value.
""")


gravity = 9.8
x0, v0, a = [0,0], [2, 3], [0, -gravity]
xpos(t) = x0 + v0*t + (1/2)*a*t^2

using Roots
t_0 = fzero(t -> xpos(t)[2], 1/10, 100)  # find when y=0

plot_parametric_curve(xpos, 0, t_0)


# https://en.wikipedia.org/wiki/Tractrix
# https://sinews.siam.org/Details-Page/a-bike-and-a-catenary
# https://www.math.psu.edu/tabachni/talks/BicycleDouble.pdf
# https://www.tandfonline.com/doi/abs/10.4169/amer.math.monthly.120.03.199
# https://projecteuclid.org/download/pdf_1/euclid.em/1259158427


using DifferentialEquations, LinearAlgebra

function bicycle(dB, B, p, t)

  a, F = p   # unpack parameters

  speed =  F'(t) ⋅ (F(t) - B) / a
  dB[1], dB[2] = speed * (F(t) - B) / a

end


t0, t1 = 0.0, 4pi
tspan = (t0, t1)  # time span to consider

a = 1
F(t) = 3 * [cos(t), sin(t)]
p = (a, F)      # combine parameters

B0 = F(0) - [0, a]  # some initial position for the back
prob = ODEProblem(bicycle, B0, tspan, p)

out = DifferentialEquations.solve(prob, reltol=1e-6)


plt = plot_parametric_curve(F, t0, t1, legend=false)
plot_parametric_curve!(out,  t0, t1, linewidth=3)

## add the bicycle as a line segment at a few times along the path
for t in range(t0, t1, length=11)
    plot!(unzip([out(t), F(t)])..., linewidth=3, color=:black)
end
plt


a = 1
F(t) = [t, 2sin(t)]
p = (a, F)

B0 = F(0) - [0, a]  # some initial position for the back
prob = ODEProblem(bicycle, B0, tspan, p)

out = DifferentialEquations.solve(prob, reltol=1e-6)
plt = plot_parametric_curve(F, t0, t1, legend=false)
plot_parametric_curve!(t->out(t),  t0, t1, linewidth=3)


a = 1
F(t) = [cos(t), sin(t)] + [cos(2t), sin(2t)]
p = (a, F)

B0 = F(0) - [0,a]
prob = ODEProblem(bicycle, B0, tspan, p)

out = DifferentialEquations.solve(prob, reltol=1e-6)
plt = plot_parametric_curve(F, t0, t1, legend=false)
plot_parametric_curve!(t->out(t),  t0, t1, linewidth=3)


a = 1
F(t) = a/3 * [cos(t), sin(t)]
p = (a, F)

t0, t1 = 0.0, 25pi
tspan = (t0, t1)

B0 = F(0) - [0,a]
prob = ODEProblem(bicycle, B0, tspan, p)

out = DifferentialEquations.solve(prob, reltol=1e-6)
plt = plot_parametric_curve(F, t0, t1, legend=false, aspect_ratio=:equal)
plot_parametric_curve!(t->out(t),  t0, t1, linewidth=3)


u1, u2, u3, v1, v2, v3 = SymFunction("u1, u2, u3, v1, v2, v3")
@vars t
u = [u1(t), u2(t), u3(t)]
v = [v1(t), v2(t), v3(t)]


using LinearAlgebra
diff.(u × v, t)


diff.(u × v, t) - (diff.(u,t) × v + u × diff.(v,t))


x1(t) = [cos(t), 2 * sin(t)]
t0, t1, Delta = 1.0, 2.0, 1/10
plot_parametric_curve(x1, 0, pi/2)

arrow!([0,0], x1(t0)); arrow!([0,0], x1(t0 + Delta))
arrow!(x1(t0), x1(t0+Delta)- x1(t0), linewidth=5)


plotly()


function viviani(t, a=1)
    [a*(1-cos(t)), a*sin(t), 2a*sin(t/2)]
end


Tangent(t) = viviani'(t)/norm(viviani'(t))
Normal(t) = Tangent'(t)/norm(Tangent'(t))
Binormal(t) = Tangent(t) × Normal(t)

p = plot(legend=false, aspect_ratio=:equal)
plot_parametric_curve!(viviani, -2pi, 2pi)

t0, t1 = -pi/3, pi/2 + 2pi/5
r0, r1 = viviani(t0), viviani(t1)
arrow!(r0, Tangent(t0)); arrow!(r0, Binormal(t0)); arrow!(r0, Normal(t0))
arrow!(r1, Tangent(t1)); arrow!(r1, Binormal(t1)); arrow!(r1, Normal(t1))
p


@vars k positive=true
@vars t real=true
r1 = k * [cos(t), sin(t),0]
norm(diff.(r1,t) × diff.(r1,t,t)) / norm(diff.(r1,t))^3 |> simplify


function viviani(t, a=1)
    [a*(1-cos(t)), a*sin(t), 2a*sin(t/2)]
end


@vars t a positive=true
speed = simplify(norm(diff.(viviani(t, a), t)))
integrate(speed, (t, 0, 4*PI))


using QuadGK
quadgk(t -> norm(viviani'(t)), 0, 4pi)


@vars a b t al positive=true
helix = [a*cos(t), a*sin(t), b*t]
speed = simplify( norm(diff.(helix, t)) )
s = integrate(speed, (t, 0, al))


eqn = subs.(helix, t.=> al/sqrt(a^2 + b^2))


simplify(norm(diff.(eqn,al)))


gamma = subs.(helix, t.=> al/sqrt(a^2 + b^2))   # gamma parameterized by arc length
@vars u positive=true
gamma = subs.(gamma, al .=> u)                  # u is arc-length parameterization


T = diff.(gamma, u)
norm(T)


out = diff.(T, u)


kappa = norm(out)
Norm = out/kappa
kappa |> simplify


B = T × Norm
out = diff.(B, u)


Norm


norm(out) |> simplify


gr()
a = 1
F(t) = [cos(pi/2 - t), 2sin(pi/2-t)]
p = (a, F)

t0, t1 = -pi/6, pi/2.75
tspan = (t0, t1)

t = 7pi/6
B0 = F(t0) + a*[cos(t), sin(t)]
prob = ODEProblem(bicycle, B0, tspan, p)

out = DifferentialEquations.solve(prob, reltol=1e-6)
plt = plot_parametric_curve(F, t0, t1, linewidth=3,
                            xticks=nothing, yticks=nothing, border=:none,
                            legend=false, aspect_ratio=:equal)
plot_parametric_curve!(t->out(t),  t0, t1, linewidth=3)

t = pi/4
arrow!(out(t), 2*(F(t) - out(t)))
plot!(unzip([out(t), F(t)])..., linewidth=2)
arrow!(F(t), F'(t)/norm(F'(t)))
Fphat(t) = F'(t)/norm(F'(t))
arrow!( F(t), -Fphat'(t)/norm(Fphat'(t)))
using LaTeXStrings
annotate!([(-.5,1.5,L"k"),
(.775,1.55,L"\kappa"),
(.85, 1.3, L"\alpha")])

plt


#How to compute the curvature k?
#$$~
#\begin{align}
#\frac{d^2\hat{B}}{dv}
#&= \frac{d^2\hat{B}}{du^2} \cdot (\frac{dv}{du})^2 + \frac{d^2v}{du^2} \cdot \hat{B}'(u)\\
#&= \cos^2(\alpha) \cdot (-2\sin(\alpha)\cos(\alpha}\alpha'\vec{U} + \cos^2(\alpha) \kappa \vec{V} - (\cos^2(\alph#a)-\sin^2(\alpha))\alpha'\vec{V} + \sin(\alpha)\cos(\alpha)\kappa \vec{U}) + \frac{\sin(\alpha)}{\cos^2(\alpha) \#cdot (\cos^2(\alpha)\vec{U} - \sin(\alpha)\cos(\alpha) \vec{V})\\
#&=
#
#
#&= \| (1 -\sin(alpha)\sin(\alpha) \vec{U} -\sin(\alpha)\cos(\alpha) \vec{V} \|^2\\
#&= \| \cos^2(\alpha) \vec{U} -\sin(\alpha)\cos(\alpha) \vec{V} \|^2\\
#&= ((\cos^2(alpha))^2 + (\sin(\alpha)\cos(\alpha))^2\quad\text{using } \vec{U}\cdot\vec{V}=0\\
#&= \cos(\alpha)^2.
#\end{align}
#~$$


X(t)= 2cos(t)
Y(t) = sin(t)
r(t) = [X(t),Y(t)]
unit_vec(x) = x/norm(x)
p = plot(legend=false, aspect_ratio=:equal)
ts = range(0, 2pi, length=50)
for t in ts
    P, V = r(t), unit_vec([-Y'(t), X'(t)])
    plot_parametric_curve!(x -> P + x*V, -4, 4 )
end
plot!(X, Y, 0, 2pi, linewidth=5)
p


u, v = SymFunction("u, v")
@vars t epsilon w
@vars a b
γ(t) = [u(t),v(t)]
n(t) = subs.(diff.([-v(w), u(w)], w), w.=>t)
l(a, t) = γ(t) + a * n(t)
out = SymPy.solve(l(a, t) - l(b, t+epsilon), [a,b])
out[a]


unit_vec(x) = x/norm(x)

r(t) = [2cos(t), sin(t), 0]
Tangent(t) = unit_vec(r'(t))
Normal(t) = unit_vec(Tangent'(t))
curvature(t) = norm(r'(t) × r''(t) ) / norm(r'(t))^3

plot_parametric_curve(t -> r(t)[1:2], 0, 2pi, legend=false, aspect_ratio=:equal)
plot_parametric_curve!(t -> (r(t) + Normal(t)/curvature(t))[1:2], 0, 2pi)


r(t) = 2*(1 - cos(t)) * [cos(t), sin(t), 0]

function evolute(r)
    Tangent(t) = unit_vec(r'(t))
    Normal(t) = unit_vec(Tangent'(t))
    curvature(t) = norm(r'(t) × r''(t) ) / norm(r'(t))^3
    t -> r(t) + 1/curvature(t)*Normal(t)
end

plot_parametric_curve(t -> r(t)[1:2], 0, 2pi, legend=false, aspect_ratio=:equal)
plot_parametric_curve!(t -> evolute(r)(t)[1:2], 0, 2pi...)
plot_parametric_curve!(t -> ((evolute∘evolute)(r)(t))[1:2], 0, 2pi)


using QuadGK

r(t) = [t, cosh(t)]
t0, t1 = -2, 0
a = t1

Tangent(t) = unit_vec(r'(t))
beta(t) = r(t) - Tangent(t) * quadgk(t -> norm(r'(t)), a, t)[1]

p = plot_parametric_curve(r, -2, 2, legend=false)
plot_parametric_curve!(beta, t0, t1)
for t in range(t0,-0.2, length=4)
    arrow!(r(t), -Tangent(t) * quadgk(t -> norm(r'(t)), a, t)[1])
    scatter!(unzip([r(t)])...)
end
p


r(t) = [t - sin(t), 1 - cos(t)]
## find *involute*: r - r'/|r'| * int(|r'|, a, t)
t0, t1, a = 2PI, PI, PI
@vars t real=true
rp = diff.(r(t), t)
speed = 2sin(t/2)

ex = r(t) - rp/speed * integrate(speed, a, t)

plot_parametric_curve(r, 0, 4pi, legend=false)
plot_parametric_curve!(u -> SymPy.N.(subs.(ex, t .=> u)), 0, 4pi)


choices = [
q"[0.0782914, 0.292893 ]",
q"[0.181172, 0.5]",
q"[0.570796, 1.0]"]
ans = 1
radioq(choices, ans)


choices = [
q"[0.0782914, 0.292893 ]",
q"[0.181172, 0.5]",
q"[0.570796, 1.0]"]
ans = 3
radioq(choices, ans)


choices = [
L"\langle Rt - r\sin(t),~ R - r\cos(t) \rangle",
L"\langle Rt - R\sin(t),~ R - R\cos(t) \rangle",
L"\langle -r\sin(t),~ -r\cos(t) \rangle"
]
ans = 1
radioq(choices, ans)


choices = [
L"\sqrt{2 - 2\cos(t)}",
L"1",
L"1 - \cos(t)",
L"1 + \cos(t) + \cos(2t)"]
ans = 1
radioq(choices, ans)


γ(s) = 2 * acos(1-s/4)
x1(s) = γ(s) - sin(γ(s))
y1(s) = 1 - cos(γ(s))


radioq(1:3, 1, keep_order=true)


choices = [
q"[1,1]",
q"[2,0]",
q"[0,0]"
]
ans = 1
radioq(choices, ans)


choices = [
q"[1,1]",
q"[2,0]",
q"[0,0]"
]
ans = 2
radioq(choices, ans)


choices = [
L"1",
L"1/R",
L"R",
L"R^2"
]
ans = 3
radioq(choices, ans, keep_order=true)


using Roots
x(t) = 10t
y(t) = 10t - 16t^2
a,b = sort(find_zeros(y, -10, 10))
f(x,y) = 1
val, _ = quadgk(t -> f(x(t), y(t)) * sqrt(D(x)(t)^2 + D(y)(t)^2), a, b)
numericq(val)


choices = [
L"\sqrt{1 + 4t^2}",
L"1 + 4t^2",
L"1",
L"t + t^2"
]
ans = 1
radioq(choices, ans)


val,err = quadgk(t -> (1 + 4t^2)^(1/2), 0, 1)
numericq(val)


@vars t positive=true
rt = [t, t^2, 0]
rp = diff.(rt, t)
rpp = diff.(rt, t, t)
kappa =  norm(rp × rpp) / norm(rp)^3
#val = N(kappa(t=>0)) #2
val = 2
numericq(val)


choices = [
L"greater than the curvature at $t=0$",
L"less than the curvature at $t=0$",
L"the same as the curvature at $t=0$"]
ans = 2
radioq(choices, ans)


choices = [
L"0",
L"\infty",
L"1"
]
ans = 1
radioq(choices, ans)


choices = [
L"2a",
L"2/a",
L"2",
L"1"
]
ans = 1
radioq(choices, ans)


x0 = [0,0,5]
v0 = [120, -2, 2]
a = [0, 16, -32]
r(t) = x0 + v0*t + 1/2*a*t^2
ans = 60/v0[1]
numericq(ans)


t = 1/4
ans = r(t)[2]
numericq(ans)


t = 1/2
ans = abs(r(t)[2]) > 1/2
yesnoq(ans)


a = 1

plot(t -> 0, -2, 2,aspect_ratio=:equal, legend=false)
plot!(t -> 2a)
r(t) = [0, a] + a*[cos(t), sin(t)]
plot!(unzip(r, 0, 2pi)...)
theta = pi/3
plot!([0, 2a/tan(theta)], [0, 2a], linestyle=:dash)
A = [2a*cot(theta), 2a]
B = 2a*sin(theta)^2 *[ 1/tan(theta),1]
scatter!(unzip([A,B])...)
plot!([B[1],A[1],A[1]], [B[2],B[2],A[2]], linestyle=:dash)
delta = 0.2
annotate!([(B[1],B[2]-delta,"B"),(A[1]+delta,A[2]-delta,"A")])
r(theta) = [2a*cot(theta), 2a*sin(theta)^2 ]
theta0 = pi/4
plot!(unzip(r, theta0, pi-theta0)..., linewidth=3)
P = r(theta)
annotate!([(P[1],P[2]-delta, "P")])


choices = [
L"2\cot(\theta)",
L"\cot(\theta)",
L"2\tan(\theta)",
L"\tan(\theta)"
]
ans = 1
radioq(choices, ans)


choices = [
L"2\sin^2(\theta)",
L"2\sin(\theta)",
L"2",
L"\sin(\theta)"
]
ans=1
radioq(choices, ans)


choices = [
L"\frac{\sqrt{n^{2} t^{2 n} + t^{2 n + 2} \left(n + 1\right)^{2}}}{t}",
L"t^n + t^{n+1}",
L"\sqrt{n^2 + t^2}"
]
ans=1
radioq(choices, ans)


choices = [
L"\frac{a^{2} \sqrt{9 a^{2} + 4}}{3} + \frac{4 \sqrt{9 a^{2} + 4}}{27} - \frac{8}{27}",
L"\frac{2 a^{\frac{5}{2}}}{5}",
L"\sqrt{a^2 + 4}"
]
ans = 1
radioq(choices, ans)


choices = [
L"\sqrt{2}",
L"3/2",
L"\pi/2",
L"2"
]
ans = 2
radioq(choices, ans, keep_order=true)


t0, t1 = pi/12, pi/3
tspan = (t0, t1)  # time span to consider

a = 1
r(theta) = -cos(theta) + 4*2cos(theta)*sin(theta)^2
F(t) = r(t) * [cos(t), sin(t)]
p = (a, F)      # combine parameters

B0 = F(0) - [0, a]  # some initial position for the back
prob = ODEProblem(bicycle, B0, tspan, p)

out = DifferentialEquations.solve(prob, reltol=1e-6)

plt = plot(unzip(F, t0, t1)..., legend=false, color=:red)
plot!(plt, unzip(t->out(t),  t0, t1)..., color=:blue)


choices = [
"The front wheel",
"The back wheel"
]
ans=1
radioq(choices, ans)


t0, t1 = 0.0, pi/3
tspan = (t0, t1)  # time span to consider

a = 1
r(t) = 3a * cos(2t)cos(t)
F(t) = r(t) * [cos(t), sin(t)]
p = (a, F)      # combine parameters

B0 = F(0) - [0, a]  # some initial position for the back
prob = ODEProblem(bicycle, B0, tspan, p)

out = DifferentialEquations.solve(prob, reltol=1e-6)

plt = plot(unzip(F, t0, t1)..., legend=false, color=:blue)
plot!(plt, unzip(t->out(t),  t0, t1)..., color=:red)


choices = [
"The front wheel",
"The back wheel"
]
ans=2
radioq(choices, ans)


choices = [
L"The $\hat{T}$ direction",
L"The $\hat{N}$ direction"]
ans = 1
radioq(choices, ans)


choices = [
L"\vec{\gamma} \circ s",
L"ds/dt",
L"d^2s/dt^2"
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"The acceleration in the normal direction depends on both the curvature and the speed ($ds/dt$)",
L"The acceleration in the normal direction depends only on the curvature and not the speed ($ds/dt$)",
L"The acceleration in the normal direction depends only on the speed ($ds/dt$) and not the curvature"
]
ans = 1
radioq(choices, ans)


choices = [
L"1 + 4t^2",
L"1 - 4t^2",
L"1 + 2t",
L"1 - 2t"
]
ans = 1
radioq(choices, ans)


choices = [
L"2",
L"-2",
L"8t",
L"-8t"
]
ans = 1
radioq(choices, ans)


choices = [
L"t - 2t(1 + 4t^2)/2",
L"t - 4t(1+2t)/2",
L"t - 2(8t)/(1-2t)",
L"t - 1(1+4t^2)/2"
]
ans = 1
radioq(choices, ans)


choices = [
L"t^2 + 1(1 + 4t^2)/2",
L"t^2 + 2t(1+4t^2)/2",
L"t^2 - 1(1+4t^2)/2",
L"t^2 - 2t(1+4t^2)/2"
]
ans = 1
radioq(choices, ans)


@vars t a b
x = a*cos(t)
y = b*sin(t)
xp, xpp, yp, ypp = diff(x, t), diff(x,t,t), diff(y,t), diff(y,t,t)
r2 = xp^2 + yp^2
k = xp*ypp - xpp*yp
X = x - yp*r2/k     |> simplify
Y = y + xp * r2 / k |> simplify
[X,Y]


choices = [
L"An astroid of the form $c \langle \cos^3(t), \sin^3(t) \rangle$",
L"An cubic parabola of the form $\langle ct^3, dt^2\rangle$",
L"An ellipse of the form $\langle a\cos(t), b\sin(t)$",
L"A cyloid of the form $c\langle t + \sin(t), 1 - \cos(t)\rangle$"
]
ans = 1
radioq(choices, ans)

