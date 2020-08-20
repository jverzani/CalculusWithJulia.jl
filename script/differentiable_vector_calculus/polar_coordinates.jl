
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


gr()
theta = pi/6
rr = 1

p = plot(xticks=nothing, yticks=nothing, border=:none, aspect_ratio=:equal, xlim=(-.1,1), ylim=(-.1,3/4))
plot!([0,rr*cos(theta)], [0, rr*sin(theta)], legend=false, color=:blue, linewidth=2)
scatter!([rr*cos(theta)],[rr*sin(theta)], markersize=3, color=:blue)
arrow!([0,0], [0,3/4], color=:black)
arrow!([0,0], [1,0], color=:black)
ts = range(0, theta, length=50)
rr = 1/6
plot!(rr*cos.(ts), rr*sin.(ts), color=:black)
plot!([cos(theta),cos(theta)],[0, sin(theta)], linestyle=:dash, color=:gray)
plot!([0,cos(theta)],[sin(theta), sin(theta)], linestyle=:dash, color=:gray)
annotate!([
        (1/5*cos(theta/2), 1/5*sin(theta/2), L"\theta"),
        (1/2*cos(theta*1.2), 1/2*sin(theta*1.2), L"r"),
        (cos(theta), sin(theta)+.05, L"(x,y)"),
        (cos(theta),-.05, L"x"),
        (-.05, sin(theta),L"y")
        ])


x,y = -3, 4
rad, theta = sqrt(x^2 + y^2), atan(y, x)


rad*cos(theta), rad*sin(theta)


gr()

using LaTeXStrings
p = plot([-5,5], [0,0],  color=:blue, legend=false)
plot!([0,0],  [-5,5], color=:blue)
plot!([-3,0], [4,0])
scatter!([-3], [4])
title!("(-3,4) Cartesian or (5, 2.21...) polar")

plotly()
p


using Plots
R, r0, gamma = 1, 1/2, pi/6
r(theta) = r0 * cos(theta-gamma) + sqrt(R^2 - r0^2*sin(theta-gamma)^2)
ts = range(0, 2pi, length=100)
rs = r.(ts)
plot(ts, rs, proj=:polar, legend=false)


plot_polar(r, a, b; kwargs...) = plot(t -> r(t)*cos(t), t -> r(t)*sin(t), a, b; kwargs...)


R=4; r(t) = R;

function plot_general_circle!(r0, gamma, R)
    # law of cosines has if gamma=0, |theta| <= asin(R/r0)
    # R^2 = a^2 + r^2 - 2a*r*cos(theta); solve for a
    r(t) = r0 * cos(t - gamma) + sqrt(R^2 - r0^2*sin(t-gamma)^2)
    l(t) = r0 * cos(t - gamma) - sqrt(R^2 - r0^2*sin(t-gamma)^2)

    if R < r0
        theta = asin(R/r0)-1e-6                 # avoid round off issues
        plot_polar!(r, gamma-theta, gamma+theta)
        plot_polar!(l, gamma-theta, gamma+theta)
	else
		plot_polar!(r, 0, 2pi)
	end
end

plot_polar(r, 0, 2pi, aspect_ratio=:equal, legend=false)
plot_general_circle!(2, 0, 2)
plot_general_circle!(3, 0, 1)


a, k = 4, 5
r(theta) = a * sin(k * theta)
plot_polar(r, 0, pi)


a, b = 4, 2
r(theta) = -b * cos(theta) + 4a * cos(theta) * sin(2theta)
plot_polar(r, 0, 2pi)


a0 = (1/2) * asin(1/8)
plot_polar(r, a0, pi/2 - a0)


plot_polar(r, pi/2 - a0, pi/2)


plot_polar(r, pi/2, pi + a0)


a,b = 4, 2
r(theta) = b + 2a*cos(theta)
plot_polar(r, 0, 2pi)


r(theta) = sqrt(abs(cos(theta/8)))
plot_polar(r, 0, 8pi)


r(theta) = 2(1 + cos(theta))
plot_polar(r, 0, 2pi)


gr()
r(theta) = 1/(1 + (1/3)cos(theta))
p = plot_polar(r, 0, pi/2, legend=false, linewidth=3, aspect_ratio=:equal)
t0, t1, t2, t3 = collect(range(pi/12, pi/2 - pi/12, length=4))

for s in (t0,t1,t2,t3)
  plot!(p, [0, r(s)*cos(s)], [0, r(s)*sin(s)], linewidth=3)
end

for (s0,s1) in ((t0,t1), (t1, t2), (t2,t3))
    s = (s0 + s1)/2
    plot!(p, [0, ])
    plot!(p, [0,r(s)*cos(s)], [0, r(s)*sin(s)])
    ts = range(s0, s1, length=25)
    xs, ys = r(s)*cos.(ts), r(s)*sin.(ts)
    plot!(p, xs, ys)
    plot!(p, [0,xs[1]],[0,ys[1]])
end
p


using SymPy
r(theta) = 2(1 + cos(theta))
@vars theta
(1//2) * integrate(r(theta)^2, (theta, 0, 2PI))


@vars a b
r(theta) = -b*cos(theta) + 4a*cos(theta)*sin(theta)^2
integrate(r(theta)^2, theta) / 2


ex = integrate(r(theta)^2, (theta, PI/6, PI/2)) / 2
ex(a => 1, b=>1)


a,b = 1,1
r(theta) = b + 2a*cos(theta)
p = plot(t->r(t)*cos(t), t->r(t)*sin(t), 0, pi/2 + pi/6,  legend=false, color=:blue)
plot!(p, t->r(t)*cos(t), t->r(t)*sin(t), 3pi/2 - pi/6, pi/2 + pi/6, color=:orange)
plot!(p, t->r(t)*cos(t), t->r(t)*sin(t), 3pi/2 - pi/6, 2pi, color=:blue)

p


@vars a b
r(theta) =  b + 2a*cos(theta)
ex = integrate(r(theta)^2 / 2, (theta, PI/2 + PI/6, 3PI/2 - PI/6))
inner = ex(a=>1, b=>1)


ex = 2 * integrate(r(theta)^2 / 2, (theta, 0, PI/2 + PI/6))
outer = ex(a=>1, b=>1)


outer - inner


r(theta) = 2*(1 + cos(theta))
ds = sqrt(diff(r(theta), theta)^2 + r(theta)^2) |> simplify


quadgk(t -> sqrt(r'(t)^2 + r(t)^2), 0, 2pi)[1]


a, b= 1, PI/4
r(theta) = a * exp(theta * cot(b))
ds = sqrt(diff(r(theta), theta)^2 + r(theta)^2)
integrate(ds, (theta, 0, 1))


dinner = 1 + 5/8
douter = 5 + 1/4
r(b,t) = dinner/2 + b*t
rp(b,t) = b
integrand(b,t) = sqrt((r(b,t))^2 + rp(b,t)^2)  # sqrt(r^2 + r'^2)
n(b) = (douter - dinner)/2/(2*pi*b)
b = find_zero(b -> quadgk(t->integrand(b,t), 0, n(b)*2*pi)[1] - 3700, (1/100000, 1/100))


b * 25.4


x,y = 3 * [cos(pi/8), sin(pi/8)]
numericq(x)


numericq(y)


x,y = -12, -5
r1, theta1 = sqrt(x^2 + y^2), atan(y,x)
numericq(r1)


numericq(theta1)


yesnoq("yes")


r(theta) == 3 * sec(theta -pi/4)
val = r(pi/2)
numericq(val)


val = (r(pi/2)*sin(pi/2) - r(pi/4)*sin(pi/4)) / (r(pi/2)*cos(pi/2) - r(pi/4)*cos(pi/4))
numericq(val)


yesnoq("yes")


r(theta) = 2cos(theta)
g(theta) = r(theta)*cos(theta)
f(theta) = r(theta)*sin(theta)
c = pi/4
val = D(g)(c) / D(f)(c)
numericq(val)


choices = [
"an ellipse",
"a parabola",
"a hyperbola",
"a circle",
"a line"
]
ans = 1
radioq(choices, ans, keep_order=true)


choices = [
"an ellipse",
"a parabola",
"a hyperbola",
"a circle",
"a line"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
"an ellipse",
"a parabola",
"a hyperbola",
"a circle",
"a line"
]
ans = 3
radioq(choices, ans, keep_order=true)


choices = [
L"1/2",
L"\pi/2",
L"1"
]
ans=1
radioq(choices, ans)


r(theta) = sqrt(cos(2theta) * sec(theta)^4)
val, _ = quadgk(t -> r(t)^2/2, -pi/4, pi/4)
numericq(val)


r(theta) = sqrt(cos(2theta))
val, _ = quadgk(t -> sqrt(D(r)(t)^2 + r(t)^2), -pi/4, pi/4)
numericq(val)


r(theta) = sqrt(cos(2theta) * sec(theta)^4)
val, _ = quadgk(t -> sqrt(D(r)(t)^2 + r(t)^2), -pi/4, pi/4)
numericq(val)

