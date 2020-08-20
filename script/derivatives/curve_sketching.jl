
using CalculusWithJulia
using CalculusWithJulia.WeaveSupport
using Plots
nothing


### {{{ sketch_sin_plot }}}
pyplot()
fig_size=(600, 400)



using ForwardDiff
D(f, n=1) = n > 1 ? D(D(f),n-1) : x -> ForwardDiff.derivative(f, float(x))
Base.adjoint(f::Function) = D(f)    # for f' instead of D(f)



function sketch_sin_plot_graph(i)
    f(x) = 10*sin(pi/2*x)  # [0,4]
    deltax = 1/10
    deltay = 5/10

    zs = find_zeros(f, 0-deltax, 4+deltax)
    cps = find_zeros(D(f), 0-deltax, 4+deltax)
    xs = range(0, stop=4*(i-2)/6, length=50)
    if i == 1
        ## plot zeros
        title = "Plot the zeros"
        p = scatter(zs, 0*zs, title=title, xlim=(-deltax,4+deltax), ylim=(-10-deltay,10+deltay), legend=false)
    elseif i == 2
        ## plot extrema
        title = "Plot the local extrema"
        p = scatter(zs, 0*zs, title=title, xlim=(-deltax,4+deltax), ylim=(-10-deltay,10+deltay), legend=false)
        scatter!(p, cps, f.(cps))
    else
        ##  sketch graph
        title = "sketch the graph"
        p = scatter(zs, 0*zs, title=title, xlim=(-deltax,4+deltax), ylim=(-10-deltay,10+deltay), legend=false)
        scatter!(p, cps, f.(cps))
        plot!(p, xs, f.(xs))
    end
    p
end


caption = L"""

After identifying asymptotic behaviours,
a curve sketch involves identifying the $y$ intercept, if applicable; the $x$ intercepts, if possible; and the local extrema. From there a sketch fills in between the points. In this example, the periodic function $f(x) = 10\cdot\sin(\pi/2\cdot x)$ is sketched over $[0,4]$.

"""



n = 8
anim = @animate for i=1:n
    sketch_sin_plot_graph(i)
end

imgfile = tempname() * ".gif"
gif(anim, imgfile, fps = 1)

plotly()
ImageFile(imgfile, caption)


function plotif(f, g, a, b)
       xs = range(a, stop=b, length=251)
       ys = f.(xs)
       cols = [gx < 0 ? :red : :blue for gx in g.(xs)]
       p = plot(xs, ys, color=cols, linewidth=5, legend=false)
       p
end


using CalculusWithJulia


f(x) = sin(x)
plotif(f, f, -2pi, 2pi)


plotif(sin, cos, -2pi, 2pi)


f(x) = sin(pi*x) * (x^3 - 4x^2 + 2)
plotif(f, f', -2, 2)


f(x) = exp(-abs(x)) * cos(pi * x)
plotif(f, f', -3, 3)


f(x) = x^4 - 13x^3 + 56x^2 -92x + 48
rts = find_zeros(f, -10, 10)


cps = find_zeros(f', 1, 6)


f.([0, cps..., 7])


plot(f, 0.5, 6.5)


f(x) = sin(pi*x) * (x^3 - 4x^2 + 2)
cps = find_zeros(f', -2, 2)


plot(f', -2, 2, legend=false)
plot!(zero)
scatter!(cps, 0*cps)


f(x) = sqrt(abs(x^2 - 1))
cps = find_zeros(f', -2, 2)


pts = union(-2, cps, 2)  # this includes the endpoints (a, b) and the critical points
test_pts = pts[1:end-1] + diff(pts)/2 # midpoints of intervals between pts
[test_pts sign.(f'.(test_pts))]


plus_or_minus(x, tol=1e-12) = x > tol ? "+" : (x < -tol ? "-" : "0")
[test_pts plus_or_minus.(f'.(test_pts))]


plot(f', -2, 2)


plot(f, -2, 2)


f(x) = sin(x) - x
@vars x
fp = diff(f(x), x)
cps = solve(fp)


vals = fp.([-1/10, 1/10])
[vals plus_or_minus.(vals)]


vals = fp.(2*pi .+ [-1/10,  1/10])
[vals plus_or_minus.(vals)]


plot(f, -3pi, 3pi)


solveset(fp)


f(x) = x^2
seca(f,a,b) = x -> f(a) + (f(b) - f(a)) / (b-a) * (x-a)
p = plot(f, -2, 3, legend=false, linewidth=5, xlim=(-2,3), ylim=(-2, 9))
plot!(p,seca(f, -1, 2))
a,b = -1, 2; xs = range(a, stop=b, length=50)
plot!(xs, seca(f, a, b).(xs), linewidth=5)
plot!(p,seca(f, 0, 3/2))
a,b = 0, 3/2; xs = range(a, stop=b, length=50)
plot!(xs, seca(f, a, b).(xs), linewidth=5)
p


f(x) = x^2 * exp(-x)
plotif(f, f'', 0, 8)


ips = find_zeros(f'', 0, 8)


ps = [0, 1, 4]
[ps plus_or_minus.(f''.(ps))]


f(x) = x^5 - 2x^4 + x^3
cps = find_zeros(f', -3, 3)


cps = [0.0, 0.6, 1.0]


vals = f''.(cps)
[cps plus_or_minus.(vals)]


plotif(f, f'', -0.25, 1.25)


plus_or_minus.(f'.([-0.1, 0.1]))


f(x) = exp(-x^2/2)
plotif(f, f'', -3, 3)


find_zeros(f'', -3, 3)


f(x) = ( (x-1)*(x-3)^2 ) / (x * (x-2) )
plot(f, -10, 10)


cps = find_zeros(f', -10, 10)
poss_ips = find_zero(f'', (-10, 10))
extrema(union(cps, poss_ips))


trimplot(f, -5, 5)


v(t) = 30/60*t
w(t) = t < 1/2 ? 0.0 : (t > 3/2 ? 1.0 : (t-1/2))
y(t) = 1 / (1 + exp(-t))
y1(t) = y(2(t-1))
y2(t) = y1(t) - y1(0)
y3(t) = 1/y2(2) * y2(t)
plot([v, w, y3], 0, 2)


plot(airyai, -5, 0)  # airyai in `SpecialFunctions` loaded with `CalculusWithJulia`


choices=[
L"(-3.2,-1)",
L"(-5, -4.2)",
L" $(-5, -4.2)$ and $(-2.5, 0)$",
L"(-4.2, -2.5)"]
ans = 3
radioq(choices, ans)


import SpecialFunctions: besselj
p = plot(x->besselj(x, 1), -5,-3)


choices=[
L"(-5.0, -4.0)",
L"(-25.0, 0.0)",
L" $(-5.0, -4.0)$ and $(-4, -3)$",
L"(-4.0, -3.0)"]
ans = 4
radioq(choices, ans)


plot(x->besselj(x, 21), -5,-3)


choices=[
L"(-5.0, -3.8)",
L"(-3.8, -3.0",
L"(-4.7, -3.0)",
L"(-0.17, 0.17)"
]
ans = 3
radioq(choices, ans)


p = plot(x -> 1 / (1+x^2), -3, 3)


choices=[
L"(0.1, 1.0)",
L"(-3.0, 3.0)",
L"(-0.6, 0.6)",
L" $(-3.0, -0.6)$ and $(0.6, 3.0)$"
]
ans = 4
radioq(choices, ans)


f(x) = (x-2)* (x-2.5)*(x-3) / ((x-1)*(x+1))
p = plot(f, -20, -1-.3, legend=false, xlim=(-15, 15), color=:blue)
plot!(p, f, -1 + .2, 1 - .02, color=:blue)
plot!(p, f, 1 + .05, 20, color=:blue)


choices = [
L"Just a horizontal asymptote, $y=0$",
L"Just vertical asymptotes at $x=-1$ and $x=1$",
L"Vertical asymptotes at $x=-1$ and $x=1$ and a horizontal asymptote $y=1$",
L"Vertical asymptotes at $x=-1$ and $x=1$ and a slant asymptote"
]
ans = 4
radioq(choices, ans)


choices = [
"Nothing",
L"That the critical point at $-1$ is a relative maximum",
L"That the critical point at $-1$ is a relative minimum",
L"That the critical point at $0$ is a relative maximum",
       L"That the critical point at $0$ is a relative minimum"
]
ans = 2
radioq(choices, ans, keep_order=true)


choices = [
L" $f(x)$ is continuous at 2",
L" $f(x)$ is continuous and differentiable at 2",
L" $f(x)$ is continuous and differentiable at 2 and has a critical point",
L" $f(x)$ is continuous and differentiable at 2 and has a critical point that is a relative minimum by the second derivative test"
]
ans = 3
radioq(choices, ans, keep_order=true)


f(x)= x^3*exp(-x)
using Roots
cps = find_zeros(D(f), -5, 10)
val = minimum(cps)
numericq(val)


f(x) = x^5 - x + 1
cps = find_zeros(D(f), -3, 3)
val = length(cps)
numericq(val)


f(x) = x^5 - x + 1
cps = find_zeros(D(f,2), -3, 3)
val = length(cps)
numericq(val)


choices = [
"No, it is a relative minimum",
"No, the second derivative test is possibly inconclusive",
"Yes"
]
ans = 1
radioq(choices, ans)


choices = [
"No, it is a relative maximum",
L"No, the second derivative test is possibly inconclusive if $c=0$, but otherwise yes",
"Yes"
]
ans = 2
radioq(choices, ans)


f(x) = exp(-x) * sin(pi*x)
plot(D(f), 0, 3)


yesnoq(true)


f(x) = x^4 - 3x^3 - 2x + 4
plot(D(f,2), -2, 4)


yesnoq("no")


f(x) = (1+x)^(-2)
plot(D(f,2), 0,2)


yesnoq("yes")


f_p(x) = (x-1)*(x-2)^2*(x-3)^2
plot(f_p, 0, 4)


choices = [
L"The critical points are at $x=1$ (a relative minimum), $x=2$ (not a relative extrema), and $x=3$ (not a relative extrema).",
L"The critical points are at $x=1$ (a relative maximum), $x=2$ (not a relative extrema), and $x=3$ (not a relative extrema).",
L"The critical points are at $x=1$ (a relative minimum), $x=2$ (not a relative extrema), and $x=3$ (a relative minimum.",
L"The critical points are at $x=1$ (a relative minimum), $x=2$ (a relative minimum), and $x=3$ (a relative minimum).",
]
ans=1
radioq(choices, ans)


choices = [
L"The function is concave down over $(-\infty, 1)$ and concave up over $(1, \infty)",
L"The function is decreasing over $(-\infty, 1)$ and increasing over $(1, \infty)",
L"The function is negative over $(-\infty, 1)$ and positive over $(1, \infty)",
]
ans = 1
radioq(choices, ans)


choices = ["A zero of the function",
"A critical point for the function",
"An inflection point for the function"]
ans = 3
radioq(choices, ans, keep_order=true)


K, P0, a = 50, 5, exp(1/4)
egrowth(t) = P0 * a^t
lgrowth(t) = K * P0 * a^t / (K + P0*(a^t-1))

plot([egrowth, lgrowth], 0, 5)


yesnoq(true)


yesnoq(true)


using Roots
val = find_zero(D(lgrowth,2), (0, 20))
numericq(val)


choices = [
"The exponential growth model",
"The limit does not exist",
L"The limit is $P_0$"]
ans = 1
radioq(choices, ans)


choices = [
"The function will increase (or decrease) rapidly when the second derivative is large, so there needs to be more points to capture the shape",
"The function will have more curvature when the second derivative is large, so there  needs to be more points to capture the shape",
"The function will be much larger (in absolute value) when the second derivative is large, so there needs to be more points to capture the shape",
]
ans = 2
radioq(choices, ans)


choices = [
"An informative graph only needs to show one or two periods, as others can be inferred.",
"An informative graph need only show a part of the period, as the rest can be inferred.",
L"An informative graph needs to show several periods, as that will allow proper computation for the $y$ axis range."]
ans = 1
radioq(choices, ans)


choices = [
L"A vertical asymptote can distory the $y$ range, so it is important to avoid too-large values",
L"A horizontal asymptote must be plotted from $-\infty$ to $\infty$",
"A slant asymptote must be plotted over a very wide domain so that it can be identified."
]
ans = 1
radioq(choices, ans)


choices = [
"For monotonic regions, a large slope or very concave function might require more care to plot",
"For monotonic regions, a function is basically a straight line",
"For monotonic regions, the function will have a vertical asymptote, so the region should not be plotted"
]
ans = 1
radioq(choices, ans)

